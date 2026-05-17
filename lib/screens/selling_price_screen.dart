import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/controllers/update_selling_price_controller.dart';
import 'package:fasttopup/widgets/authtextfield.dart';
import '../controllers/categories_controller.dart';
import '../controllers/delete_selling_price_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../pages/homepages.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button.dart';
import '../widgets/menuiconwidget.dart';
import 'create_selling_price_screen.dart';

class SellingPriceScreen extends StatefulWidget {
  SellingPriceScreen({super.key});

  @override
  State<SellingPriceScreen> createState() => _SellingPriceScreenState();
}

class _SellingPriceScreenState extends State<SellingPriceScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final SellingPriceController sellingPriceController = Get.put(
    SellingPriceController(),
  );
  UpdateSellingPriceController updateSellingPriceController = Get.put(
    UpdateSellingPriceController(),
  );
  final box = GetStorage();
  final Mypagecontroller mypagecontroller = Get.find();
  final categorisListController = Get.find<CategorisListController>();
  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  List commissiontype = [];

  @override
  void initState() {
    super.initState();
    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5F6FA),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    categorisListController.fetchcategories();
    sellingPriceController.fetchpriceData();
    serviceController.fetchservices();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                      languagesController.tr("SELLING_PRICE"),
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
                  // Search field
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

                  // Create new button
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () => mypagecontroller.changePage(
                        CreateSellingPriceScreen(),
                        isMainPage: false,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(
                  () =>
                      sellingPriceController.isLoading.value == false &&
                          serviceController.isLoading.value == false
                      ? ListView.builder(
                          padding: const EdgeInsets.only(top: 4, bottom: 16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: sellingPriceController
                              .allpricelist
                              .value
                              .data!
                              .pricings!
                              .length,
                          itemBuilder: (context, index) {
                            final data = sellingPriceController
                                .allpricelist
                                .value
                                .data!
                                .pricings![index];

                            final service = serviceController
                                .allservices
                                .value
                                .data!
                                .services
                                .firstWhere(
                                  (s) =>
                                      s.id.toString() ==
                                      data.serviceId.toString(),
                                );

                            final categoryName = categorisListController
                                .allcategorieslist
                                .value
                                .data!
                                .servicecategories!
                                .firstWhere(
                                  (cat) =>
                                      cat.id.toString() ==
                                      data.service!.serviceCategoryId
                                          .toString(),
                                  orElse: () =>
                                      Servicecategory(categoryName: ''),
                                )
                                .categoryName
                                .toString();

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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            // Logo
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color(0xFFF5F6FA),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    service.company!.companyLogo
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),

                                            // Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        service
                                                            .company!
                                                            .companyName
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0xFF1A1A2E,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .primaryColor
                                                              .withOpacity(
                                                                0.08,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          categoryName,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontFamily:
                                                                fontFamily,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    children: [
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
                                                                    .tr(
                                                                      "FIXED",
                                                                    ),
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
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        languagesController.tr(
                                                          "AMOUNT",
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors
                                                              .grey
                                                              .shade500,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        data.amount.toString(),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),

                                            // Edit + Delete
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    updateSellingPriceController
                                                        .amountController
                                                        .text = data.amount
                                                        .toString();
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) => AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                        ),
                                                        content:
                                                            _buildEditDialog(
                                                              context,
                                                              data,
                                                              screenWidth,
                                                              screenHeight,
                                                              fontFamily,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.08),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.edit_rounded,
                                                      size: 15,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () => showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      content: DeleteDialog(
                                                        priceID: data.id
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFFEF2F2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete_rounded,
                                                      size: 15,
                                                      color: Color(0xFFE24B4A),
                                                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditDialog(
    BuildContext context,
    dynamic data,
    double screenWidth,
    double screenHeight,
    String? fontFamily,
  ) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            languagesController.tr("AMOUNT"),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 6),
          Authtextfield(
            hinttext: languagesController.tr("ENTER_AMOUNT"),
            controller: updateSellingPriceController.amountController,
          ),
          const SizedBox(height: 10),
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
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        updateSellingPriceController.commitype.value =
                            commissiontype[index]["name"];
                        updateSellingPriceController.commissiontype.value =
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
                        updateSellingPriceController.commitype.value.toString(),
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
          const SizedBox(height: 10),
          Text(
            languagesController.tr("SERVICE"),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Obx(
                () => updateSellingPriceController.catName.value != ''
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
                              updateSellingPriceController.logolink.toString(),
                              height: 40,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              updateSellingPriceController.serviceName
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              updateSellingPriceController.catName.toString(),
                              textAlign: TextAlign.center,
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
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    child: UpdateServiceBox(),
                  ),
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => DefaultButton1(
              height: 50,
              width: screenWidth,
              buttonName: updateSellingPriceController.isLoading.value == false
                  ? languagesController.tr("UPDATE_NOW")
                  : languagesController.tr("PLEASE_WAIT"),
              onpressed: () {
                if (updateSellingPriceController
                        .amountController
                        .text
                        .isNotEmpty &&
                    updateSellingPriceController.commissiontype.value != "" &&
                    updateSellingPriceController
                        .serviceidcontroller
                        .text
                        .isNotEmpty) {
                  updateSellingPriceController.updatenow(data.id.toString());
                } else {
                  Fluttertoast.showToast(
                    msg: languagesController.tr("FILL_DATA_CORRECTLY"),
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
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DeleteDialog
// ══════════════════════════════════════════════════════════════════════════════
class DeleteDialog extends StatelessWidget {
  DeleteDialog({super.key, this.priceID});

  String? priceID;
  final DeleteSellingPriceController controller = Get.put(
    DeleteSellingPriceController(),
  );
  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Icons.delete_rounded,
              color: Color(0xFFE24B4A),
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            languagesController.tr("DO_YOU_WANT_TO_DELETE"),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    controller.deleteprice(priceID.toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE24B4A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          controller.isLoading.value == false
                              ? languagesController.tr("YES")
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
                        languagesController.tr("NO"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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

// ══════════════════════════════════════════════════════════════════════════════
// UpdateServiceBox
// ══════════════════════════════════════════════════════════════════════════════
class UpdateServiceBox extends StatelessWidget {
  UpdateServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );
  final categorisListController = Get.find<CategorisListController>();
  UpdateSellingPriceController updateSellingPriceController = Get.put(
    UpdateSellingPriceController(),
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
                        updateSellingPriceController.serviceidcontroller.text =
                            data.id.toString();
                        updateSellingPriceController.catName.value = catName;
                        updateSellingPriceController.logolink.value = data
                            .company!
                            .companyLogo
                            .toString();
                        updateSellingPriceController.serviceName.value = data
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
