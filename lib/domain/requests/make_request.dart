import 'dart:developer' as developer;
import 'dart:ffi';

import 'package:block_agri_mart/app/utils/product_utils.dart';
import 'package:block_agri_mart/app/widgets/widgets.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/requests/model/make_request_model.dart';
import 'package:block_agri_mart/domain/requests/model/request_model.dart';
import 'package:block_agri_mart/domain/transactions/transactions.dart';
import 'package:block_agri_mart/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/constants/text.dart';
import '../../app/constants/color_constant.dart';
import '../../app/utils/utils.dart';
import '../../app/widgets/custom_textfield.dart';

class MakeRequest extends StatefulWidget {
  const MakeRequest({Key? key}) : super(key: key);

  @override
  State<MakeRequest> createState() => _MakeRequestState();
}

class _MakeRequestState extends State<MakeRequest> {
  bool _confirmRequest = false;
  String _productNameSelected = "Onion";
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerPriceToPay =
      TextEditingController(text: '0');
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<MakeRequestModel> itemsRequested = [];

  String _requestStatus = "Make Request";
  Color _requestStatusColor = ColorConstants.primaryColor;

  // Accumulates the total minimum price of products requested
  double _requestMinTotalPrice = 0.0;
  double _requestMaxTotalPrice = 0.0;

