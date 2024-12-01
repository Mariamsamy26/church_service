// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../Providers/img_Providers.dart';
// import '../style/color_manager.dart';
// import 'custem_showDialog.dart';
//
// class CustomImg extends StatelessWidget {
//   final IconData icon;
//
//   const CustomImg({Key? key, required this.icon}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         children: [
//           Consumer<ImageProviderNotifier>(
//             builder: (context, provider, child) {
//               return ClipOval(
//                 child:
//                   provider.imagePathProfile != null
//                       ? Image.file(
//                           File(provider.imagePathProfile!.path),
//                           width: 150,
//                           height: 150,
//                           fit: BoxFit.cover,
//                         )
//                       : Image.asset("assets/images/profileB.png"),
//
//               );
//             },
//           ),
//
//           // Container(
//           //   width: 110,
//           //   height: 110,
//           //   decoration: BoxDecoration(
//           //     border: Border.all(width: 5, color: ColorManager.primaryColor),
//           //     borderRadius: const BorderRadius.all(Radius.circular(19)),
//           //   ),
//           //   child: Consumer<ImageProviderNotifier>(
//           //     builder: (context, provider, child) {
//           //       print("mmmm : ${provider.imagePathProfile!.path}");
//           //       final image = provider.imagePathProfile != null
//           //           ? FileImage(File(provider.imagePathProfile!.path))
//           //           : const AssetImage('assets/images/profileB.png') as ImageProvider;
//           //
//           //       return Ink.image(
//           //         fit: BoxFit.fill,
//           //         image: image,
//           //       );
//           //     },
//           //   ),
//           // ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: InkWell(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => CustomShowDialog(
//                     title: 'Choose best way . . .',
//                     firstText: 'Camera',
//                     secondText: 'Gallery',
//                     frisIcon: Icons.camera_alt_outlined,
//                     secIcon: Icons.photo_library_outlined,
//                     onFirstPressed: () {
//                       // Pick an image from the camera
//                       Provider.of<ImageProviderNotifier>(context, listen: false)
//                           .pickImageFromCamera(context);
//                       Navigator.pop(context);
//                     },
//                     onSecondPressed: () {
//                       // Pick an image from the gallery
//                       Provider.of<ImageProviderNotifier>(context, listen: false)
//                           .pickImageFromGallery(context);
//                       Navigator.pop(context);
//                     },
//                     onCancelPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 );
//               },
//               child: Container(
//                 width: 35,
//                 height: 35,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(blurRadius: 1, color: ColorManager.primaryColor),
//                   ],
//                   border:
//                       Border.all(width: 3, color: ColorManager.primaryColor),
//                   borderRadius: const BorderRadius.all(Radius.circular(200)),
//                 ),
//                 child: Icon(icon, color: ColorManager.colorWhit),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
