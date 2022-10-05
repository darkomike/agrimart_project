// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../app/provider/app_provider.dart';
// import '../../../app/theme/color_constant.dart';
// import 'components/bottom_nav_item.dart';

// class CustomBottomNavigatorBar extends StatelessWidget {
//   const CustomBottomNavigatorBar({
//     required this.isVisible,
//     Key? key,
//   }) : super(key: key, );


// final bool isVisible;
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 100),
//       height: isVisible ? 80 : 0,
//       child: Container(
//         height: 60,
//         decoration: BoxDecoration(
//             color: Theme.of(context).backgroundColor.withOpacity(0.7),
//             borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//         child: Wrap(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 CustomBottomNavigationItem(
//                   onTap: () {
//                     Provider
//                         .of<AppStateManager>(context, listen: false)
//                         .changeNavigationBottomSelected(0);
//                   },
//                   icon: Icons.space_dashboard_rounded,
//                   label: 'Dashboard',
//                   isSelected: 0,
//                 ),
//                 CustomBottomNavigationItem(
//                   onTap: () {
//                    Provider
//                         .of<AppStateManager>(context, listen: false)
//                         .changeNavigationBottomSelected(1);
//                   },
//                   icon: Icons.record_voice_over_rounded,
//                   label: 'Recommends',
//                   isSelected: 1,
//                 ),
//                 CustomBottomNavigationItem(
//                   onTap: () {
//                   Provider
//                         .of<AppStateManager>(context, listen: false)
//                         .changeNavigationBottomSelected(2);
//                   },
//                   icon: Icons.receipt_sharp,
//                   label: 'Requests',
//                   isSelected: 2,
//                 ),
//                 CustomBottomNavigationItem(
//                   onTap: () {
//                     Provider
//                         .of<AppStateManager>(context, listen: false)
//                         .changeNavigationBottomSelected(3);
//                   },
//                   icon: Icons.transfer_within_a_station_sharp,
//                   label: 'Transactions',
//                   isSelected: 3,
//                 ),
//                 // CustomBottomNavigationItem(
//                 //   onTap: () {
//                 //     context
//                 //         .read<AppStateManager>()
//                 //         .changeNavigationBottomSelected(4);
//                 //   },
//                 //   icon: Icons.category,
//                 //   label: 'Wallet',
//                 //   isSelected: 4,
//                 // ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: ColorConstants.primaryColor.withOpacity(0.2),
//       ),
//     );
//   }
// }
