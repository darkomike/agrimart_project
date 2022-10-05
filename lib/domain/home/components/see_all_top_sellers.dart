import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/app/widgets/shimmer_widget.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/profile/model/miner.dart';
import 'package:block_agri_mart/firebase/firebase_miner_api.dart';
import 'package:flutter/material.dart';

import '../../../app/constants/color_constant.dart';
import '../../../app/utils/utils.dart';

class SeeAllTopSellerPage extends StatefulWidget {
  const SeeAllTopSellerPage({Key? key}) : super(key: key);

  @override
  State<SeeAllTopSellerPage> createState() => _SeeAllTopSellerPageState();
}

class _SeeAllTopSellerPageState extends State<SeeAllTopSellerPage> {
  late Stream<List<Miner>> topSellersStream;

  @override
  void initState() {
    super.initState();
    topSellersStream = MinerFirebaseApi.getTopSellers();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(
          showCart: true,
          showAddProduct: true,
          showProfilePic: true,
          title: 'Top Sellers',
          isDashboard: false,
          showNotification: true,
          onTransparentBackground: false),
      body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          // color: Colors.red,
          height: size.height,
          child: StreamBuilder<List<Miner>>(
              stream: topSellersStream,
              // initialData: [],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        Miner miner = snapshot.data![index];

                        return TopSellerCard(
                          imageThumbnail: AppUtils.getRandomNumber(),
                          numberOfProducts: miner.numberOfProducts,
                          productsSold: miner.productSold,
                          productsPurchased: miner.productPurchased,
                          sellerID: miner.minerID,
                          totalRevenue: miner.totalRevenue,
                        );
                      }),
                      separatorBuilder: ((context, index) => const SizedBox(
                            height: 5,
                          )),
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
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemBuilder: (context, index) => ShimmerWidget.circular(
                            width: AppUtils.appMQ(context: context, flag: 'w'),
                            height: 70,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                      physics: const BouncingScrollPhysics());
                }
              })),
    );
  }
}

class TopSellerCard extends StatelessWidget {
  const TopSellerCard({
    required this.sellerID,
    required this.totalRevenue,
    required this.productsPurchased,
    required this.imageThumbnail,
    required this.numberOfProducts,
    required this.productsSold,
    Key? key,
  }) : super(key: key);
  final String sellerID;
  final double totalRevenue;
  final int productsPurchased;
  final int numberOfProducts;
  final int productsSold;
  final int imageThumbnail;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProductSoldBuyersWidget(
                title: 'Purchased', count: productsPurchased),
            ProductSoldBuyersWidget(title: 'Sold', count: productsPurchased),
            ProductSoldBuyersWidget(title: 'Uploads', count: numberOfProducts),
          ],
        )
      ],
      leading: CircleAvatar(
        backgroundImage:
            AssetImage(AppUtils.getAvatarImage(key: imageThumbnail)),
      ),
      //  collapsedBackgroundColor: ColorConstants.primaryColor,
      iconColor: ColorConstants.primaryColor,
      collapsedIconColor: ColorConstants.primaryColor,
      // collapsedBackgroundColor: ColorConstants.primaryColor.withOpacity(0.5),

      backgroundColor: ColorConstants.primaryColor.withOpacity(0.15),

      title: CustomText(
        label: AppUtils.shortenAddress1(userAddress: sellerID),
        fontSize: 14,
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    );
  }
}

class ProductSoldBuyersWidget extends StatelessWidget {
  const ProductSoldBuyersWidget({
    required this.count,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$count',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontSize: 10, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
