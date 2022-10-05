import 'package:block_agri_mart/app/widgets/shimmer_widget.dart';
import 'package:block_agri_mart/domain/home/components/see_all_top_sellers.dart';
import 'package:block_agri_mart/domain/profile/model/miner.dart';
import 'package:block_agri_mart/firebase/firebase_miner_api.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/material.dart';
import '../../../app/constants/color_constant.dart';
import '../../../app/utils/utils.dart';
import '../../../app/widgets/custom_shader_mask.dart';
import '../../../app/widgets/custom_text.dart';

class TopSellers extends StatefulWidget {
  const TopSellers({
    Key? key,
  }) : super(key: key);

  @override
  State<TopSellers> createState() => _TopSellersState();
}

class _TopSellersState extends State<TopSellers> {
  late Stream<List<Miner>> topSellersStream;

  @override
  void initState() {
    super.initState();
    topSellersStream = MinerFirebaseApi.getTopSellers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    label: "Top Sellers",
                    fontFamily: 'Quicksand',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextButton(
                  onPressed: () {
                    AppUtils.navigatePush(
                        context: context,
                        destination: const SeeAllTopSellerPage());
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
          height: 160,
          child: StreamBuilder<List<Miner>>(
              stream: topSellersStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                      key: UniqueKey(),
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemBuilder: (context, index) {
                        Miner miner = snapshot.data![index];
                        prefs.setString('phoneNumber', miner.phoneNumber);

                        return TopSellersCard(
                            productsSold: miner.productSold,
                            imageThumbnail: miner.minerAvatar,
                            onPressed: () {},
                            sellerID: AppUtils.shortenAddress1(
                                userAddress: miner.minerID),
                            productsPurchased: miner.productPurchased,
                            totalRevenue: miner.totalRevenue,
                            numberOfProducts: miner.numberOfProducts);
                      },
                      physics: const BouncingScrollPhysics(),
                    );
                  } else {
                    return const Center(
                      child: CustomText(
                        label: 'No Top Sellers',
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
                            width: 150,
                            height: 150,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                      physics: const BouncingScrollPhysics());
                }
              }),
        ),
      ],
    );
  }
}

class TopSellersCard extends StatelessWidget {
  const TopSellersCard({
    required this.productsSold,
    required this.imageThumbnail,
    required this.onPressed,
    required this.sellerID,
    required this.productsPurchased,
    required this.totalRevenue,
    required this.numberOfProducts,
    Key? key,
  }) : super(key: key);

  final String sellerID;
  final double totalRevenue;
  final int productsPurchased;
  final int numberOfProducts;
  final int productsSold;
  final int imageThumbnail;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 150,
      elevation: 10,
      onPressed: onPressed,
      child: Container(
        width: AppUtils.appMQ(context: context, flag: 'w') * (5 / 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [
              Color(0xFF02AAB0),
              Color(0xFF00CDAC),
            ])),
        child: Stack(
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSellerBanner(),
                  const SizedBox(
                    height: 3,
                  ),
                  buildSellerID(),
                  buildTotalRevenue(),
                  const SizedBox(
                    height: 7,
                  ),
                  buildPurchasesSoldNum()
                ],
              ),
            ),
            buildSellerImage()
          ],
        ),
      ),
    );
  }

  Container buildSellerBanner() {
    return Container(
      height: 50,
      // width: 190,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(AppUtils.getProductImage(name: 'farm'))),
      ),
    );
  }

  Padding buildSellerID() {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Text(sellerID),
    );
  }

  Padding buildTotalRevenue() {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: CustomText(
        label: '$totalRevenue ETH',
        fontSize: 12,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Positioned buildSellerImage() {
    return Positioned(
      bottom: 65,
      left: 5,
      child: CircleAvatar(
        radius: 15,
        backgroundImage:
            AssetImage(AppUtils.getAvatarImage(key: imageThumbnail)),
      ),
    );
  }

  Container buildPurchasesSoldNum() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      // width: 170,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Purchases",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  "$productsPurchased",
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Uploads",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  "$numberOfProducts",
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sold",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  "$productsSold",
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
