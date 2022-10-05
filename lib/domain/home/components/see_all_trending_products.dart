// ignore_for_file: avoid_print

import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/app/widgets/shimmer_widget.dart';
import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:block_agri_mart/domain/products/components/product_card.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:block_agri_mart/firebase/firebase_product_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/utils/utils.dart';
import '../../domain.dart';

class SeeAllTrendingProductsPage extends StatefulWidget {
  const SeeAllTrendingProductsPage({Key? key}) : super(key: key);

  @override
  State<SeeAllTrendingProductsPage> createState() =>
      _SeeAllTrendingProductsPageState();
}

class _SeeAllTrendingProductsPageState
    extends State<SeeAllTrendingProductsPage> {
  late Stream<List<Product>> trendingProductStream;

  @override
  void initState() {
    super.initState();
    trendingProductStream = ProductFirebaseApi.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          showCart: true,
          showProfilePic: true,
          showAddProduct: true,
          title: 'Trending Products',
          isDashboard: false,
          showNotification: true,
          onTransparentBackground: false),
      body: StreamBuilder<List<Product>>(
          stream: trendingProductStream,
          // initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return SizedBox(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      // mainAxisSpacing: 15,
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
                        onPressedAddFav: () {},
                        itemPrice: product.productPrice,
                        sellerThumbnail: product.productOwnerAvatar,
                        onPressedAddCart: () {
                          print("Add to Cart");
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
                  ),
                );
              } else {
                return const Center(
                  child: CustomText(
                    label: 'No Trending Products',
                    fontWeight: FontWeight.w700,
                  ),
                );
              }
            } else {
              return SizedBox(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    // mainAxisSpacing: 15,
                  ),
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ShimmerWidget.circular(
                      width: 150,
                      height: 150,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    );
                  },
                ),
              );
            }
          }),
    );
  }
}
