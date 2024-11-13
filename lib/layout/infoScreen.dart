// import 'package:flutter/material.dart';
//
// import '../shared/components/text_form_field.dart';
// import '../shared/style/color_manager.dart';
//
// class InfoScreen extends StatelessWidget {
//   const InfoScreen(String id, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime selectedDate = DateTime.now();
//     var nameController = TextEditingController();
//     var bDayController = TextEditingController();
//     var notesController = TextEditingController();
//     return  ListView(
//       children: [
//         AppTextFormField(
//           isObscureText:true,
//           controller: nameController,
//           hintText: "الاسم ",
//           validator: (text) {
//             if (text?.isEmpty ?? true) {
//               return "اكتب اسم المخدوم ";
//             }
//             return null;
//           },
//           backgroundColor: ColorManager.colorWhit,
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//               color: ColorManager.primaryColor,
//               width: 1.3,
//             ),
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           label: 'الاسم',
//         ),
//         const SizedBox(height: 25),
//
//         AppTextFormField(
//           controller: bDayController,
//           suffixIcon:
//           IconButton(
//             onPressed: () async {
//               DateTime? chosenDate = await showDatePicker(
//                 context: context,
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime.now(),
//                 initialDate: selectedDate,
//                 builder: (BuildContext context, Widget? child) {
//                   return Theme(
//                     data: Theme.of(context).copyWith(
//                       colorScheme: ColorScheme.light(
//                         primary: ColorManager.liteblueGray,
//                         onSurface: ColorManager.scondeColor,
//                       ),
//                       textButtonTheme: TextButtonThemeData(
//                         style: TextButton.styleFrom(
//                           foregroundColor: ColorManager.liteblueGray,
//                         ),
//                       ),
//                     ),
//                     child: child!,
//                   );
//                 },
//               );
//               if (chosenDate != null) {
//                 selectedDate = chosenDate;
//                 String formattedDate = DateFormat('dd/MM/yyyy').format(chosenDate);
//                 bDayController.text = formattedDate;
//                 setState(() {}); // Update the UI if necessary
//               }
//             },
//             icon: Icon(
//               Icons.calendar_month_sharp,
//               color: ColorManager.scondeColor, // Set the icon color
//             ),
//           ),
//           hintText: "تاريخ الميلاد",
//           validator: (text) {
//             if (text?.isEmpty ?? true) {
//               return "اكتب تاريخ الميلاد";
//             }
//             return null;
//           },
//           backgroundColor: ColorManager.colorWhit,
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//               color: ColorManager.primaryColor,
//               width: 1.3,
//             ),
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           label: 'تاريخ الميلاد',
//           readOnly: true,
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
//

//isObscureText

import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen(String id, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
