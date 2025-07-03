// import 'package:eduction_system/controller/admin/GradesController.dart';
// import 'package:eduction_system/core/them/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class GradesScreen extends StatelessWidget {
//   const GradesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     Get.put(GradesController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'علامات الطلاب',
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             color: AppColors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//         elevation: 4,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {
//               Get.find<GradesController>().fetchGrades();
//             },
//           ),
//         ],
//       ),
//       body: GetBuilder<GradesController>(
//         builder: (controller) => Container(
//           color: isDarkMode ? Colors.grey[900] : Colors.white,
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//             child: controller.isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       color: AppColors.primary,
//                     ),
//                   )
//                 : controller.grades.isEmpty
//                     ? const Center(
//                         child: Text(
//                           "لا توجد بيانات حالياً",
//                           style: TextStyle(
//                             fontFamily: 'Cairo',
//                             fontSize: 18,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: controller.grades.length,
//                         itemBuilder: (context, index) {
//                           final grade = controller.grades[index];
//                           final isPromoted = grade.status == "promoted";

//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             color: AppColors.white,
//                             elevation: 3,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 8,
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundColor: isPromoted
//                                     ? Colors.green.withOpacity(0.2)
//                                     : Colors.red.withOpacity(0.2),
//                                 child: Text(
//                                   grade.studentName[0],
//                                   style: TextStyle(
//                                     color:
//                                         isPromoted ? Colors.green : Colors.red,
//                                   ),
//                                 ),
//                               ),
//                               title: Text(
//                                 grade.status,
//                                 style: const TextStyle(
//                                   fontFamily: 'Cairo',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                 ),
//                                 textDirection: TextDirection.rtl,
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("القسم: ${grade.departmentName}"),
//                                   Text("المادة: ${grade.subjectName}"),
//                                   Text("العلامة: ${grade.grade}"),
//                                 ],
//                               ),
//                               trailing: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isPromoted ? Colors.green : Colors.red,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   isPromoted ? "ناجح" : "راسب",
//                                   style: const TextStyle(
//                                     fontFamily: 'Cairo',
//                                     fontSize: 12,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ),
//       ),
//     );
//   }
// }
