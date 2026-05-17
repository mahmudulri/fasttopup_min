import 'package:fasttopup/utils/colors.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/routes/routes.dart';
import '../widgets/button.dart';

class Welcomescreen extends StatefulWidget {
  Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  Future<bool> showExitPopup() async {
    if (mypagecontroller.pageStack.length > 1) {
      mypagecontroller.goBack();
      return false;
    }
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languagesController.tr("EXIT_APP")),
        content: Text(languagesController.tr("DO_YOU_WANT_TO_EXIT_APP")),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(languagesController.tr("NO")),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(languagesController.tr("YES")),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  String longtext =
      "Send money, buy mobile credit and internet packages, pay bills, and manage all your transactions — fast, secure, and always at your fingertips!";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // ── Main content ────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo icon box
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/logo.png",
                            height: 50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Brand label
                      Text(
                        "MAHWARA TELECOM",
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Headline
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "All Your Financial\nServices ",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                                height: 1.25,
                              ),
                            ),
                            TextSpan(
                              text: "In One",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                                height: 1.25,
                              ),
                            ),
                            const TextSpan(
                              text: " App",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        longtext,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Feature pills
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPill("Fast"),
                          const SizedBox(width: 8),
                          _buildPill("Secure"),
                          const SizedBox(width: 8),
                          _buildPill("Always On"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom action area ───────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade100, width: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Register button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => whatsapp(),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: KText(
                                  text: "Register",
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Log in button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.offAllNamed(signinscreen),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: KText(
                                  text: "Log In",
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "By continuing, you agree to our Terms & Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Unchanged helper classes ───────────────────────────────────────────────────

class languageBox extends StatelessWidget {
  const languageBox({super.key, this.lanName, this.onpressed});
  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              lanName.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SinInbutton extends StatelessWidget {
  final double width;
  final double height;
  final String? buttonName;
  final VoidCallback? onpressed;

  SinInbutton({
    required this.width,
    required this.height,
    this.buttonName,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xffFF6A60),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: KText(
            text: buttonName.toString(),
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
