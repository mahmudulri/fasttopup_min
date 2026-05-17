import 'package:get/get.dart';
import 'package:fasttopup/bindings/basebinding.dart';
import 'package:fasttopup/bindings/sign_in_binding.dart';
import 'package:fasttopup/bindings/splash_binding.dart';
import 'package:fasttopup/screens/base_screen.dart';
import 'package:fasttopup/screens/welcomescreen.dart';
import 'package:fasttopup/splash_screen.dart';
import '../screens/sign_in_screen.dart';

const String splash = '/splash-screen';
const String welcomescreen = '/welcome-screen';
const String signinscreen = '/sign-in-screen';
const String basescreen = '/base-screen';

List<GetPage> myroutes = [
  GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(name: welcomescreen, page: () => Welcomescreen()),
  GetPage(
    name: signinscreen,
    page: () => SignInScreen(),
    binding: SignInControllerBinding(),
  ),
  GetPage(name: basescreen, page: () => BaseScreen(), binding: Basebinding()),
];
