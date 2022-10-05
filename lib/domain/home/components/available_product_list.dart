import 'dart:core';
import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/utils/utils.dart';
import '../../../app/widgets/custom_elevated_button.dart';
import '../../../app/widgets/custom_text.dart';
import '../../../app/widgets/shimmer_widget.dart';
import '../../products/components/product_card.dart';

class ProductList extends StatelessWidget {
  const ProductList(
      {Key? key,
      required this.allStream,
      required this.vegetableStream,
      required this.categoryCardSelected,
      required this.cerealStream,
      required this.fruitStream})
      : super(key: key);
  final Stream<List<Product>> allStream;
  final Stream<List<Product>> vegetableStream;
  final Stream<List<Product>> cerealStream;
  final Stream<List<Product>> fruitStream;
  final int categoryCardSelected;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IndexedStack(
        // alignment: Alignment.center,
        index: categoryCardSelected,
        children: [
          ProductsStream(
            stream: allStream,
          ),
          ProductsStream(
            stream: vegetableStream,
          ),
          ProductsStream(
            stream: fruitStream,
          ),
          ProductsStream(
            stream: cerealStream,
          ),
        ],
      ),
    );
  }
}

class ProductsStream extends StatelessWidget {
  const ProductsStream({Key? key, required this.stream}) : super(key: key);

  final Stream<List<Product>>? stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: CustomText(
                                label: 'No Products',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // context.watch<AppStateManager>().userType ==
                            //         "seller"
                            //     ? MaterialButton(
                            //         color: ColorConstants.primaryColor,
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(10)),
                            //         height: 45,
                            //         onPressed: () {
                            //           AppUtils.navigatePush(
                            //               context: context,
                            //               destination:
                            //                   const AddProductScreen());
                            //         },
                            //         child: const CustomText(
                            //           label: "Add Product",
                            //           color: Colors.white,
                            //         ))
                            //     : const SizedBox(),
                          ],
                        )),
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 6 / 5,
                    ),
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      Product product = snapshot.data![index];
                      return ProductCard(
                        productOwner: product.productOwnerID,
                        width: AppUtils.appMQ(context: context, flag: 'w'),
                        height: AppUtils.appMQ(context: context, flag: 'h'),
                        productThumbnail: product.productThumbnail,
                        itemTitle: product.productName,
                        onPressedAddFav: () {
                          AppUtils.addFavorite(
                              context: context,
                              id: product.productName,
                              productName: product.productName);
                          AppUtils.showCustomSnackBarWithoutAction(
                            duration: 1,
                            context: context,
                            label:
                                "${product.productName} is added to favorites.",
                          );
                        },
                        itemPrice: product.productPrice,
                        sellerThumbnail: product.productOwnerAvatar,
                        onPressedAddCart: () {
                          Cart cart = Cart(
                              productOwnerNumber: product.productOwnerNumber,
                              productID: product.productID,
                              productThumbnail: product.productThumbnail,
                              productQuantity: '1',
                              productOwnerID: product.productOwnerID,
                              productOwnerAvatar: AppUtils.getAvatarImage(
                                  key: product.productOwnerAvatar),
                              productName: product.productName,
                              productPrice: product.productPrice);
                          Provider.of<CartStateManager>(context, listen: false)
                              .addItemToCart(cart, context);
                        },
                        onPressedDetails: () {
                          AppUtils.navigatePush(
                              context: context,
                              destination: DetailsScreen(
                                product: product,
                              ));
                        },
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const CustomText(label: "Something went wrong"),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonButton1(
                        title: 'Try Again',
                        onPressed: () {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 1.2,
              ),
              itemCount: 6,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ShimmerWidget.circular(
                  height: 135,
                  width: 135,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                );
              },
            );
          }
        });
  }
}
