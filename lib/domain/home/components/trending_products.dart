// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:block_agri_mart/app/provider/app_provider.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/shimmer_widget.dart';
import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:block_agri_mart/domain/cart/provider/cart_provider.dart';
import 'package:block_agri_mart/domain/details/details.dart';
import 'package:block_agri_mart/domain/home/components/see_all_trending_products.dart';
import 'package:block_agri_mart/domain/products/components/product_card.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:block_agri_mart/firebase/firebase_product_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/constants/color_constant.dart';
import '../../../app/widgets/custom_shader_mask.dart';
import '../../../app/widgets/custom_text.dart';

class TrendingProducts extends StatefulWidget {
  const TrendingProducts({
    Key? key,
  }) : super(key: key);

  @override
  State<TrendingProducts> createState() => _TrendingProductsState();
}

class _TrendingProductsState extends State<TrendingProducts> {
  late Stream<List<Product>> trendingProductStream;

  @override
  void initState() {
    super.initState();
    trendingProductStream = ProductFirebaseApi.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CustomShaderMask(
                  blendMode: BlendMode.srcIn,
                  gradient: LinearGradient(colors: [
                    Theme.of(context).iconTheme.color!.withOpacity(0.9),
                    Theme.of(context).iconTheme.color!.withOpacity(0.9),
                    ColorConstants.primaryColor
                  ]),
                  child: const CustomText(
                    label: "Trending Products",
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextButton(
                  onPressed: () {
                    AppUtils.navigatePush(
                        context: context,
                        destination: SeeAllTrendingProductsPage());
                  },
                  child: CustomShaderMask(
                    blendMode: BlendMode.srcIn,
                    gradient: LinearGradient(
                        colors: [Colors.blue, ColorConstants.primaryColor]),
                    child: const CustomText(
                      label: "See all",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            )
          ],
        ),
        SizedBox(
          height: 180,
          child: StreamBuilder<List<Product>>(
              stream: trendingProductStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemBuilder: (context, index) {
                        Product product = snapshot.data![index];

                        return AspectRatio(
                            aspectRatio: 5 / 4,
                            child: ProductCard(
                              productOwner: product.productOwnerID,
                              width:
                                  AppUtils.appMQ(context: context, flag: 'w'),
                              height:
                                  AppUtils.appMQ(context: context, flag: 'h'),
                              productThumbnail: product.productThumbnail,
                              itemTitle: product.productName,
                              onPressedAddFav: () {},
                              itemPrice: product.productPrice,
                              sellerThumbnail: product.productOwnerAvatar,
                              onPressedAddCart: () {
                                print("Add to Cart");
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
                            ));
                      },
                      itemCount: snapshot.data!.length,
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
                  return ListView.separated(
                      key: UniqueKey(),
                      itemCount: 4,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemBuilder: (context, index) => ShimmerWidget.circular(
                            width: 200,
                            height: 150,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                      physics: const BouncingScrollPhysics());
                }
              }),
        )
      ],
    );
  }
}

class TrendingProductCard extends StatelessWidget {
  const TrendingProductCard(
      {Key? key,
      required this.addCart,
      required this.discount,
      required this.name,
      required this.addFav,
      required this.onPressed,
      required this.price,
      required this.isHome,
      required this.productThumbNail,
      required this.sellerThumbNail})
      : super(key: key);

  final String name;
  final String productThumbNail;
  final String sellerThumbNail;
  final double price;
  final double discount;
  final bool isHome;
  final void Function()? addCart;
  final void Function()? addFav;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        width: isHome ? 200 : 170,
        height: isHome ? 200 : 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(colors: [
              Color(0xFF02AAB0),
              Color(0xFF00CDAC),
            ])),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: isHome ? 200 : 170,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(productThumbNail)),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 4,
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(sellerThumbNail),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            Positioned(
              bottom: 55,
              left: isHome ? 15 : 8,
              child: Material(
                elevation: 10,
                shadowColor: Colors.green,
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFF5F0EA).withOpacity(0.70),
                child: SizedBox(
                  height: 60,
                  width: isHome ? 170 : 130,
                  child: Row(
                    mainAxisAlignment: isHome
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(
                                fontSize: isHome ? 14 : 12,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "$price ETH",
                            style: TextStyle(fontSize: isHome ? 14 : 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            context.watch<AppStateManager>().userType.toLowerCase() == 'buyer'
                ? Positioned(
                    right: 0,
                    child: Material(
                        color: const Color(0xFFF5F0EA).withOpacity(0.65),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: IconButton(
                            onPressed: addCart,
                            icon:
                                const Icon(Icons.add_shopping_cart_outlined))),
                  )
                : const SizedBox(),
            context.watch<AppStateManager>().userType.toLowerCase() == 'buyer'
                ? Positioned(
                    left: 0,
                    child: Material(
                        color:
                            Theme.of(context).backgroundColor.withOpacity(0.65),
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                        child: IconButton(
                            onPressed: addFav,
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ))),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
