// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class ImageProviderNotifier extends ChangeNotifier {
//   XFile? _imagePathProfile;
//   final ImagePicker _picker = ImagePicker();
//
//   XFile? get imagePathProfile => _imagePathProfile;
//
//   // Corrected the setImage method to properly set the image and notify listeners
//   void setImage(XFile image) {
//     _imagePathProfile = image;
//     notifyListeners();// This will notify the UI to update when the image is set
//     print("mmm $_imagePathProfile");
//   }
//
//   Future<bool> _checkPermission(Permission permission, String errorMessage) async {
//     var status = await permission.status;
//     if (status.isDenied || status.isPermanentlyDenied) {
//       status = await permission.request();
//     }
//     if (!status.isGranted) {
//       throw Exception(errorMessage);
//     }
//     return true;
//   }
//
//   Future<void> pickImageFromCamera(BuildContext context) async {
//     try {
//       // Checking for camera permission
//       await _checkPermission(Permission.camera, 'Camera permission is required.');
//       final image = await _picker.pickImage(source: ImageSource.camera);
//       if (image != null) {
//         setImage(image);  // Set the picked image using setImage
//         print("Picked image from camera: ${_imagePathProfile?.path}");  // Check image path
//       }
//     } catch (e) {
//       _showErrorDialog(context, e.toString());
//     }
//   }
//
//   Future<void> pickImageFromGallery(BuildContext context) async {
//     try {
//       // Checking for camera permission
//       await _checkPermission(Permission.photos, 'Camera permission is required.');
//       final image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setImage(image);  // Set the picked image using setImage
//         print("Picked image from camera: ${_imagePathProfile?.path}");  // Check image path
//       }
//     } catch (e) {
//       _showErrorDialog(context, e.toString());
//     }
//   }
//
//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
