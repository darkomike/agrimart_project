import 'package:block_agri_mart/domain/home/components/recommends.dart';
import 'package:block_agri_mart/domain/home/model/catalog_model.dart';
import 'package:block_agri_mart/domain/products/components/my_products.dart';
import 'package:block_agri_mart/domain/products/components/others_products.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app.dart';
import '../../../app/constants/color_constant.dart';
import '../../../app/widgets/custom_shader_mask.dart';
import '../../nav/appbar/custom_app_bar.dart';
import '../../nav/tab/tab_button.dart';
import '../../products/components/search_products.dart';
import '../../products/model/product.dart';
import '../home.dart';
import '../provider/home_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard(
      {Key? key,
      required this.allStream,
      required this.catalogsStream,
      required this.vegetableStream,
      required this.cerealStream,
      required this.fruitStream})
      : super(key: key);

  final Stream<List<Product>> allStream;
  final Stream<List<Product>> vegetableStream;
  final Stream<List<Product>> cerealStream;
  final Stream<List<Product>> fruitStream;
  final Stream<List<CatalogModel>> catalogsStream;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final productsKey = GlobalKey();

  var productsContext;

  int _selectedBottomTab = 0;
  final _productsController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      productsContext = productsKey.currentContext;
      setState(() {});
    });
  }

  goToProducts() {
    if (productsContext != null) {
      Scrollable.ensureVisible(productsContext,
          curve: Curves.ease,
          alignment: 0,
          duration: const Duration(milliseconds: 900));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        isDashboard: true,
        showCart: true,
        showAddProduct: true,
        showNotification: true,
        title: "AgriMart",
        // bottom: _buildCategories(context),
        showProfilePic: true,
        onTransparentBackground: false,
      ),
      body: _buildDashboardBody(context),
    );
  }

  Container _buildDashboardBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // controller: _dashboardScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceH2,
            _buildTopSellers(),
            spaceH2,
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    key: productsKey,
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CustomShaderMask(
                          blendMode: BlendMode.srcIn,
                          gradient: LinearGradient(colors: [
                            Theme.of(context).iconTheme.color!.withOpacity(0.9),
                            Theme.of(context).iconTheme.color!.withOpacity(0.9),
                            ColorConstants.primaryColor
                          ]),
                          child: const CustomText(
                            label: "Available market catalogs",
                            fontFamily: 'Quicksand',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        )),
                  ),
                  spaceH1,
                  StreamBuilder<List<CatalogModel>>(
                      stream: widget.catalogsStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!.isEmpty
                              ? Center(
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Center(
                                            child: CustomText(
                                              label: 'No Active Markets',
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    CatalogModel catalogModel =
                                        snapshot.data![index];
                                    return MaterialButton(
                                      onPressed: () {
                                        try {
                                          if (prefs.getString(
                                                  'userMetaMuskAddress') ==
                                              catalogModel.catalogID) {
                                            AppUtils.showCustomSnackBarWithoutAction(
                                                duration: 2000,
                                                context: context,
                                                label:
                                                    "Go to your profile and view your product catalog.");
                                          } else {
                                            AppUtils.navigatePush(
                                                context: context,
                                                destination: OthersProducts(
                                                    ownerID: catalogModel
                                                        .catalogID!));
                                          }
                                        } catch (e) {
                                          print(
                                              "Error in catalog card func: $e");
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color(0xFF02AAB0),
                                              Color(0xFF00CDAC),
                                            ])),
                                        height: 135,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 95,
                                              // width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(AppUtils
                                                          .getAvatarImage(
                                                              key: catalogModel
                                                                  .userAvatar!)))),
                                            ),
                                            Positioned(
                                                bottom: 5,
                                                left: 5,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: CustomText(
                                                        fontSize: 14,
                                                        fontWeight: bold,
                                                        label: AppUtils
                                                            .shortenAddress2(
                                                                userAddress:
                                                                    catalogModel
                                                                        .catalogID!))))
                                          ],
                                        ),
                                      ),
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
                                    const CustomText(
                                        label: "Something went wrong"),
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
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildAvailableProducts(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvailableProductsAndSearchIcon(context),
          spaceH1,
          _buildProductList(context)
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return SizedBox(
      height: AppUtils.appMQ(context: context, flag: 'h') - 200,
      child: Flexible(
        child: PageView(
          // alignment: Alignment.center,
          controller: _productsController,
          onPageChanged: (index) {
            setState(() {
              _selectedBottomTab = index;
            });
          },
          children: [
            ProductsStream(
              stream: widget.allStream,
            ),
            ProductsStream(
              stream: widget.vegetableStream,
            ),
            ProductsStream(
              stream: widget.fruitStream,
            ),
            ProductsStream(
              stream: widget.cerealStream,
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildAvailableProductsAndSearchIcon(BuildContext context) {
    return Padding(
      key: productsKey,
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
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
                  label: "Available Products",
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              )),
          MaterialButton(
            onPressed: () {
              AppUtils.navigatePush(
                  context: context, destination: const SearchProduct());
            },
            color: Theme.of(context).backgroundColor,
            elevation: 0.5,
            shape: CircleBorder(
                side: BorderSide(color: ColorConstants.secondaryColor)),
            height: 30,
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: ColorConstants.primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TopSellers _buildTopSellers() => const TopSellers();

  PreferredSize _buildCategories(BuildContext context) {
    return PreferredSize(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorConstants.primaryColor.withOpacity(0.15),
        ),
        height: 60,
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        margin: const EdgeInsets.only(left: 3, right: 3),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            TabButton(
              shouldExpand: false,
              currentIndex: _selectedBottomTab,
              index: 0,
              label: 'All',
              onPressed: () {
                goToProducts();
                setState(() {
                  _selectedBottomTab = 0;
                });
                _productsController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.bounceIn);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            TabButton(
              shouldExpand: false,
              currentIndex: _selectedBottomTab,
              index: 1,
              label: 'Vegetables',
              onPressed: () {
                goToProducts();

                setState(() {
                  _selectedBottomTab = 1;
                });
                _productsController.animateToPage(1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.bounceIn);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            TabButton(
              shouldExpand: false,
              currentIndex: _selectedBottomTab,
              index: 2,
              label: 'Fruits',
              onPressed: () {
                goToProducts();

                setState(() {
                  _selectedBottomTab = 2;
                });
                _productsController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.bounceIn);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            TabButton(
              shouldExpand: false,
              currentIndex: _selectedBottomTab,
              index: 3,
              label: 'Cereals',
              onPressed: () {
                goToProducts();

                setState(() {
                  _selectedBottomTab = 3;
                });
                _productsController.animateToPage(3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.bounceIn);
              },
            ),
          ],
        ),
      ),
      preferredSize: const Size.fromHeight(50),
    );
  }
}
