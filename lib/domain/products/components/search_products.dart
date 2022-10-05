import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/home/home.dart';
import 'package:block_agri_mart/domain/products/components/product_card.dart';
import 'package:block_agri_mart/domain/products/products.dart';
import 'package:block_agri_mart/firebase/firebase_product_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app.dart';
import '../../cart/model/cart_model.dart';
import '../model/product.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Stream<List<Product>>? searchStream;
  TextEditingController _searchController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: StreamBuilder<List<Product>>(
            stream: searchStream,
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
                                  productOwnerNumber:
                                      product.productOwnerNumber,
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
            }));
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      isDashboard: false,
      showAddProduct: true,
      showCart: true,
      showNotification: true,
      title: "Search Products",
      showProfilePic: true,
      onTransparentBackground: false,
      bottom: _buildSearch(context),
    );
  }

  PreferredSize _buildSearch(BuildContext context) {
    return PreferredSize(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        height: 60,
        padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              searchStream = ProductFirebaseApi.searchProduct(
                  productName: _searchController.text.trim());
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: ColorConstants.primaryColor, width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: ColorConstants.primaryColor, width: 1.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: ColorConstants.primaryColor, width: 1.5)),
            hintText: 'Search item...',
            hintStyle:
                Theme.of(context).textTheme.headline3!.copyWith(fontSize: 12),
          ),
        ),
      ),
      preferredSize: const Size.fromHeight(50),
    );
  }

  Center _buildNoSearch() => const Center(
        child: CustomText(
          label: 'No Search',
          fontSize: 20,
        ),
      );
}
