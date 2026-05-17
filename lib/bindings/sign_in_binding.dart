import 'package:get/get.dart';
import 'package:fasttopup/controllers/sign_in_controller.dart';

class SignInControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
