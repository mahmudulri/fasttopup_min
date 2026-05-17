import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:url_launcher/url_launcher.dart';

import '../controllers/sign_in_controller.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../widgets/authtextfield.dart';
import '../widgets/custom_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final box = GetStorage();
  late LanguagesController languagesController;
  late SignInController signInController;

  @override
  void initState() {
    super.initState();
    languagesController = Get.put(LanguagesController());
    signInController = Get.find<SignInController>();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<bool> _exitApp() async {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Header with Language
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KText(
                          text: languagesController.tr("LOGIN"),
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                        const SizedBox(height: 6),
                        KText(
                          text: languagesController.tr(
                            "PLEASE_ENTER_YOUR_INFORMATION",
                          ),
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _showLanguageDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => KText(
                                text: languagesController.selectedlan.value,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.language_rounded,
                              size: 14,
                              color: Color(0xFF185FA5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Username
                KText(
                  text: languagesController.tr("USERNAME"),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 8),
                Authtextfield(
                  hinttext: languagesController.tr("USERNAME"),
                  controller: signInController.usernameController,
                ),
                const SizedBox(height: 20),

                // Password
                KText(
                  text: languagesController.tr("PASSWORD"),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 8),
                Authtextfield(
                  hinttext: languagesController.tr("PASSWORD"),
                  controller: signInController.passwordController,
                ),
                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _openWhatsApp,
                    child: KText(
                      text: languagesController.tr("PASSWORD_RECOVERY"),
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sign In Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: signInController.isLoading.value
                          ? null
                          : _handleSignIn,
                      child: Text(
                        signInController.isLoading.value
                            ? languagesController.tr("PLEASE_WAIT")
                            : languagesController.tr("LOGIN"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: KText(
                        text: languagesController.tr("FIND_US_ON"),
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      icon: FontAwesomeIcons.whatsapp,
                      onTap: _openWhatsApp,
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      asset: "assets/icons/social-media.png",
                      onTap: _showSocialDialog,
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.phone,
                      onTap: () => _makePhoneCall(AppString.phoneNUmber),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    String? asset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, size: 18, color: Colors.grey[700])
              : Image.asset(asset!, height: 20),
        ),
      ),
    );
  }

  void _handleSignIn() async {
    if (signInController.usernameController.text.trim().isEmpty ||
        signInController.passwordController.text.trim().isEmpty) {
      Get.snackbar("Oops!", "Fill the text fields");
      return;
    }
    await signInController.signIn();
  }

  _openWhatsApp() async {
    var contact = AppString.phoneNUmber;
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      print("not found");
    }
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          languagesController.tr("LANGUAGES"),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languagesController.alllanguagedata.length,
            itemBuilder: (context, index) {
              final data = languagesController.alllanguagedata[index];
              return GestureDetector(
                onTap: () {
                  final languageName = data["name"].toString();
                  final matched = languagesController.alllanguagedata
                      .firstWhere(
                        (lang) => lang["name"] == languageName,
                        orElse: () => {"isoCode": "en", "direction": "ltr"},
                      );
                  final languageISO = matched["isoCode"]!;
                  final languageDirection = matched["direction"]!;

                  languagesController.changeLanguage(languageName);
                  box.write("language", languageName);
                  box.write("direction", languageDirection);

                  Locale locale;
                  switch (languageISO) {
                    case "fa":
                      locale = const Locale("fa", "IR");
                      break;
                    case "ar":
                      locale = const Locale("ar", "AE");
                      break;
                    case "ps":
                      locale = const Locale("ps", "AF");
                      break;
                    case "tr":
                      locale = const Locale("tr", "TR");
                      break;
                    case "bn":
                      locale = const Locale("bn", "BD");
                      break;
                    case "en":
                    default:
                      locale = const Locale("en", "US");
                  }

                  setState(() {
                    EasyLocalization.of(context)!.setLocale(locale);
                  });
                  Navigator.pop(context);
                  debugPrint(
                    "🌐 Language: $languageName ($languageISO), dir: $languageDirection",
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data["fullname"].toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSocialDialog() {
    // TODO: Show social media options
  }

  @override
  void dispose() {
    super.dispose();
  }
}
