import 'package:get/get.dart';
import 'package:eduction_system/model/userModel.dart';

class UserController extends GetxController {
  var user = Rxn<UserModel>(); // نوعه قابل يكون null

  void setUser(UserModel newUser) {
    user.value = newUser;
  }
}
