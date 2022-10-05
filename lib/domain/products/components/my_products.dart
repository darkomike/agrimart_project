import 'package:block_agri_mart/app/constants/color_constant.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/domain/home/home.dart';
import 'package:block_agri_mart/domain/nav/tab/tab_button.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/material.dart';
import '../../../firebase/firebase_product_api.dart';
import '../../domain.dart';
import '../model/product.dart';

class MyProducts extends StatefulWidget {
  final String ownerID;
  final bool fromSelf;
  const MyProducts({Key? key, required this.ownerID, required this.fromSelf})
      : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  late Stream<List<Product>> allStream;
  late Stream<List<Product>> vegetableStream;
  late Stream<List<Product>> fruitStream;
  late Stream<List<Product>> cerealStream;
  int _selectedBottomTab = 0;
  PageController _pageController = PageController();

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isDashboard: false,
        showAddProduct: widget.fromSelf ? true : false,
        showCart: widget.fromSelf ? true : false,
        showNotification: false,
        title: "Product Catalogs",
        showProfilePic: widget.fromSelf ? true : false,
        onTransparentBackground: false,
        bottom: PreferredSize(
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
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: PageView(
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
          )),
    );
  }
}
