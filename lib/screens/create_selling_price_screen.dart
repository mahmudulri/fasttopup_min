import 'package:fasttopup/widgets/custom_text.dart';
import 'package:fasttopup/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/widgets/menuiconwidget.dart';

import '../controllers/add_selling_price_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/only_service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import 'selling_price_screen.dart';

class CreateSellingPriceScreen extends StatefulWidget {
  const CreateSellingPriceScreen({super.key});

  @override
  State<CreateSellingPriceScreen> createState() =>
      _CreateSellingPriceScreenState();
}

class _CreateSellingPriceScreenState extends State<CreateSellingPriceScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final categorisListController = Get.find<CategorisListController>();
  List commissiontype = [];

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
    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final Mypagecontroller mypagecontroller = Get.find();
    final AddSellingPriceController addSellingPriceController = Get.put(
      AddSellingPriceController(),
    );
    final box = GetStorage();
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F6FA),
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
                      text: languagesController.tr("CREATE_SELLING_PRICE"),
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
            const SizedBox(height: 16),

            // ── Form card ───────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
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
                      // ── Amount ─────────────────────────────────
                      _buildLabel(languagesController.tr("AMOUNT"), fontFamily),
                      const SizedBox(height: 6),
                      Authtextfield(
                        hinttext: languagesController.tr("ENTER_AMOUNT"),
                        controller: addSellingPriceController.amountController,
                      ),
                      const SizedBox(height: 14),

                      // ── Commission type ─────────────────────────
                      _buildLabel(
                        languagesController.tr("COMMISSION_TYPE"),
                        fontFamily,
                      ),
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
                              height: 150,
                              width: screenWidth,
                              child: ListView.builder(
                                itemCount: commissiontype.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        addSellingPriceController
                                                .commitype
                                                .value =
                                            commissiontype[index]["name"];
                                        addSellingPriceController
                                                .commissiontype
                                                .value =
                                            commissiontype[index]["value"];
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F6FA),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            commissiontype[index]["name"],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
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
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    addSellingPriceController.commitype.value
                                        .toString(),
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

                      // ── Service ─────────────────────────────────
                      _buildLabel(
                        languagesController.tr("SERVICE"),
                        fontFamily,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Selected service preview
                          Obx(
                            () => addSellingPriceController.catName.value != ''
                                ? Container(
                                    width: 120,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F6FA),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.network(
                                          addSellingPriceController.logolink
                                              .toString(),
                                          height: 42,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          addSellingPriceController.serviceName
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          addSellingPriceController.catName
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          const SizedBox(width: 12),

                          // Select service button
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                child: ServiceBox(),
                              ),
                            ),
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 0.5,
                                ),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Create button ───────────────────────────
                      Obx(
                        () => DefaultButton1(
                          height: 50,
                          width: screenWidth,
                          buttonName:
                              addSellingPriceController.isLoading.value == false
                              ? languagesController.tr("CREATE_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            if (addSellingPriceController
                                    .amountController
                                    .text
                                    .isNotEmpty &&
                                addSellingPriceController
                                        .commissiontype
                                        .value !=
                                    "" &&
                                addSellingPriceController
                                    .serviceidcontroller
                                    .text
                                    .isNotEmpty) {
                              addSellingPriceController.createnow();
                            } else {
                              Fluttertoast.showToast(
                                msg: "Fill data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
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

// ══════════════════════════════════════════════════════════════════════════════
// ServiceBox
// ══════════════════════════════════════════════════════════════════════════════
class ServiceBox extends StatelessWidget {
  ServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );
  final categorisListController = Get.find<CategorisListController>();
  final AddSellingPriceController addSellingPriceController = Get.put(
    AddSellingPriceController(),
  );
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 500,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Obx(
          () => serviceController.isLoading.value == false
              ? GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount:
                      serviceController.allservices.value.data!.services.length,
                  itemBuilder: (context, index) {
                    final data = serviceController
                        .allservices
                        .value
                        .data!
                        .services[index];

                    final catName = categorisListController
                        .allcategorieslist
                        .value
                        .data!
                        .servicecategories!
                        .firstWhere(
                          (cat) =>
                              cat.id.toString() ==
                              data.serviceCategoryId.toString(),
                          orElse: () => Servicecategory(categoryName: ''),
                        )
                        .categoryName
                        .toString();

                    return GestureDetector(
                      onTap: () {
                        addSellingPriceController.serviceidcontroller.text =
                            data.id.toString();
                        addSellingPriceController.catName.value = catName;
                        addSellingPriceController.logolink.value = data
                            .company!
                            .companyLogo
                            .toString();
                        addSellingPriceController.serviceName.value = data
                            .company!
                            .companyName
                            .toString();
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              data.company!.companyLogo.toString(),
                              height: 44,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data.company!.companyName.toString(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                                fontFamily: fontFamily,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              catName,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontFamily: fontFamily,
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
    );
  }
}
