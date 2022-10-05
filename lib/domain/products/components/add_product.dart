import 'package:block_agri_mart/app/constants/text.dart';
import 'package:block_agri_mart/app/constants/color_constant.dart';
import 'package:block_agri_mart/app/utils/product_utils.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/notifications/models/notification_model.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:block_agri_mart/domain/products/products.dart';
import 'package:block_agri_mart/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/utils/utils.dart';
import '../../../app/widgets/custom_text.dart';
import '../../../app/widgets/custom_textfield.dart';
import '../provider/product_provider.dart';
import 'package:flutter/services.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productPriceController;
  late TextEditingController _productQuantityController;
  late TextEditingController _productDiscountController;
  late TextEditingController _productDescriptionController;
  bool _isUploading = false;
  String _selectedProductName = "Pineapple";
  late String _selectedProductWeightUnit = "Grams";

  @override
  void initState() {
    _productPriceController = TextEditingController();
    _productDiscountController = TextEditingController();
    _productQuantityController = TextEditingController();
    _productDescriptionController = TextEditingController();

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
        resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(
            showCart: false,
            showProfilePic: true,
            title: 'Add Product',
            showAddProduct: false,
            isDashboard: false,
            showNotification: false,
            onTransparentBackground: false),
        body: _buildProductUploadForm(context),
      ),
    );
  }

  Container _buildProductUploadForm(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.only(top: 5),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSelectProductName(context),
                _buildProductImage(context),
                // _buildSelectUnit(context),
                spaceH1,
                _buildProductPrice(context),
                spaceH1,

                CustomText(
                  label:
                      "Minimum Price : \t ${ProductUtils.productNames[_selectedProductName.toLowerCase()]![0]} ETH",
                  fontSize: 12,
                  color: Colors.red,
                ),
                spaceH2,

                CustomText(
                  label:
                      "Maximum Price: \t  ${ProductUtils.productNames[_selectedProductName.toLowerCase()]![1]} ETH ",
                  fontSize: 12,
                  color: Colors.red,
                ),
                spaceH2,
                CustomText(
                  label:
                      "Unit weight : \t ${ProductUtils.productNames[_selectedProductName.toLowerCase()]![2]} grams.",
                  fontSize: 12,
                  color: Colors.red,
                ),
                spaceH1,
                // _buildPriceQuantityGenerator(),
                spaceH1,
                _buildProductDiscount(context),
                _buildProductDescription(),
                _buildPreviewProductButton(context)
              ],
            ),
          ),
        ));
  }

  Container _buildSelectProductName(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 3),
      height: 70,
      width: AppUtils.appMQ(context: context, flag: 'w'),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const CustomText(
            label: "Select product: ",
            fontSize: 16,
            fontWeight: FontWeight.w700),
        const SizedBox(
          width: 10,
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            height: 35,
            width: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border:
                  Border.all(width: 1.5, color: ColorConstants.primaryColor),
            ),
            child: DropdownButton<String>(
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 12),
                elevation: 5,
                dropdownColor: Theme.of(context).backgroundColor,
                underline: Container(),
                value: _selectedProductName,
                items: AppUtils.sortString(TextConstant.productNames)
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProductName = value!;
                  });
                  // _productPriceController.clear();
                })),
      ]),
    );
  }

  Widget _buildProductPrice(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
              // initialValue: widget.product.productWeight,
              labelStyle: TextStyle(color: ColorConstants.primaryColor),
              hintText: 'Price',
              validator: (value) {},
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
                LengthLimitingTextInputFormatter(15)
              ],
              onChanged: (value) {},
              controller: _productPriceController,
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
        ),
        spaceW1,
        Expanded(
          child: CustomTextFormField(
              // initialValue: widget.product.productWeight,
              labelStyle: TextStyle(color: ColorConstants.primaryColor),
              hintText: 'Quantity',
              validator: validateFields,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
              
                          FilteringTextInputFormatter.allow(RegExp(r'(^[1-9]\d{0,8}$)',  multiLine: true)),

              
              ],
              onChanged: (value) {},
              controller: _productQuantityController,
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
        ),
      ],
    );
  }

  Widget _buildProductDiscount(BuildContext context) {
    return CustomTextFormField(
        labelStyle: TextStyle(color: ColorConstants.primaryColor),
        hintText: 'Eg. 5',
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'(^[1-9]\d{0,2}$)', multiLine: true)),
          // LengthLimitingTextInputFormatter(3)
        ], 
        helperText: "",
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: _productDiscountController,
        border: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: ColorConstants.primaryColor)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: ColorConstants.primaryColor)),
        enabledBoarder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: ColorConstants.primaryColor)),
        label: const Text('Discount'));
  }

  Container _buildProductDescription() {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: CustomTextFormField(
          minLines: 3,
          maxLines: 5,
          validator: validateFields,
          labelStyle: TextStyle(color: ColorConstants.primaryColor),
          hintText: 'Product Description ',
          helperText: 'Only 300 characters are allowed',
          controller: _productDescriptionController,
          inputFormatters: [LengthLimitingTextInputFormatter(300)],
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          enabledBoarder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: ColorConstants.primaryColor)),
          label: const Text('Product Description')),
    );
  }

  Container _buildProductImage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 120,
      width: AppUtils.appMQ(context: context, flag: 'w'),
      decoration: BoxDecoration(
          color: ColorConstants.primaryColor.withOpacity(0.1),
          border: Border.all(color: ColorConstants.primaryColor),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage(AppUtils.getProductImage(
                  name: _selectedProductName.toLowerCase())),
              fit: BoxFit.cover)),
    );
  }

  Container _buildPreviewProductButton(BuildContext context) {
    return Container(
        width: AppUtils.appMQ(context: context, flag: 'w') - 30,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Expanded(
          child: MaterialButton(
            color: ColorConstants.primaryColor,
            height: 50,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                try {
                  bool checkPriceInputRange = (double.parse(
                              _productPriceController.text.trim().isEmpty
                                  ? "0"
                                  : _productPriceController.text.trim())) >
                          ProductUtils.productNames[
                              _selectedProductName.toLowerCase()]![0] &&
                      (double.tryParse(
                              _productPriceController.text.trim().isEmpty
                                  ? "0"
                                  : _productPriceController.text))! <=
                          ProductUtils.productNames[
                              _selectedProductName.toLowerCase()]![1];

                  if (checkPriceInputRange) {
                    _showProductReviewDialog();
                  } else {
                    AppUtils.showCustomSnackBarWithoutAction(
                      context: context,
                      label: 'Price entered is not in the accepted price range',
                    );
                  }
                } catch (e) {
                  print("Error In Preview Button: $e");
                }
              }
            },
            child: const Text(
              "Preview Product",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ));
  }

  Future<bool?> _showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor.withOpacity(1),
            title: Text(
              "Are you done uploading products?",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontSize: 18, fontFamily: 'Quicksand', fontWeight: bold),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    "No",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Quicksand'),
                  ),
                  onPressed: () => Navigator.pop(context, false)),
              MaterialButton(
                  child: Text(
                    "Yes",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Quicksand'),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                    _resetFields();
                  })
            ],
          ));

  _showProductReviewDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              backgroundColor: Theme.of(context).backgroundColor.withOpacity(1),
              content: StatefulBuilder(builder: (context, setState) {
                return Container(
                    height:
                        AppUtils.appMQ(context: context, flag: 'h') * (3 / 4),
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _isUploading = false;
                                  });
                                },
                                icon: const Icon(Icons.clear)),
                            const Center(
                              child: CustomText(
                                label: 'Product Preview',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: AppUtils.appMQ(context: context, flag: 'h') *
                              (1 / 4),
                          width: AppUtils.appMQ(context: context, flag: 'w'),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(AppUtils.getProductImage(
                                  name: _selectedProductName.toLowerCase())),
                            ),
                          ),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelValueText(
                                    label: 'Name\n',
                                    value: _selectedProductName),

                                LabelValueText(
                                    label: 'Category\n',
                                    value: AppUtils.getCategory(
                                        value: _selectedProductName
                                            .toLowerCase())),
                                LabelValueText(
                                    label: 'Total Price\n',
                                    value: AppUtils.roundToDecimalPlace(
                                                decimal: double.parse(
                                                        _productQuantityController
                                                            .text) *
                                                    double.parse(
                                                        _productPriceController
                                                            .text),
                                                decimalPlace: 3)
                                            .toString() +
                                        " ETH"),
                                // , const  SizedBox(height: 3,),
                                LabelValueText(
                                    label: 'Unit Price\n',
                                    value: AppUtils.roundToDecimalPlace(
                                                decimal: double.parse(
                                                    _productPriceController
                                                        .text),
                                                decimalPlace: 3)
                                            .toString() +
                                        " ETH"),
                                LabelValueText(
                                    label: 'Quantity\n',
                                    value: _productQuantityController.text +
                                        " units"),
                                LabelValueText(
                                    label: 'Discount\n',
                                    value:
                                        "${_productDiscountController.text.isEmpty ? 0 : AppUtils.roundToDecimalPlace(decimal: ProductUtils.getProductDiscount(discount: double.tryParse(_productDiscountController.text.trim())!), decimalPlace: 2) * 100} %"),
                                LabelValueText(
                                    label: 'Description\n',
                                    value: _productDescriptionController.text),
                              ],
                            ),
                          ),
                        ),
                        _buildProductUploadButton(context, setState)
                      ],
                    ));
              }),
            ));
  }

  Container _buildProductUploadButton(
      BuildContext context, StateSetter setState) {
    return Container(
      width: AppUtils.appMQ(context: context, flag: 'w') - 30,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Flexible(
        child: MaterialButton(
          color: ColorConstants.primaryColor,
          height: 50,
          onPressed: () {
            try {
              setState(() {
                _isUploading = true;
              });

              Product product = Product(
                productOwnerNumber: prefs.getString('userPhonenumber')!,

                productUnitWeight: ProductUtils
                    .productNames[_selectedProductName.toLowerCase()]![2]
                    .toString(),
                productCategory: AppUtils.getCategory(
                    value: _selectedProductName.toLowerCase()),
                productTimestamp: DateTime.now().toIso8601String(),
                productDescription: _productDescriptionController.text,
                productDiscount: ProductUtils.getProductDiscount(
                    discount: double.parse( 
                        _productDiscountController.text.isEmpty
                            ? "0"
                            : _productDiscountController.text)),
                productID: AppUtils.generateProductID(
                    userAddress: prefs.getString('userMetaMuskAddress')!,
                    productName: _selectedProductName),
                productThumbnail: _selectedProductName.toLowerCase(),
                productName: _selectedProductName,
                productOwnerAvatar: prefs.getInt('userAvatar')!,
                productOwnerID: prefs.getString('userMetaMuskAddress')!,
                productPrice: double.parse(_productPriceController.text),
                productQuantity: int.tryParse(_productQuantityController.text)!,
              );

              NotificationModel notification = NotificationModel(
                  notificationID: product.productID +
                      product.productOwnerID.substring(
                        0,
                        product.productOwnerID.length ~/ 4,
                      ),
                  notificationTitle: "New product is added",
                  notificationOpened: false,
                  notificationMessage:
                      "Miner ${product.productOwnerID} has added a new product ${product.productName}",
                  notificationTimeStamp: DateTime.now().toIso8601String());

              FirebaseFirestore.instance
                  .collection('products')
                  .doc(product.productID)
                  .set(product.toJson())
                  .then((res) {
                print("Result: ");
                FirebaseFirestore.instance
                    .collection('miners')
                    .doc(product.productOwnerID)
                    .update({"numberOfProducts": FieldValue.increment(1)}).then(
                        (value) {
                  FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(notification.notificationID)
                      .set(notification.toJson());
                  setState(() {
                    _isUploading = false;
                  });
                  Navigator.pop(context);
                  AppUtils.showCustomSnackBarWithoutAction(
                    context: context,
                    label: 'Product uploaded successfully.',
                  );
                }, onError: (error) {
                  print("Error: $error");
                  setState(() {
                    _isUploading = false;
                  });
                  Navigator.pop(context);
                  AppUtils.showCustomSnackBarWithoutAction(
                    context: context,
                    label: 'Something went wrong. Try Again',
                  );
                });
              }, onError: (error) {
                print("Error: $error");
                setState(() {
                  _isUploading = false;
                });
                Navigator.pop(context);
                AppUtils.showCustomSnackBarWithoutAction(
                  context: context,
                  label: 'Something went wrong. Try Again',
                );
              });
            } catch (e) {
              print("Error In dialog preview: $e");
            }
          },
          child: Text(
            _isUploading ? "Uploading..." : "Upload Product",
            style: const TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  String? validateFields(String? value) {
    return value!.isEmpty ? "Input invalid" : null;
  }

  _resetFields() {
    _productPriceController.text = '1.0';
    _productDiscountController.text = '1.0 ';
    _productDescriptionController.text = 'Enter product description ';
    setState(() {
      _selectedProductName = 'Pineapple';
      _selectedProductWeightUnit = "Grams";
    });
  }
}

class LabelValueText extends StatelessWidget {
  const LabelValueText({
    Key? key,
    required this.label,
    required this.value,
    this.color,
  }) : super(key: key);

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: RichText(
          text: TextSpan(
              style:
                  Theme.of(context).textTheme.headline3!.copyWith(fontSize: 14),
              text: label,
              children: [
            TextSpan(
                style: TextStyle(color: color ?? Colors.teal, fontSize: 12),
                text: value),
          ])),
    );
  }
}

class UnitPrice extends StatelessWidget {
  const UnitPrice({
    required this.quantity,
    Key? key,
  }) : super(key: key);

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: RichText(
          text: TextSpan(
              text: 'Unit Price\n',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.w600),
              children: [
            TextSpan(
              text:
                  '${context.watch<ProductStateManager>().totalProductPrice / quantity}  ETH',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.w600, color: Colors.red.shade400),
            )
          ])),
    );
  }
}

class TotalSellingPrice extends StatelessWidget {
  const TotalSellingPrice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: RichText(
          text: TextSpan(
              text: 'Total Selling Price\n',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.w600),
              children: [
            TextSpan(
              text:
                  '${context.watch<ProductStateManager>().totalProductPrice} ETH',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.w600, color: Colors.red.shade400),
            )
          ])),
    );
  }
}
