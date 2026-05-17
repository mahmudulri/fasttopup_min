import 'package:fasttopup/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:fasttopup/pages/network.dart';
import 'package:fasttopup/utils/colors.dart';
import 'package:fasttopup/widgets/authtextfield.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/widgets/button_one.dart';
import 'package:fasttopup/widgets/drawer.dart';

import '../controllers/change_balance_controller.dart';
import '../widgets/menuiconwidget.dart';

class ChangeBalance extends StatefulWidget {
  String? subID;
  ChangeBalance({super.key, this.subID});

  @override
  State<ChangeBalance> createState() => _ChangeBalanceState();
}

class _ChangeBalanceState extends State<ChangeBalance> {
  int _value = 1; // 1 = credit, 2 = debit

  final Mypagecontroller mypagecontroller = Get.find();
  final BalanceController balanceController = Get.put(BalanceController());
  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    balanceController.status.value = "credit";
  }

  Color get _activeColor =>
      _value == 1 ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ─────────────────────────────────────────────
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
                    () => Text(
                      languagesController.tr("CHANGE_BALANCE"),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.042,
                        color: const Color(0xFF1A1A2E),
                      ),
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
                      child: Center(child: MenuiconWIdget()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  // ── Credit / Debit animated toggle cards ────────
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            balanceController.status.value = "credit";
                            setState(() => _value = 1);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _value == 1
                                  ? const Color(0xFFE9F2ED)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _value == 1
                                    ? const Color(0xFF1D9E75)
                                    : Colors.grey.shade200,
                                width: _value == 1 ? 1.5 : 0.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _value == 1
                                        ? const Color(0xFF1D9E75)
                                        : Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 18,
                                    color: _value == 1
                                        ? Colors.white
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Obx(
                                  () => Text(
                                    languagesController.tr("CREDIT"),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: _value == 1
                                          ? const Color(0xFF1D9E75)
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            balanceController.status.value = "debit";
                            setState(() => _value = 2);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _value == 2
                                  ? const Color(0xFFFEF2F2)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _value == 2
                                    ? const Color(0xFFE24B4A)
                                    : Colors.grey.shade200,
                                width: _value == 2 ? 1.5 : 0.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _value == 2
                                        ? const Color(0xFFE24B4A)
                                        : Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 18,
                                    color: _value == 2
                                        ? Colors.white
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Obx(
                                  () => Text(
                                    languagesController.tr("DEBIT"),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: _value == 2
                                          ? const Color(0xFFE24B4A)
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Amount card ──────────────────────────────────
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount label with dynamic icon
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _value == 1
                                    ? const Color(0xFFE9F2ED)
                                    : const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _value == 1
                                    ? Icons.add_rounded
                                    : Icons.remove_rounded,
                                size: 16,
                                color: _activeColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Text(
                                languagesController.tr("AMOUNT"),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Amount input + currency
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Obx(
                                () => Authtextfield(
                                  hinttext: languagesController.tr(
                                    "ENTER_AMOUNT",
                                  ),
                                  controller:
                                      balanceController.amountController,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F6FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/afghanistan.png",
                                      height: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      box.read("currency_code") ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Submit button - color changes with selection
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              if (balanceController
                                      .amountController
                                      .text
                                      .isEmpty ||
                                  balanceController.status.value == '') {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_AMOUNT"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                if (balanceController.status.value ==
                                    "credit") {
                                  balanceController.credit(
                                    widget.subID.toString(),
                                  );
                                } else {
                                  balanceController.debit(
                                    widget.subID.toString(),
                                  );
                                }
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: balanceController.isLoading.value
                                    ? Colors.grey.shade300
                                    : _activeColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  balanceController.isLoading.value == false
                                      ? languagesController.tr("CONFIRMATION")
                                      : languagesController.tr("PLEASE_WAIT"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
