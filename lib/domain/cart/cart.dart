import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/widgets.dart';
import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants/color_constant.dart';
import '../domain.dart';

export 'provider/cart_provider.dart';
export 'components/components.dart';
export './provider/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _itemQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _itemQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _buildAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: context
              .watch<CartStateManager>()
              .productsInCart
              .isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((context) => AlertDialog(
                          title: Text(
                            "Do you want to empty cart?",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          backgroundColor: Theme.of(context).backgroundColor,
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "No",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(fontSize: 14),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                context.read<CartStateManager>().emptyCart();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Yes",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(fontSize: 14),
                              ),
                            )
                          ],
                        )));
              },
              label: const CustomText(
                label: 'Clear Cart',
                color: Colors.white,
              ),
              backgroundColor: ColorConstants.primaryColor,
              icon: const Icon(Icons.clear_all, color: Colors.white),
            )
          : const SizedBox(),
      body: SafeArea(
          child: context.watch<CartStateManager>().productsInCart.isNotEmpty
              ? CartBody(
                  itemQuantityController: _itemQuantityController,
                )
              : const EmptyCart()),
      bottomNavigationBar:
          context.watch<CartStateManager>().productsInCart.isNotEmpty
              ? const CartBottomWidget()
              : const SizedBox(),
    );
  }

  CustomAppBar _buildAppBar() {
    return const CustomAppBar(
        showCart: false,
        showProfilePic: true,
        showAddProduct: false,
        title: 'Cart',
        isDashboard: false,
        showNotification: true,
        onTransparentBackground: false);
  }
}

class CartBottomWidget extends StatelessWidget {
  const CartBottomWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 80,
      padding: const EdgeInsets.only(top: 3),
      color: Theme.of(context).backgroundColor.withOpacity(0.85),
      child: Container(
        height: 60,
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      Chip(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          avatar: CircleAvatar(
                              backgroundColor:
                                  ColorConstants.primaryColor.withOpacity(0.8),
                              child: const Icon(
                                Icons.currency_bitcoin,
                                color: Colors.white,
                              )),
                          label: Text(
                            context
                                .watch<CartStateManager>()
                                .totalCost
                                .toStringAsFixed(4),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                )),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      minWidth: 200,
                      height: 35,
                      color: ColorConstants.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Checkout",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.forward,
                            color: Colors.white,
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Checkout()));
                      }),
                ))
          ],
        ),
      ),
    );
  }
}

class CartBody extends StatelessWidget {
  const CartBody({Key? key, required this.itemQuantityController})
      : super(key: key);

  final TextEditingController itemQuantityController;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView.separated(
          itemCount: context.watch<CartStateManager>().productsInCart.length,
          itemBuilder: (BuildContext context, int index) {
            Cart cartModel = context
                .watch<CartStateManager>()
                .productsInCart
                .elementAt(index);
            return CartCard(
              productOwnerAvatar: cartModel.productOwnerAvatar,
              productImageURL: cartModel.productThumbnail,
              productName: cartModel.productName,
              productPrice: cartModel.productPrice,
              onTap: () {},
              onDelete: () {
                context
                    .read<CartStateManager>()
                    .removeProductFormCartAt(productID: cartModel.productID);
                context.read<CartStateManager>().calculateTotalCost();
              },
              productQuantity: int.parse(cartModel.productQuantity),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 5,
            );
          },
        ));
  }
}

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.productImageURL,
    required this.onDelete,
    required this.productName,
    required this.onTap,
    required this.productOwnerAvatar,
    required this.productPrice,
    required this.productQuantity,
  }) : super(key: key);

  final String productName;
  final double productPrice;
  final String productImageURL;
  final int productQuantity;
  final String productOwnerAvatar;
  final void Function()? onTap;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        // overlayColor: MaterialStateProperty.all<Color>(Colors.orange.shade200),
        highlightColor: (Colors.teal.shade400),
        onTap: onTap,
        child: Ink(
          child: Container(
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        ColorConstants.primaryColor.withOpacity(0.5),
                        ColorConstants.primaryColor.withOpacity(0.4),
                        ColorConstants.primaryColor.withOpacity(0.3),
                        ColorConstants.primaryColor.withOpacity(0.2),
                        ColorConstants.primaryColor.withOpacity(0.1),
                      ])),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(AppUtils.getProductImage(
                                name: productImageURL))),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 5,
                            top: 5,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundImage:
                                    AssetImage(productOwnerAvatar)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          // color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // const Spacer(
                            //   flex: 1,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  productName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.w600),
                                ),
                                IconButton(
                                    onPressed: onDelete,
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                            // const Spacer(
                            //   flex: 2,
                            // ),
                            CustomText(
                                label: "$productPrice ETH",
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                            spaceH1,
                            Flexible(
                                flex: 2,
                                child: Text(
                                  '$productQuantity units',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                )),
                          ],
                        )),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
