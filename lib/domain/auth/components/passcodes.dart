import 'dart:developer';

import 'package:block_agri_mart/app/constants/constant.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/domain/home/home.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/provider/app_provider.dart';

class PassCodeScreen extends StatefulWidget {
  final bool fromAuth;
  const PassCodeScreen({key, required this.fromAuth}) : super(key: key);

  @override
  State<PassCodeScreen> createState() => _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  String _passcode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPasscodeTitle(context),
              SizedBox(
                height: AppUtils.appMQ(context: context, flag: 'h') * (1 / 15),
              ),
              Center(child: _buildPasscodeKeypad(context))
            ]),
      ),
    );
  }

  Container _buildPasscodeTitle(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            label: prefs.getString('passcode') == '0000' || !widget.fromAuth
                ? 'Please enter a new passcode.'
                : "Please enter passcode",
            fontFamily: 'Quicksand',
            fontSize: 20,
          ),
          spaceH1,
          spaceH1,
          SizedBox(
            width: AppUtils.appMQ(context: context, flag: 'w') / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PasscodeIdentifier(
                  passcode: _passcode,
                  context: context,
                  position: 1,
                ),
                PasscodeIdentifier(
                  passcode: _passcode,
                  context: context,
                  position: 2,
                ),
                PasscodeIdentifier(
                  passcode: _passcode,
                  context: context,
                  position: 3,
                ),
                PasscodeIdentifier(
                  passcode: _passcode,
                  context: context,
                  position: 4,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox _buildPasscodeKeypad(BuildContext context) {
    return SizedBox(
      width: AppUtils.appMQ(context: context, flag: 'w') * (1 / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '1');
                },
                child: const CustomText(
                  label: '1',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '2');
                },
                child: const CustomText(
                  label: '2',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '3');
                },
                child: const CustomText(
                  label: '3',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
          spaceH1,
          spaceH1,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '4');
                },
                child: const CustomText(
                  label: '4',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '5');
                },
                child: const CustomText(
                  label: '5',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '6');
                },
                child: const CustomText(
                  label: '6',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
          spaceH1,
          spaceH1,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '7');
                },
                child: const CustomText(
                  label: '7',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '8');
                },
                child: const CustomText(
                  label: '8',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '9');
                },
                child: const CustomText(
                  label: '9',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
          spaceH1,
          spaceH1,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _passcode.length == 4
                  ? _buildPasscodeCardButton(
                      onPressed: _done,
                      bgColor: Colors.transparent,
                      elevation: 0.0,
                      border: ColorConstants.secondaryColor,
                      child: Icon(
                        Icons.done,
                        color: Theme.of(context).iconTheme.color,
                      ))
                  : const SizedBox(
                      height: 45,
                      width: 45,
                    ),
              _buildPasscodeCardButton(
                onPressed: () {
                  _passcodeFunc(value: '0');
                },
                child: const CustomText(
                  label: '0',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              _passcode.isNotEmpty
                  ? _buildPasscodeCardButton(
                      elevation: 0.0,
                      border: ColorConstants.secondaryColor,
                      onPressed: () {
                        setState(() {
                          _passcode =
                              _passcode.substring(0, _passcode.length - 1);
                        });
                        log("Passcode: $_passcode");
                      },
                      bgColor: Colors.transparent,
                      child: Icon(
                        Icons.backspace,
                        color: Theme.of(context).iconTheme.color,
                      ))
                  : const SizedBox(
                      height: 45,
                      width: 45,
                    ),
            ],
          ),
          spaceH1,
          spaceH1,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 45,
                width: 45,
              ),
              _passcode.length == 4
                  ? _buildPasscodeCardButton(
                      border: ColorConstants.secondaryColor,
                      elevation: 0.0,
                      onPressed: () {
                        AppUtils.showCustomSnackBarWithoutAction(
                            context: context,
                            duration: 1000,
                            label: 'Passcode currently entered: $_passcode');
                      },
                      bgColor: Colors.transparent,
                      child: Icon(
                        Icons.visibility,
                        color: Theme.of(context).iconTheme.color,
                      ))
                  : const SizedBox(
                      height: 45,
                      width: 45,
                    ),
              const SizedBox(
                height: 45,
                width: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _done() {
    try {
      if (widget.fromAuth) {
        if (prefs.getBool('loggedIn')!) {
          if (_passcode ==
              AppUtils.decodeText(cipherText: prefs.getString('passcode')!)) {
            AppUtils.showCustomSnackBarWithoutAction(
                duration: 2000,
                context: context,
                label: 'Redirecting to dashboard soon...');

            AppUtils.delayFunction(
                duration: 1500,
                action: () {
                  AppUtils.navigatePushReplace(
                      context: context, destination: const LandingScreen());

                  Provider.of<AppStateManager>(context, listen: false)
                      .setIsLoggedIn(true);
                });
          } else {
            AppUtils.showCustomSnackBarWithoutAction(
                context: context, label: 'Wrong passcode');
          }
        } else {
          AppUtils.showCustomSnackBarWithoutAction(
              duration: 1000,
              context: context,
              label: 'Passcode is correct. Redirecting to dashboard soon...');

          AppUtils.delayFunction(
              duration: 200,
              action: () {
                Provider.of<AppStateManager>(context, listen: false)
                    .setIsLoggedIn(true);

                AppUtils.navigatePushReplace(
                    context: context, destination: const LandingScreen());
                prefs.setString('passcode',
                    AppUtils.encodeText(plainText: _passcode).base64);
              });
        }
      } else {
        prefs.setString(
            'passcode', AppUtils.encodeText(plainText: _passcode).base64);
        AppUtils.showCustomSnackBarWithoutAction(
            duration: 1000,
            context: context,
            label: 'Pin code successfully changed.');
        AppUtils.delayFunction(
            duration: 500,
            action: () {
              Navigator.pop(context);
            });
      }
    } catch (e) {
      log("set_passcode.dart: Error in done func: $e");
    }
  }

  void _passcodeFunc({required String value}) {
    try {
      if (_passcode.length < 4) {
        setState(() {
          _passcode = _passcode.trim() + value;
        });
        log("Passcode: $_passcode");
      }
    } catch (e) {
      log("set_pin_code.dart: Error in passcode card: $e");
    }
  }

  MaterialButton _buildPasscodeCardButton(
      {required Widget child,
      VoidCallback? onPressed,
      Color? border,
      Color? bgColor,
      double? elevation}) {
    return MaterialButton(
        color: bgColor ?? Colors.grey,
        height: 50,
        disabledColor: bgColor,
        enableFeedback: true,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusElevation: 0.0,
        hoverElevation: 0.0,
        minWidth: 50,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        disabledElevation: 0.0,
        elevation: elevation ?? 2.0,
        onPressed: onPressed,
        shape:
            CircleBorder(side: BorderSide(color: border ?? Colors.transparent)),
        child: child);
  }
}

class PasscodeIdentifier extends StatelessWidget {
  const PasscodeIdentifier({
    key,
    required this.passcode,
    required this.context,
    required this.position,
  }) : super(key: key);

  final String passcode;
  final int position;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: passcode.length >= position
              ? ColorConstants.secondaryColor
              : Theme.of(context).backgroundColor,
          border: Border.all(color: ColorConstants.secondaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(microseconds: 500));
  }
}
