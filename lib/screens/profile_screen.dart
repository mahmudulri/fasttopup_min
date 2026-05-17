import 'dart:io';

import 'package:fasttopup/widgets/custom_text.dart';
import 'package:fasttopup/widgets/button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fasttopup/controllers/dashboard_controller.dart';
import 'package:fasttopup/controllers/drawer_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/pages/homepages.dart';
import 'package:fasttopup/screens/change_pin.dart';
import 'package:fasttopup/utils/colors.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/widgets/button_one.dart';
import 'package:fasttopup/widgets/drawer.dart';

import '../global_controller/page_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final Mypagecontroller mypagecontroller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5F6FA),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userInfo = dashboardController.alldashboardData.value.data!.userInfo!;
    final allData = dashboardController.alldashboardData.value.data!;
    final currency = box.read("currency_code") ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => mypagecontroller.goBack(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 0.5,
                        ),
                      ),
                      child: Image.asset(
                        "assets/icons/backicon.png",
                        height: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  KText(
                    text: languagesController.tr("PROFILE"),
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.042,
                    color: const Color(0xFF1A1A2E),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => CustomFullScreenSheet.show(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/drawericon.png",
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ── Profile header card ─────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // Avatar
                        userInfo.profileImageUrl != null
                            ? Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    width: 2.5,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      userInfo.profileImageUrl.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  border: Border.all(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.2,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: AppColors.primaryColor,
                                  size: 46,
                                ),
                              ),
                        const SizedBox(height: 12),
                        Text(
                          userInfo.resellerName.toString(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userInfo.phone.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Info section ────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.person_outline_rounded,
                          label: languagesController.tr("FULL_NAME"),
                          value: userInfo.resellerName.toString(),
                          showDivider: true,
                        ),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: languagesController.tr("EMAIL"),
                          value: userInfo.email.toString(),
                          showDivider: true,
                        ),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          label: languagesController.tr("PHONENUMBER"),
                          value: userInfo.phone.toString(),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Financial section ───────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.account_balance_wallet_outlined,
                          label: languagesController.tr("BALANCE"),
                          value: "${userInfo.balance} $currency",
                          valueColor: AppColors.primaryColor,
                          showDivider: true,
                        ),
                        _buildInfoRow(
                          icon: Icons.credit_card_outlined,
                          label: languagesController.tr("LOAN_BALANCE"),
                          value: "${userInfo.loanBalance} $currency",
                          valueColor: const Color(0xFFE24B4A),
                          showDivider: true,
                        ),
                        _buildInfoRow(
                          icon: Icons.trending_up_rounded,
                          label: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                          value: "${allData.totalSoldAmount} $currency",
                          valueColor: const Color(0xFF1D9E75),
                          showDivider: true,
                        ),
                        _buildInfoRow(
                          icon: Icons.payments_outlined,
                          label: languagesController.tr("TOTAL_REVENUE"),
                          value: "${allData.totalRevenue} $currency",
                          valueColor: const Color(0xFF1D9E75),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, size: 17, color: AppColors.primaryColor),
                  ),
                  SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),

              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.grey.shade100,
            thickness: 1,
            height: 1,
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}
