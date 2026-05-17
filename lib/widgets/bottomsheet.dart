import 'dart:io';

import 'package:fasttopup/utils/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fasttopup/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:fasttopup/screens/helpscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../pages/homepages.dart';
import '../screens/profile_screen.dart';
import '../screens/sign_in_screen.dart';

class CustomFullScreenSheet extends StatefulWidget {
  CustomFullScreenSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomFullScreenSheet(),
    );
  }

  @override
  State<CustomFullScreenSheet> createState() => _CustomFullScreenSheetState();
}

class _CustomFullScreenSheetState extends State<CustomFullScreenSheet> {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  final Mypagecontroller mypagecontroller = Get.find();
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() => _version = packageInfo.version);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height - 120,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      child: Obx(
        () => dashboardController.deactiveStatus.value == "Deactivated"
            ? Center(
                child: Text(
                  dashboardController.deactivateMessage.value.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 20),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // ── Menu Items ──────────────────────────────────────────
                    _buildMenuItem(
                      context,
                      icon: FontAwesomeIcons.whatsapp,
                      iconColor: const Color(0xFF10B981),
                      iconBgColor: const Color(0xFFD1FAE5),
                      title: languagesController.tr("CONTACTUS"),
                      subtitle: "Get instant help",
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          contentPadding: EdgeInsets.zero,
                          content: ContactDialogBox(),
                        ),
                      ),
                    ),

                    _buildMenuItem(
                      context,
                      icon: FontAwesomeIcons.circleQuestion,
                      iconColor: const Color(0xFFF59E0B),
                      iconBgColor: const Color(0xFFFEF3C7),
                      title: languagesController.tr("GUIDE"),
                      subtitle: "FAQs and guides",
                      onTap: () {
                        Navigator.pop(context);
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => mypagecontroller.changePage(
                            Helpscreen(),
                            isMainPage: false,
                          ),
                        );
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: FontAwesomeIcons.globe,
                      iconColor: const Color(0xFF8B5CF6),
                      iconBgColor: const Color(0xFFEDE9FE),
                      title: languagesController.tr("LANGUAGES"),
                      subtitle: "Change language",
                      onTap: () => _showLanguageDialog(context, screenWidth),
                    ),

                    _buildMenuItem(
                      context,
                      icon: FontAwesomeIcons.user,
                      iconColor: const Color(0xFFEC4899),
                      iconBgColor: const Color(0xFFFCE7F3),
                      title: languagesController.tr("PROFILE"),
                      subtitle: "Your account",
                      onTap: () {
                        Navigator.pop(context);
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => mypagecontroller.changePage(
                            ProfileScreen(),
                            isMainPage: false,
                          ),
                        );
                      },
                    ),

                    // ── Divider ─────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Container(
                        height: 0.5,
                        color: Colors.grey.shade300,
                      ),
                    ),

                    // ── Logout ──────────────────────────────────────────────
                    _buildMenuItem(
                      context,
                      icon: FontAwesomeIcons.doorOpen,
                      iconColor: const Color(0xFFEF4444),
                      iconBgColor: const Color(0xFFFEE2E2),
                      title: languagesController.tr("LOGOUT"),
                      subtitle: "Sign out",
                      isLogout: true,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: LogoutDialogBox(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Version ─────────────────────────────────────────────
                    Center(
                      child: Text(
                        "${languagesController.tr("VERSION")}: ${_version.isEmpty ? '...' : _version}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHOD (Add this to your drawer class)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // ── Icon Circle ──────────────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(child: FaIcon(icon, color: iconColor, size: 20)),
            ),
            const SizedBox(width: 12),

            // ── Text Content ─────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isLogout
                          ? const Color(0xFFEF4444)
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isLogout
                          ? const Color(0xFFEF4444).withOpacity(0.6)
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // ── Chevron ──────────────────────────────────────
            Icon(
              Icons.chevron_right_rounded,
              color: isLogout
                  ? const Color(0xFFEF4444).withOpacity(0.3)
                  : Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ── Language dialog ─────────────────────────────────────────────────────────
  void _showLanguageDialog(BuildContext context, double screenWidth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          languagesController.tr("CHANGE_LANGUAGE"),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          height: 350,
          width: screenWidth,
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
                    default:
                      locale = const Locale("en", "US");
                  }
                  setState(
                    () => EasyLocalization.of(context)!.setLocale(locale),
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.centerLeft,
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
}

// ContactDialogBox

class ContactDialogBox extends StatelessWidget {
  const ContactDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              FontAwesomeIcons.whatsapp,
              color: Color(0xFF1D9E75),
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "You will be redirected to the WhatsApp page to contact us. Continue?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => whatsapp(),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9E75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// LogoutDialogBox

class LogoutDialogBox extends StatelessWidget {
  LogoutDialogBox({super.key});

  final signInController = Get.find<SignInController>();
  final Mypagecontroller mypagecontroller = Get.find();
  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFE24B4A),
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          KText(
            text: languagesController.tr("DO_YOU_WANT_TO_LOG_OUT"),
            color: const Color(0xFF1A1A2E),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    signInController.usernameController.clear();
                    signInController.passwordController.clear();
                    box.remove("userToken");
                    mypagecontroller.changePage(Homepages(), isMainPage: false);
                    Get.to(() => SignInScreen());
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE24B4A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: KText(
                        text: languagesController.tr("YES_IAMGOING_OUT"),
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: KText(
                        text: languagesController.tr("CANCEL"),
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// whatsapp helper (unchanged)

whatsapp() async {
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
