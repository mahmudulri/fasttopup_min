import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/help_controller.dart';
import '../global_controller/languages_controller.dart';
import '../pages/homepages.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';

class Helpscreen extends StatefulWidget {
  Helpscreen({super.key});

  @override
  State<Helpscreen> createState() => _HelpscreenState();
}

class _HelpscreenState extends State<Helpscreen> {
  final helpController = Get.find<HelpController>();
  final languagesController = Get.find<LanguagesController>();
  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();
    helpController.helpService();
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
                  // Back button
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
                      languagesController.tr("GUIDE"),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.042,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Drawer button
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
            const SizedBox(height: 14),

            // ── List ──────────────────────────────────────────────────
            Expanded(
              child: Obx(
                () => helpController.isLoading.value == false
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
                        itemCount: helpController
                            .helpdata
                            .value
                            .data!
                            .articles!
                            .length,
                        itemBuilder: (context, index) {
                          final data = helpController
                              .helpdata
                              .value
                              .data!
                              .articles![index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Title row ─────────────────────────
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    14,
                                    14,
                                    14,
                                    10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.help_outline_rounded,
                                          color: AppColors.primaryColor,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          data.title.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Divider
                                Divider(
                                  color: Colors.grey.shade100,
                                  thickness: 1,
                                  height: 1,
                                ),

                                // ── Description row ───────────────────
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    14,
                                    10,
                                    14,
                                    14,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE9F2ED),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.question_answer_outlined,
                                          color: Color(0xFF1D9E75),
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          data.description.toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
