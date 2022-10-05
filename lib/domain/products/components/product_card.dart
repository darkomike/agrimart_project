import 'package:flutter/material.dart';

import '../../../app/utils/utils.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.sellerThumbnail,
    required this.productThumbnail,
    required this.height,
    required this.width,
    required this.productOwner,
    required this.onPressedDetails,
    required this.onPressedAddFav,
    required this.onPressedAddCart,
    required this.itemPrice,
    required this.itemTitle,
    Key? key,
  }) : super(key: key);

  final void Function()? onPressedDetails;
  final void Function()? onPressedAddCart;
  final void Function()? onPressedAddFav;
  final String productThumbnail;
  final String productOwner;
  final int sellerThumbnail;
  final double itemPrice;
  final String itemTitle;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressedDetails,
      child: Container(
        // width: width/2 ,
        height: 135,

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [
              Color(0xFF02AAB0),
              Color(0xFF00CDAC),
            ])),
        child: Stack(
          children: [
            Container(
              height: 100,
              // width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          AppUtils.getProductImage(name: productThumbnail)))),
            ),
            Positioned(
                left: 10,
                bottom: 4,
                child: CircleAvatar(
                  radius: 13,
                  backgroundImage: AssetImage(
                    AppUtils.getAvatarImage(key: sellerThumbnail),
                  ),
                )),
            Positioned(
              left: 40,
              bottom: 10,
              child: Text(
                itemTitle,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              bottom: 40,
              left: 10,
              child: Material(
                borderRadius: BorderRadius.circular(5),
                elevation: 2,
                color: const Color(0xFFF5F0EA).withOpacity(0.75),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10, top: 5, right: 5, bottom: 5),
                  child: Text(
                    "${AppUtils.roundToDecimalPlace(decimal: itemPrice, decimalPlace: 4)} ETH",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            // context.watch<AppStateManager>().userType == 'buyer'
            //     ? Positioned(
            //         right: 0,
            //         child: Container(
            //             height: 40,
            //             width: 40,
            //             decoration: BoxDecoration(
            //               color: const Color(0xFFF5F0EA).withOpacity(0.75),
            //               borderRadius: const BorderRadius.only(
            //                   bottomLeft: Radius.circular(5),
            //                   topRight: Radius.circular(10)),
            //             ),
            //             child: IconButton(
            //                 iconSize: 16,
            //                 onPressed: onPressedAddCart,
            //                 icon: const Icon(
            //                   Icons.add_shopping_cart_outlined,
            //                   size: 16,
            //                 ))),
            //       )
            //     : const SizedBox(),
            // context.watch<AppStateManager>().userType == 'buyer'  ||   productOwner == AppUtils.getMiner().minerID
            //     ? Positioned(
            //         left: 0,
            //         child: GestureDetector(
            //           onTap: onPressedAddFav,
            //           child: Container(
            //               height: 40,
            //               width: 40,
            //               decoration: BoxDecoration(
            //                 color: const Color(0xFFF5F0EA).withOpacity(0.75),
            //                 // border: Border.all(width: 2, color: Colors.white.withOpacity(0.51 )),
            //                 borderRadius: const BorderRadius.only(
            //                     bottomRight: Radius.circular(5),
            //                     topLeft: Radius.circular(10)),
            //               ),
            //               child: const Icon(
            //                     Icons.favorite_border_sharp,
            //                     size: 16,
            //                   )
            //                   ),
            //         ),
            //       )
            //     : const SizedBox()
          ],
        ),
      ),
    );
  }
}

// GestureDetector(
//       onTap: onPressedDetails,
//       child: Container(
//         width: width,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             gradient: const LinearGradient(colors: [
//               Color(0xFF02AAB0),
//               Color(0xFF00CDAC),
//             ])),
//         child: Stack(
//           children: [
//             Container(
//               height: 100,
//               width: 100,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                     fit: BoxFit.cover, image: AssetImage(itemImageUrl)),
//               ),
//             ),
//             Positioned(
//               left: 4,
//               top: 4,
//               child: CircleAvatar(
//                 radius: 15,
//                 backgroundImage: AssetImage(itemSellerImageUrl),
//               ),
//             ),
//             Positioned(
//               left: 110,
//               bottom: 10,
//               child: Text(
//                 itemTitle,
//                 style: const TextStyle(fontSize: 16),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Positioned(
//               bottom: 35,
//               left: 110,
//               child: Material(
//                 borderRadius: BorderRadius.circular(5),
//                 elevation: 2,
//                 color: const Color(0xFFF5F0EA).withOpacity(0.75),
//                 child: Container(
//                   padding: const EdgeInsets.only(
//                       left: 10, top: 5, right: 5, bottom: 5),
//                   child: Text(
//                     "$itemPrice ETH",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.red.shade400,
//                       fontWeight: FontWeight.w600,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               right: 0,
//               child: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F0EA).withOpacity(0.75),
//                     borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(5),
//                         topRight: Radius.circular(10)),
//                   ),
//                   child: IconButton(
//                       iconSize: 16,
//                       onPressed: onPressedAddCart,
//                       icon: const Icon(
//                         Icons.add_shopping_cart_outlined,
//                         size: 16,
//                       ))),
//             )
//           ],
//         ),
//       ),
//     );
