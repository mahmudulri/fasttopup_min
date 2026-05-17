import 'package:fasttopup/widgets/custom_text.dart';
import 'package:fasttopup/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fasttopup/controllers/sub_reseller_password_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:fasttopup/pages/network.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/widgets/button_one.dart';
import 'package:fasttopup/widgets/drawer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/widgets/menuiconwidget.dart';

import '../controllers/change_pin_controller.dart';
import '../global_controller/font_controller.dart';
import '../utils/colors.dart';

class SetSubresellerPin extends StatefulWidget {
  SetSubresellerPin({super.key, this.subID});
  String? subID;

  @override
  State<SetSubresellerPin> createState() => _SetSubresellerPinState();
}

class _SetSubresellerPinState extends State<SetSubresellerPin> {
  final ChangePinController setpinController = Get.put(ChangePinController());
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
  }

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
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
                    () => KText(
                      text: languagesController.tr("SET_PIN"),
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.042,
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
                      child: Center(child: MenuiconWIdget()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Form card ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 0.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pin icon header
                    Center(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.pin_outlined,
                          size: 26,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade100, height: 1),
                    const SizedBox(height: 16),

                    // New PIN
                    Obx(
                      () => Text(
                        languagesController.tr("NEW_PIN"),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    PasswordBox(controller: setpinController.newPinController),
                    const SizedBox(height: 14),

                    // Confirm PIN
                    Text(
                      languagesController.tr("CONFIRM_PIN"),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PasswordBox(
                      controller: setpinController.confirmPinController,
                    ),
                    const SizedBox(height: 20),

                    // Submit button
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          final newPin = setpinController.newPinController.text
                              .trim();
                          final confirmPin = setpinController
                              .confirmPinController
                              .text
                              .trim();

                          if (newPin.isEmpty || confirmPin.isEmpty) {
                            Fluttertoast.showToast(
                              msg: languagesController.tr(
                                "FILL_DATA_CORRECTLY",
                              ),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (newPin != confirmPin) {
                            Fluttertoast.showToast(
                              msg: languagesController.tr(
                                "DONT_MATCH_BOTH_PIN",
                              ),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            setpinController.setpin(widget.subID.toString());
                          }
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: setpinController.isLoading.value
                                ? Colors.grey.shade300
                                : AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              setpinController.isLoading.value == false
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
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PasswordBox — StatefulWidget with show/hide toggle
// ══════════════════════════════════════════════════════════════════════════════
class PasswordBox extends StatefulWidget {
  PasswordBox({super.key, this.hintText, this.controller});

  String? hintText;
  TextEditingController? controller;

  @override
  State<PasswordBox> createState() => _PasswordBoxState();
}

class _PasswordBoxState extends State<PasswordBox> {
  bool _obscure = true;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscure,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                key: ValueKey(_obscure),
                size: 18,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