  Future<bool?> _showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor.withOpacity(1),
            title: Text(
              "Are you done making a request?",
              style:
                  Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    "No",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 12),
                  ),
                  onPressed: () => Navigator.pop(context, false)),
              MaterialButton(
                  child: Text(
                    "Yes",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  })
            ],
          ));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(
            showCart: true,
            showProfilePic: true,
            showAddProduct: false,
            title: 'Make Request',
            isDashboard: false,
            showNotification: false,
            onTransparentBackground: false),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: _buildMakeRequestForm(context),
        ),
        bottomNavigationBar: Container(
          // height: 100,
          // color: Colors.red,
          padding: const EdgeInsets.all(8.0),
          child: _buildMakeRequestButton(context),
        ),
      ),
    );
  }

  Form _buildMakeRequestForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Flexible(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildSelectProductName(context),
            spaceH1,
            _buildQuantityFieldAndAddButton(),
            spaceH1,
            _buildPriceField(),
            spaceH1,
            CustomText(
                label:
                    'Minimum Total Price: ${AppUtils.roundToDecimalPlace(decimal: _requestMinTotalPrice, decimalPlace: 4)} ETH'),
            CustomText(
                label:
                    'Maximum Total Price: ${AppUtils.roundToDecimalPlace(decimal: _requestMaxTotalPrice, decimalPlace: 4)} ETH'),
            spaceH1,
            _buildConfirmDetailsCheck(),
            spaceH1,
            _buildItemsRequestedSection(),
          ],
        ),
      ),
    );
  }

  SizedBox _buildPriceField() {
    return SizedBox(
      child: CustomTextFormField(
          labelStyle: TextStyle(color: ColorConstants.primaryColor),
          hintText: 'Price',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
            LengthLimitingTextInputFormatter(15)
          ],
          onChanged: (value) {
            setState(() {});
          },
          controller: _controllerPriceToPay,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          enabledBoarder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          label: const Text('Price')),
    );
  }

  Widget _buildItemsRequestedSection() {
    return Flexible(
      child: CustomSectionTitleAndTiles(
          sectionName: 'Items Requested',
          sectionBody: itemsRequested.isEmpty
              ? const Center(
                  child: CustomText(
                    label: 'No products Requested',
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  reverse: false,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => ListTile(
                        trailing: IconButton(
                          onPressed: () {
                            _requestMaxTotalPrice = _requestMaxTotalPrice -
                                itemsRequested[index].productMaxPrice!;
                            _requestMinTotalPrice = _requestMinTotalPrice -
                                itemsRequested[index].productMinPrice!;
                            itemsRequested.removeAt(index);

                            setState(() {});
                          },
                          icon: Icon(
                            Icons.delete,
                            color: ColorConstants.alertColor,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(AppUtils.getProductImage(
                              name: itemsRequested[index]
                                  .productName!
                                  .toLowerCase())),
                        ),
                        title: CustomText(
                          label: itemsRequested[index].productName!,
                          fontSize: 14,
                        ),
                        subtitle: CustomText(
                          label:
                              "Quantity: ${itemsRequested[index].productQuantity!} units",
                          fontSize: 10,
                        ),
                      ),
                  separatorBuilder: (context, index) => spaceH1,
                  itemCount: itemsRequested.length)),
    );
  }

  Row _buildQuantityFieldAndAddButton() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildQuantityField()),
        spaceW1,
        Expanded(
            child: CommonButton(
                bgColor: ColorConstants.secondaryColor,
                label: 'Add',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      itemsRequested.add(MakeRequestModel(
                          productName: _productNameSelected,
                          productMaxPrice:
                              (int.tryParse(_controllerQuantity.text)! *
                                  ProductUtils.productNames[
                                      _productNameSelected.toLowerCase()]![1]),
                          productMinPrice:
                              (int.tryParse(_controllerQuantity.text)! *
                                  ProductUtils.productNames[
                                      _productNameSelected.toLowerCase()]![0]),
                          productQuantity:
                              int.tryParse(_controllerQuantity.text)));

                      // Add the minimum price for each item requested
                      _requestMinTotalPrice = _requestMinTotalPrice +
                          (itemsRequested[itemsRequested.length - 1]
                              .productMinPrice!);
                      _requestMaxTotalPrice = _requestMaxTotalPrice +
                          (itemsRequested[itemsRequested.length - 1]
                              .productMaxPrice!);
                    });

                    developer.log("Min Total Price: $_requestMinTotalPrice");
                    developer.log("Items requested: $itemsRequested");
                  }
                }))
      ],
    );
  }

  Container _buildMakeRequestButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Expanded(
              child: MaterialButton(
            height: 45,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: _requestStatusColor,
            disabledColor: ColorConstants.primaryColor.withOpacity(0.3),
            child: Text(
              _requestStatus,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _confirmRequest
                      ? Colors.white
                      : Theme.of(context).iconTheme.color),
            ),
            onPressed: _confirmRequest && itemsRequested.isNotEmpty
                ? () {
                    bool checkPriceInputRange = (double.tryParse(
                                _controllerPriceToPay.text.trim()))! >
                            _requestMinTotalPrice &&
                        (double.tryParse(_controllerPriceToPay.text.trim()))! <=
                            _requestMaxTotalPrice;

                    if (checkPriceInputRange) {
                      final productRequestedInJson = <Map<String, dynamic>>[];
                      itemsRequested.forEach((request) {
                        productRequestedInJson.add(request.toJson());
                      });

                      setState(() {
                        _requestStatus = "Making Request...";
                        _requestStatusColor =
                            ColorConstants.secondaryColor.withOpacity(0.5);
                      });

                      RequestModel requestModel = RequestModel(
                          requestID: RequestUtils.generateRequestID(
                              minerID: prefs.getString('userMetaMuskAddress')!),
                          requestedProducts: productRequestedInJson,
                          requestedAcceptedBy: '',
                          requestedStatus: 1,
                          requestedProductsTotalPriceToPay: double.tryParse(
                              _controllerPriceToPay.text.trim()),
                          requestedProductsMaxTotalPrice: _requestMaxTotalPrice,
                          requestedProductsMinTotalPrice: _requestMinTotalPrice,
                          requestedAt: DateTime.now().toIso8601String(),
                          requestedBy: prefs.getString('userMetaMuskAddress')!);

                      FirebaseFirestore.instance
                          .collection('requests')
                          .doc(requestModel.requestID)
                          .set(requestModel.toJson())
                          .then((value) {
                        setState(() {
                          _requestStatus = "Make Request";
                          _requestStatusColor = ColorConstants.primaryColor;
                          itemsRequested.clear();
                        });

                        AppUtils.showCustomSnackBarWithoutAction(
                          context: context,
                          label: 'Product request is successfully made',
                        
                          duration: 3,
                        );
                      }).onError((error, stackTrace) {
                        setState(() {
                          _requestStatus = "Make Request";
                          _requestStatusColor = ColorConstants.primaryColor;
                        });
                        AppUtils.showCustomSnackBarWithoutAction(
                          context: context,
                          label:
                              'Product request was unsuccessful. Please check your internet connect and try again',
                     
                          duration: 5,
                        );
                      }).timeout(const Duration(seconds: 15), onTimeout: () {
                        setState(() {
                          _requestStatus = "Make Request";
                          _requestStatusColor = ColorConstants.primaryColor;
                        });
                        AppUtils.showCustomSnackBarWithoutAction(
                          context: context,
                          label:
                              'Request has been saved to local. It will be upload when you have a stable internet connect. ',
                      
                          duration: 5,
                        );

                        // AppUtils.showCustomSnackBar(
                        //   context: context,
                        //   label:
                        //       'Product request was unsuccessful. Please check your internet connect and try again',
                        //   actionLabel: '',
                        //   onPressedAction: () {},
                        //   duration: 5,
                        // );
                      });  
                    } else {
                      AppUtils.showCustomSnackBarWithoutAction(
                        context: context,
                        label:
                            'The price you have inputted is out of the specified price range.',                   
                        duration: 5,
                      );
                    }
                  }
                : null,
          )),
        ],
      ),
    );
  }

  _resetField() {}

  SizedBox _buildConfirmDetailsCheck() {
    return SizedBox(
      height: 45,
      child: CheckboxListTile(
          value: _confirmRequest,
          selected: _confirmRequest,
          contentPadding: EdgeInsets.zero,
          title: Text(
            "Check to confirm request. ",
            style: TextStyle(
              color: Colors.red.shade400,
            ),
          ),
          checkboxShape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).iconTheme.color!)),
          activeColor: ColorConstants.primaryColor,
          onChanged: (value) {
            setState(() {
              _confirmRequest = value!;
            });
          }),
    );
  }

  SizedBox _buildQuantityField() {
    return SizedBox(
      child: CustomTextFormField(
          labelStyle: TextStyle(color: ColorConstants.primaryColor),
          hintText: 'Quantity',
          validator: (value) {
            return value!.isEmpty ? 'This field can not be empty' : null;
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
            LengthLimitingTextInputFormatter(15)
          ],
          onChanged: (value) {
            setState(() {});
          },
          controller: _controllerQuantity,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          enabledBoarder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          label: const Text('Quantity')),
    );
  }

  Widget _buildSelectProductName(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Text(
              "Select Product: ",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          Container(
            height: 35,
            width: 140,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(width: 1.5, color: ColorConstants.primaryColor)),
            child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                dropdownColor: Theme.of(context).backgroundColor.withOpacity(1),
                underline: Container(),
                value: _productNameSelected,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 14),
                items: TextConstant.productNames.map((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _productNameSelected = value!);
                }),
          ),
        ],
      ),
    );
  }
}
