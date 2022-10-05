import 'package:flutter/material.dart';

import '../../app/constants/color_constant.dart';
import '../../app/utils/utils.dart';
export './provider/product_provider.dart';
export './components/components.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: 1 == 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Material(
                    type: MaterialType.card,
                    elevation: 2,
                    child: Container(
                      alignment: Alignment.center,
                      height: 300,
                      width:AppUtils. appMQ(context: context, flag: 'w') - 120,
                      color: ColorConstants.primaryColor,
                      child: const Text("Illustration Picture Here"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "No products available",
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          : ListView(
            shrinkWrap: true,
              children: [
                const ListTile(
                  
                ),
                MaterialButton(
                  onPressed: () {},
                  
                )
              ],
            ),
    );
  }
}
