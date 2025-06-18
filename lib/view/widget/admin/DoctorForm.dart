import 'package:eduction_system/controller/admin/DoctorController.dart';
import 'package:eduction_system/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DoctorForm extends StatefulWidget {
  final UserModel? doctor; // null يعني إضافة، غير null تعديل

  const DoctorForm({Key? key, this.doctor}) : super(key: key);

  @override
  State<DoctorForm> createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.doctor?.username ?? '');
    phoneController = TextEditingController(text: widget.doctor?.phone ?? '');
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DoctorControllerImp controller = Get.find();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'الاسم'),
            validator: (val) =>
                val == null || val.isEmpty ? 'أدخل الاسم' : null,
          ),
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            validator: (val) =>
                val == null || val.isEmpty ? 'أدخل رقم الهاتف' : null,
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: widget.doctor == null
                  ? 'كلمة المرور'
                  : 'كلمة المرور (اتركها فارغة إن لم ترغب بتغييرها)',
            ),
            obscureText: true,
            validator: (val) {
              if (widget.doctor == null && (val == null || val.isEmpty)) {
                return 'أدخل كلمة المرور';
              }
              if (val != null && val.isNotEmpty && val.length < 6) {
                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
          onPressed: () async {
              if (_formKey.currentState!.validate()) {
                bool success = false;

                if (widget.doctor == null) {
                  // إضافة دكتور جديد
                  success = await controller.createDoctor(
                    username: nameController.text.trim(),
                    password: passwordController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                } else {
                  // تعديل دكتور موجود
                  String passwordToSend = passwordController.text.trim();

                  // إذا كلمة المرور فاضية، لا تغيرها، ومرر قيمة فارغة (هي التي لن ترسل كلمة المرور في updateDoctor)
                  if (passwordToSend.isEmpty) {
                    passwordToSend = '';
                  }

                  UserModel updatedDoctor = UserModel(
                    user_id: widget.doctor!.user_id,
                    username: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    password: passwordToSend,
                    role: widget.doctor!.role,
                  );

                  success = await controller.updateDoctor(updatedDoctor);
                }

                if (success) {
                  Get.back();
                }
              }
            },

            child: Text(widget.doctor == null ? 'إضافة' : 'تعديل'),
          ),
        ],
      ),
    );
  }
}
