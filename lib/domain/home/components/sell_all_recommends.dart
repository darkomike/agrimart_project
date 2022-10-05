import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:block_agri_mart/domain/cart/provider/cart_provider.dart';
import 'package:block_agri_mart/domain/details/details.dart';
import 'package:block_agri_mart/domain/nav/appbar/custom_app_bar.dart';
import 'package:block_agri_mart/domain/products/components/product_card.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:block_agri_mart/firebase/firebase_product_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app.dart';

class SeeAllRecommendsScreen extends StatefulWidget {
  const SeeAllRecommendsScreen({Key? key}) : super(key: key);

  @override
  State<SeeAllRecommendsScreen> createState() => _SeeAllRecommendsScreenState();
}

class _SeeAllRecommendsScreenState extends State<SeeAllRecommendsScreen> {
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
          showAddProduct: true,
          isDashboard: false,
          showCart: true,
          showNotification: true,
          title: "Recommended",
          showProfilePic: true,
          onTransparentBackground: false,
        ),
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
                            AppUtils.appLog("Add to Cart");
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
                            Provider.of<CartStateManager>(context,
                                    listen: false)
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
            }));
  }
}

class RecommendCard extends StatelessWidget {
  const RecommendCard({
    required this.body,
    required this.time,
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;
  final String time;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      tileColor: ColorConstants.primaryColor.withOpacity(.2),
      leading: CircleAvatar(
        backgroundColor: ColorConstants.primaryColor,
        // foregroundColor: ColorConstants.someRockGreen,
        child: const Text(
          "R",
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: onTap,
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 10),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16),
      ),
      subtitle: Text(
        body,
        style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
