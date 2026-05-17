import 'package:fasttopup/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_commsion_group_controller.dart';
import '../controllers/commission_group_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/menuiconwidget.dart';

class CommissionGroupScreen extends StatefulWidget {
  CommissionGroupScreen({super.key});

  @override
  State<CommissionGroupScreen> createState() => _CommissionGroupScreenState();
}

class _CommissionGroupScreenState extends State<CommissionGroupScreen> {
  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());
  final commissionlistController = Get.find<CommissionGroupController>();
  final Mypagecontroller mypagecontroller = Get.find();

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
    commissionlistController.fetchGrouplist();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      resizeToAvoidBottomInset: false,
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
                      languagesController.tr("COMMISSION_GROUP"),
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
            const SizedBox(height: 12),

            // ── Search + Create ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 0.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: languagesController.tr("SEARCH"),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          content: CreateGroupBox(),
                        ),
                      ),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              languagesController.tr("CREATE_NEW"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── List ────────────────────────────────────────────────
            Expanded(
              child: Obx(
                () => commissionlistController.isLoading.value == false
                    ? ListView.builder(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: commissionlistController
                            .allgrouplist
                            .value
                            .data!
                            .groups!
                            .length,
                        itemBuilder: (context, index) {
                          final data = commissionlistController
                              .allgrouplist
                              .value
                              .data!
                              .groups![index];
                          final isPercentage =
                              data.commissionType.toString() == "percentage";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 0.5,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Left color bar
                                  Container(
                                    width: 4,
                                    color: AppColors.primaryColor,
                                  ),
                                  // Content
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.groupName.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF1A1A2E),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    // Commission type pill
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 3,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isPercentage
                                                            ? const Color(
                                                                0xFFFFF8E1,
                                                              )
                                                            : const Color(
                                                                0xFFE9F2ED,
                                                              ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        isPercentage
                                                            ? languagesController
                                                                  .tr(
                                                                    "PERCENTAGE",
                                                                  )
                                                            : languagesController
                                                                  .tr("FIXED"),
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: isPercentage
                                                              ? const Color(
                                                                  0xFFB8860B,
                                                                )
                                                              : const Color(
                                                                  0xFF1D9E75,
                                                                ),
                                                          fontFamily:
                                                              fontFamily,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Amount badge
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                languagesController.tr(
                                                  "AMOUNT",
                                                ),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                data.amount.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

// ══════════════════════════════════════════════════════════════════════════════
// CreateGroupBox
// ══════════════════════════════════════════════════════════════════════════════
class CreateGroupBox extends StatefulWidget {
  CreateGroupBox({super.key});

  @override
  State<CreateGroupBox> createState() => _CreateGroupBoxState();
}

class _CreateGroupBoxState extends State<CreateGroupBox> {
  final box = GetStorage();
  final AddCommsionGroupController addCommsionGroupController = Get.put(
    AddCommsionGroupController(),
  );
  LanguagesController languagesController = Get.put(LanguagesController());
  List commissiontype = [];

  @override
  void initState() {
    super.initState();
    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(
              languagesController.tr("COMMISSION_GROUP"),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: const Color(0xFF1A1A2E),
                fontFamily: fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Group name
          _buildLabel(languagesController.tr("GROUP_NAME"), fontFamily),
          const SizedBox(height: 6),
          Authtextfield(
            hinttext: languagesController.tr("ENTER_GROUP_NAME"),
            controller: addCommsionGroupController.nameController,
          ),
          const SizedBox(height: 14),

          // Commission type
          _buildLabel(languagesController.tr("COMMISSION_TYPE"), fontFamily),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.all(14),
                content: SizedBox(
                  height: 120,
                  width: screenWidth,
                  child: ListView.builder(
                    itemCount: commissiontype.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        addCommsionGroupController.commitype.value =
                            commissiontype[index]["name"];
                        addCommsionGroupController.commissiontype.value =
                            commissiontype[index]["value"];
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            commissiontype[index]["name"],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Text(
                        addCommsionGroupController.commitype.value.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Amount
          _buildLabel(languagesController.tr("AMOUNT"), fontFamily),
          const SizedBox(height: 6),
          Authtextfield(
            hinttext: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
            controller: addCommsionGroupController.amountController,
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    addCommsionGroupController.amountController.clear();
                    addCommsionGroupController.nameController.clear();
                    addCommsionGroupController.commissiontype.value = "";
                    addCommsionGroupController.commitype.value = "";
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        languagesController.tr("CANCEL"),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    if (addCommsionGroupController
                            .nameController
                            .text
                            .isNotEmpty &&
                        addCommsionGroupController
                            .amountController
                            .text
                            .isNotEmpty &&
                        addCommsionGroupController.commissiontype.value != "") {
                      addCommsionGroupController.createnow();
                    }
                  },
                  child: Obx(
                    () => Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          addCommsionGroupController.isLoading.value == false
                              ? languagesController.tr("CREATE_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
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

  Widget _buildLabel(String text, String? fontFamily) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
        fontFamily: fontFamily,
      ),
    );
  }
}
