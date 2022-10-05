import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app/constants/color_constant.dart';
import '../../app/utils/utils.dart';
import '../domain.dart';
export 'provider/details_provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController? _itemQuantityController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _itemQuantityController = TextEditingController(text: "0");
    super.initState();
  }

  @override
  void dispose() {
    _itemQuantityController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: _buildBody(context),
    );
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: [
        _buildDetailsUpper(context),
        Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, bottom: 10, right: 10),
              width: AppUtils.appMQ(context: context, flag: 'w'),
              height: AppUtils.appMQ(context: context, flag: 'h') / 1.9,
              decoration: const BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  // color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceH2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity :",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      CustomText(
                          label: "${widget.product.productQuantity} units",
                          fontSize: 16,
                          color: ColorConstants.primaryColor)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                          label: "Unit weight per price: ",
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      CustomText(
                          label: "  ${widget.product.productUnitWeight} grams",
                          fontSize: 14,
                          color: ColorConstants.primaryColor)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    label: 'Product Description',
                    fontWeight: FontWeight.w400,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            label: widget.product.productDescription,
                            fontSize: 14),
                        spaceH1,
                        CustomText(
                            color: ColorConstants.secondaryColor,
                            label:
                                "\nThis product was added at ${DateFormat().format(DateTime.parse(widget.product.productTimestamp))}",
                            fontSize: 12)
                      ],
                    ),
                  ),
                  const Spacer(),
                  prefs.getString("userMetaMuskAddress") ==
                          widget.product.productOwnerID
                      ? const SizedBox()
                      : CommonButtonWithIcon(
                          label: "Add to Cart",
                          icon: Icons.add_shopping_cart,
                          onPressed: () {
                            Cart cart = Cart(
                                productOwnerNumber:
                                    widget.product.productOwnerNumber,
                                productID: widget.product.productID,
                                productThumbnail:
                                    widget.product.productThumbnail,
                                productQuantity:
                                    widget.product.productQuantity.toString(),
                                productOwnerID: widget.product.productOwnerID,
                                productOwnerAvatar: AppUtils.getAvatarImage(
                                    key: widget.product.productOwnerAvatar),
                                productName: widget.product.productName,
                                productPrice: widget.product.productPrice);
                            Provider.of<CartStateManager>(context,
                                    listen: false)
                                .addItemToCart(cart, context);
                          },
                          productModel: widget.product,
                        ),
                ],
              ),
            ))
      ],
    );
  }

  Positioned _buildDetailsUpper(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        width: AppUtils.appMQ(context: context, flag: 'w'),
        height: AppUtils.appMQ(context: context, flag: 'h') / 2,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppUtils.getProductImage(
                    name: widget.product.productThumbnail)))),
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              left: 10,
              child: Card(
                shadowColor: ColorConstants.primaryColor,
                elevation: 5,
                color: Theme.of(context).backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomText(
                          label: widget.product.productName,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    spaceW1,
                    spaceW1,
                    spaceW1,
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomText(
                          label:
                              "${AppUtils.roundToDecimalPlace(decimal: widget.product.productPrice, decimalPlace: 2)} ETH",
                          fontSize: 20,
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return const CustomAppBar(
        isDashboard: false,
        showCart: true,
        showAddProduct: false,
        showNotification: true,
        title: '',
        showProfilePic: true,
        onTransparentBackground: true);
  }
}

class CommonButtonWithIcon extends StatelessWidget {
  const CommonButtonWithIcon(
      {Key? key,
      required this.productModel,
      required this.icon,
      required this.label,
      required this.onPressed})
      : super(key: key);

  final Product productModel;
  final String label;
  final void Function()? onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        height: 50,
        color: ColorConstants.primaryColor,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(label: label, color: Colors.white, fontSize: 16),
            const SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
