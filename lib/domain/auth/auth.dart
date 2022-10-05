import 'package:block_agri_mart/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../app/provider/app_provider.dart';
import '../../app/constants/color_constant.dart';
import '../../app/utils/utils.dart';
import '../../app/widgets/custom_text.dart';

export 'components/components.dart';
export 'model/miner.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor.withOpacity(1),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      // padding: E,
                      onPressed: () {
                        _pageController.animateToPage(0,
                            duration: const Duration(microseconds: 600),
                            curve: Curves.ease);
                      },

                      shape: const CircleBorder(),
                      elevation: 0,
                      color: context.read<AppStateManager>().authPageIndex == 0
                          ? ColorConstants.primaryColor
                          : ColorConstants.primaryColor.withOpacity(0.5),
                      height: 10,
                      minWidth: 10,
                    ),
                    MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        _pageController.animateToPage(1,
                            duration: const Duration(microseconds: 600),
                            curve: Curves.ease);
                      },
                      shape: const CircleBorder(),
                      color: context.read<AppStateManager>().authPageIndex == 1
                          ? ColorConstants.primaryColor
                          : ColorConstants.primaryColor.withOpacity(0.5),
                      height: 10,
                      minWidth: 10,
                    ),
                    MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        _pageController.animateToPage(2,
                            duration: const Duration(microseconds: 600),
                            curve: Curves.ease);
                      },
                      shape: const CircleBorder(),
                      color: context.read<AppStateManager>().authPageIndex == 2
                          ? ColorConstants.primaryColor
                          : ColorConstants.primaryColor.withOpacity(0.5),
                      height: 10,
                      minWidth: 10,
                    )
                  ],
                ), 
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<AppStateManager>().changeAuthPageIndex(index);
                  },
                  pageSnapping: true,
                  children: const [
                    OnBoardScreenOne(),
                    OnBoardScreenTwo(),
                    OnBoardScreenThree(),
                    OnBoardScreenFour(),
                    

                  ],
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      visible:
                          context.watch<AppStateManager>().authPageIndex >= 3 
                              ? false
                              : true,
                      child: MaterialButton(
                        minWidth: 100,
                        height: 45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: ColorConstants.primaryColor,
                        onPressed: () {
                          _pageController.animateToPage(3,
                              duration: const Duration(microseconds: 600),
                              curve: Curves.ease);
                        },
                        child: const Text(
                          "Skip",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [],
    );
  }
}

class LottieWidget extends StatelessWidget {
  const LottieWidget({Key? key, required this.lottiePath}) : super(key: key);

  final String lottiePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: LottieBuilder.asset(
        lottiePath,
        width: AppUtils.appMQ(context: context, flag: 'w') / 1.5,
        height: AppUtils.appMQ(context: context, flag: 'h') / 2.5,
      ),
    );
  }
}

class ConnectWalletDialogTitle extends StatelessWidget {
  const ConnectWalletDialogTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      alignment: Alignment.center,
      child: const CustomText(
          label: "Connect Wallet ", fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}
