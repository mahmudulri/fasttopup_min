import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:fasttopup/utils/colors.dart';
import 'package:fasttopup/widgets/menuiconwidget.dart';

import '../controllers/dashboard_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/custom_text.dart';

class FinancialScreen extends StatelessWidget {
  FinancialScreen({super.key});

  LanguagesController languagesController = Get.put(LanguagesController());
  final Mypagecontroller mypagecontroller = Get.find();
  final box = GetStorage();
  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      "dd MMM yyyy",
    ).format(DateTime.now());
    final screenWidth = MediaQuery.of(context).size.width;
    final allData = dashboardController.alldashboardData.value.data!;
    final currency = box.read("currency_code") ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
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
                  Obx(
                    () => KText(
                      text: languagesController.tr("FINANCIAL_REPORT"),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: const Color(0xFF1A1A2E),
                    ),
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
                      child: MenuiconWIdget(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ── Date + Currency card ──────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Date row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.calendar_today_rounded,
                                  size: 15,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                languagesController.tr("DATE"),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade100,
                          thickness: 1,
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        // Currency row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.monetization_on_outlined,
                                  size: 15,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                languagesController.tr("CURRENCY"),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  currency,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Balance boxes ─────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        BalanceBox(
                          imagelink: "assets/icons/wallet.png",
                          boxname: languagesController.tr("BALANCE"),
                          balance: dashboardController
                              .userBalanceController
                              .balance
                              .toString(),
                          showDivider: true,
                          valueColor: AppColors.primaryColor,
                        ),
                        BalanceBox(
                          imagelink: "assets/icons/sales.png",
                          boxname: languagesController.tr("SALE"),
                          balance: allData.totalSoldAmount.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFF1D9E75),
                        ),
                        BalanceBox(
                          imagelink: "assets/icons/debit.png",
                          boxname: languagesController.tr("DEBIT"),
                          balance: allData.totalSoldAmount.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFFE24B4A),
                        ),
                        BalanceBox(
                          imagelink: "assets/icons/profit.png",
                          boxname: languagesController.tr("PROFIT"),
                          balance: allData.totalRevenue.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFF1D9E75),
                        ),
                        BalanceBox(
                          imagelink: "assets/icons/loan.png",
                          boxname: languagesController.tr("LOAN_BALANCE"),
                          balance: allData.loanBalance.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFFE24B4A),
                        ),
                        BalanceBox(
                          imagelink: "assets/icons/comission.png",
                          boxname: languagesController.tr("COMISSION"),
                          balance: allData.userInfo!.totalearning.toString(),
                          showDivider: false,
                          valueColor: const Color(0xFF7d5fff),
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
}

// ══════════════════════════════════════════════════════════════════════════════
// BalanceBox
// ══════════════════════════════════════════════════════════════════════════════
class BalanceBox extends StatelessWidget {
  BalanceBox({
    super.key,
    this.imagelink,
    this.boxname,
    this.balance,
    this.showDivider = true,
    this.valueColor,
  });

  String? imagelink;
  String? boxname;
  String? balance;
  bool showDivider;
  Color? valueColor;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final currency = box.read("currency_code") ?? '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              // Icon bubble
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: (valueColor ?? AppColors.primaryColor).withOpacity(
                    0.08,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  imagelink.toString(),
                  color: valueColor ?? AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),

              // Label
              Text(
                boxname.toString(),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const Spacer(),

              // Value + currency
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: NumberFormat.currency(
                        locale: 'en_US',
                        symbol: '',
                        decimalDigits: 2,
                      ).format(double.tryParse(balance.toString()) ?? 0),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: valueColor ?? const Color(0xFF1A1A2E),
                      ),
                    ),
                    TextSpan(
                      text: '  $currency',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFBBBBBB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
