import 'package:block_agri_mart/app/provider/app_provider.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/custom_shader_mask.dart';
import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/home/components/recommends.dart';
import 'package:block_agri_mart/domain/home/model/catalog_model.dart';
import 'package:block_agri_mart/domain/nav/bottom_nav/components/bottom_nav_item.dart';
import 'package:block_agri_mart/domain/nav/tab/tab_button.dart';
import 'package:block_agri_mart/domain/products/components/my_products.dart';
import 'package:block_agri_mart/domain/products/components/search_products.dart';
import 'package:block_agri_mart/domain/wallet/wallet.dart';
import 'package:block_agri_mart/firebase/firebase_miner_api.dart';
import 'package:block_agri_mart/firebase/firebase_product_api.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../app/constants/color_constant.dart';
import '../../main.dart';
import '../products/model/product.dart';
import '../requests/requests.dart';
import '../transactions/transactions.dart';
import 'components/dashboard.dart';
import 'home.dart';
export './provider/home_provider.dart';
export './components/components.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late Stream<List<Product>> allStream;
  late Stream<List<Product>> vegetableStream;
  late Stream<List<Product>> fruitStream;
  late Stream<List<Product>> cerealStream;
  late Stream<List<CatalogModel>> catalogsStream;
  late int _selectedBottomTab;

  @override
  void initState() {
    super.initState();
    allStream = ProductFirebaseApi.getAllProducts();
    vegetableStream = ProductFirebaseApi.getVegetablesProducts();
    fruitStream = ProductFirebaseApi.getFruitsProducts();
    cerealStream = ProductFirebaseApi.getCerealsProducts();
    catalogsStream = MinerFirebaseApi.getMinerCatalogs();
    _selectedBottomTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 80,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Wrap(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomBottomNavigationItem(
                      onTap: () {
                        setState(() {
                          _selectedBottomTab = 0;
                        });
                      },
                      icon: Icons.space_dashboard_rounded,
                      label: 'Dashboard',
                      isSelected: _selectedBottomTab,
                      currentIndex: 0,
                    ),
                    CustomBottomNavigationItem(
                      currentIndex: 1,
                      onTap: () {
                        setState(() {
                          _selectedBottomTab = 1;
                        });
                      },
                      icon: Icons.receipt_sharp,
                      label: 'Requests',
                      isSelected: _selectedBottomTab,
                    ),
                    context.watch<AppStateManager>().userType == 'seller'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              spaceW1,
                              spaceW2,
                            ],
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    CustomBottomNavigationItem(
                      currentIndex: 2,
                      onTap: () {
                        setState(() {
                          _selectedBottomTab = 2;
                        });
                      },
                      icon: Icons.transfer_within_a_station_sharp,
                      label: 'Transactions',
                      isSelected: _selectedBottomTab,
                    ),
                    CustomBottomNavigationItem(
                      onTap: () {
                        setState(() {
                          _selectedBottomTab = 3;
                        });
                      },
                      icon: Icons.wallet,
                      label: 'Wallet',
                      isSelected: _selectedBottomTab,
                      currentIndex: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: ColorConstants.primaryColor.withOpacity(0.2),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: context.watch<AppStateManager>().userType ==
                'seller'
            ? FloatingActionButton(
                elevation: 0.0,
                heroTag: 'go_to',
                tooltip: 'Go to available products',
                backgroundColor: ColorConstants.primaryColor.withOpacity(0.2),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Material(
                    color: Theme.of(context).backgroundColor,
                    shape: const CircleBorder(),
                    child: LottieBuilder.asset(
                      AppUtils.getLottie(name: 'bouncing-fruits'),
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                onPressed: () {
                  AppUtils.navigatePush(
                      context: context,
                      destination: MyProducts(
                        ownerID: prefs.getString('userMetaMuskAddress')!,
                        fromSelf: true,
                      ));
                },
              )
            : const SizedBox(),
        body: IndexedStack(
          index: _selectedBottomTab,
          children: [
            Dashboard(
              catalogsStream: catalogsStream,
              allStream: allStream,
              vegetableStream: vegetableStream,
              cerealStream: cerealStream,
              fruitStream: fruitStream,
            ),
            const RequestsScreen(),
            const TransactionsScreen(),
            const WalletScreen(),
          ],
        ),
      ),
    );
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor.withOpacity(1),
            title: const CustomText(
              label: "Do you want to exit app?",
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: bold,
            ),
            actions: [
              MaterialButton(
                  child: const CustomText(label: "No", fontSize: 14),
                  onPressed: () => Navigator.pop(context, false)),
              MaterialButton(
                  child: const CustomText(label: "Yes", fontSize: 14),
                  onPressed: () => Navigator.pop(context, true))
            ],
          ));
}
