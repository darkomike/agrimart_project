import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/custom_shader_mask.dart';
import 'package:block_agri_mart/domain/home/home.dart';

import 'package:flutter/material.dart';

import '../../../app/constants/color_constant.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 200,
                width: 150,
                // color: Colors.amber,
                child: CustomShaderMask(
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(AppUtils.getImage(name: 'add-cart')),
                  gradient: LinearGradient(
                      colors: [ColorConstants.primaryColor, Colors.orange]),
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
              'No items in cart',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
                minWidth: 150,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: ColorConstants.primaryColor)),
                child: Text(
                  'Go to market catalog', 
                  style: TextStyle(color: ColorConstants.primaryColor),
                ),
                onPressed: () {
                       Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LandingScreen()));
                })
          ],
        ),
      ),
    );
  }
}