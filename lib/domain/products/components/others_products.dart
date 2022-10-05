import 'package:block_agri_mart/app/constants/color_constant.dart';
import 'package:block_agri_mart/app/provider/app_provider.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/custom_elevated_button.dart';
import 'package:block_agri_mart/app/widgets/custom_shader_mask.dart';
import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/app/widgets/shimmer_widget.dart';
import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:block_agri_mart/domain/home/home.dart';
import 'package:block_agri_mart/domain/nav/appbar/components/app_bar_icon_button.dart';
import 'package:block_agri_mart/domain/nav/tab/tab_button.dart';
import 'package:block_agri_mart/domain/products/components/product_card.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../firebase/firebase_product_api.dart';
import '../../domain.dart';
import '../model/product.dart';

class OthersProducts extends StatefulWidget {
  final String ownerID;
  const OthersProducts({
    Key? key,
    required this.ownerID,
  }) : super(key: key);

  @override
  State<OthersProducts> createState() => _OthersProductsState();
}

class _OthersProductsState extends State<OthersProducts> {
  late Stream<List<Product>> allStream;
  late Stream<List<Product>> vegetableStream;
  late Stream<List<Product>> fruitStream;
  late Stream<List<Product>> cerealStream;
  Stream<List<Product>>? searchStream;

  int _selectedBottomTab = 0;
  bool _showSearch = false;
  PageController _pageController = PageController();
  TextEditingController _searchController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    allStream =
        ProductFirebaseApi.getAllProductsFromUser(userID: widget.ownerID);
    vegetableStream =
        ProductFirebaseApi.getVegetablesProductsUser(userID: widget.ownerID);
    fruitStream =
        ProductFirebaseApi.getFruitsProductsUser(userID: widget.ownerID);
    cerealStream =
        ProductFirebaseApi.getCerealsProductsUser(userID: widget.ownerID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leadingWidth: 0,
        title: CustomShaderMask(
          blendMode: BlendMode.srcIn,
          gradient: LinearGradient(
              colors: [ColorConstants.primaryColor, Colors.blue]),
          child: CustomText(
            label: AppUtils.shortenAddress2(userAddress: widget.ownerID),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const SizedBox(
          height: 0,
          width: 0,
        ),
        actions: [
          context.watch<AppStateManager>().userType.toLowerCase() == "buyer"
              ? AppBarIconButton(
                  showBgColor: false,
                  onTap: () {
                    AppUtils.navigatePush(
                        context: context, destination: const CartScreen());
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                  ),
                  showCount: true,
                  buttonMarginT: 5,
                  buttonMarginL: 7,
                  count:
                      context.watch<CartStateManager>().productsInCart.length,
                )
              : const SizedBox(),
          _showSearch
              ? IconButton(
                  onPressed: () {
                    try {
                      setState(() {
                        _showSearch = false;
                      });
                      print("Pressed");
                    } catch (e) {
                      print("Error in search : $e");
                    }
                  },
                  icon: const Icon(Icons.close))
              : IconButton(
                  onPressed: () {
                    try {
                      setState(() {
                        _showSearch = true;
                      });
                      print("Pressed");
                    } catch (e) {
                      print("Error in search : $e");
                    }
                  },
                  icon: const Icon(Icons.search)),
          spaceW1
        ],
        elevation: 0.0,
        bottom: _showSearch ? _buildSearch(context) : _buildBottom(),
      ),
      body: _showSearch ? _searchBody() : _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: PageView(
            // alignment: Alignment.center,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedBottomTab = index;
              });
            },
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
        ));
  }

  _searchBody() {
    return StreamBuilder<List<Product>>(
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

  PreferredSize _buildBottom() {
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
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
                setState(() {
                  _selectedBottomTab = 0;
                });
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
                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
                setState(() {
                  _selectedBottomTab = 1;
                });
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
                _pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
                setState(() {
                  _selectedBottomTab = 2;
                });
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
                _pageController.animateToPage(3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
                setState(() {
                  _selectedBottomTab = 3;
                });
              },
            ),
          ],
        ),
      ),
      preferredSize: const Size.fromHeight(50),
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
              searchStream = ProductFirebaseApi.searchProductFromUser(
                  productName: _searchController.text.trim(),
                  userID: widget.ownerID);
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
            hintText: 'Start typing to search item...',
            hintStyle:
                Theme.of(context).textTheme.headline3!.copyWith(fontSize: 12),
          ),
        ),
      ),
      preferredSize: const Size.fromHeight(50),
    );
  }
}
