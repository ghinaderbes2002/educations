import 'package:eduction_system/core/them/app_colors.dart';
import 'package:flutter/material.dart';

class DepartmentCard extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const DepartmentCard({
    super.key,
    required this.name,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            name.isNotEmpty ? name[0] : '?',
            style: const TextStyle(color: AppColors.white),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textDirection: TextDirection.rtl,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: onEdit,
              tooltip: "تعديل القسم",
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: "حذف القسم",
            ),
          ],
        ),
      ),
    );
  }
}
