import 'dart:io';

import 'package:fasttopup/widgets/custom_text.dart';
import 'package:fasttopup/widgets/button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/widgets/menuiconwidget.dart';

import '../controllers/add_hawala_controller.dart';
import '../controllers/add_payment_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/payment_method_controller.dart';
import '../controllers/payment_type_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import 'hawala_list_screen.dart';
import 'receipts_screen.dart';

class CreatePaymentsScreen extends StatefulWidget {
  CreatePaymentsScreen({super.key});

  @override
  State<CreatePaymentsScreen> createState() => _CreatePaymentsScreenState();
}

class _CreatePaymentsScreenState extends State<CreatePaymentsScreen> {
  final Mypagecontroller mypagecontroller = Get.find();
  SignInController signInController = Get.put(SignInController());
  CurrencyController currencyController = Get.put(CurrencyController());
  PaymentMethodController paymentMethodController = Get.put(
    PaymentMethodController(),
  );
  PaymentTypeController paymentTypeController = Get.put(
    PaymentTypeController(),
  );
  AddPaymentController addPaymentController = Get.put(AddPaymentController());
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();

  late Rx<DateTime?> mydate;
  var selectedMethod = "".obs;
  var selectedType = "".obs;
  var selectedcurrency = "".obs;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    mydate = Rx<DateTime?>(now);
    addPaymentController.selectedDate.value = DateFormat(
      'yyyy-MM-dd',
    ).format(now);
    paymentMethodController.fetchmethods();
    currencyController.fetchCurrencyList();
    paymentTypeController.fetchtypes();
    selectedcurrency.value = box.read("currency_code");
    addPaymentController.currencyID.value = box.read("countryID");
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5F6FA),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  Future<void> pickStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mydate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      mydate.value = picked;
      addPaymentController.selectedDate.value = DateFormat(
        'yyyy-MM-dd',
      ).format(picked);
    }
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
                      text: languagesController.tr("ADD_NEW_RECEIPT"),
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
            const SizedBox(height: 14),

            // ── Form ─────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
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
                        // ── Payment method ──────────────────────────
                        _label(languagesController.tr("PAYMENT_METHOD")),
                        const SizedBox(height: 6),
                        _buildSelector(
                          valueObs: selectedMethod,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.all(14),
                              content: SizedBox(
                                height: 450,
                                width: screenWidth,
                                child: Obx(
                                  () =>
                                      paymentMethodController.isLoading.value ==
                                          false
                                      ? ListView.builder(
                                          itemCount: paymentMethodController
                                              .allmethods
                                              .value
                                              .data!
                                              .paymentMethods!
                                              .length,
                                          itemBuilder: (context, index) {
                                            final data = paymentMethodController
                                                .allmethods
                                                .value
                                                .data!
                                                .paymentMethods![index];
                                            return GestureDetector(
                                              onTap: () {
                                                addPaymentController
                                                    .payment_method_id
                                                    .value = data.id
                                                    .toString();
                                                selectedMethod.value = data
                                                    .methodName
                                                    .toString();
                                                Navigator.pop(context);
                                              },
                                              child: PaymentMethodBox(
                                                methodName: data.methodName,
                                                bankName: data.bankName,
                                                holderName:
                                                    data.accountHolderName,
                                                cardNumber: data.cardNumber,
                                                accountNumber:
                                                    data.accountNumber,
                                                sebaNumber: data.shebaNumber,
                                                details: data.accountDetails,
                                                imagelink: data.accountImage,
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Amount + Currency ───────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: _label(languagesController.tr("AMOUNT")),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _label(languagesController.tr("CURRENCY")),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            // Amount field
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F6FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 0.5,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: TextField(
                                  controller:
                                      addPaymentController.amountController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,2}'),
                                    ),
                                  ],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 13,
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Currency selector
                            Expanded(
                              flex: 2,
                              child: _buildSelector(
                                valueObs: selectedcurrency,
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    contentPadding: const EdgeInsets.all(14),
                                    content: SizedBox(
                                      height: 250,
                                      width: screenWidth,
                                      child: Obx(
                                        () =>
                                            currencyController
                                                    .isLoading
                                                    .value ==
                                                false
                                            ? ListView.separated(
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 6),
                                                itemCount: currencyController
                                                    .allcurrencylist
                                                    .value
                                                    .data!
                                                    .currencies!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final data =
                                                      currencyController
                                                          .allcurrencylist
                                                          .value
                                                          .data!
                                                          .currencies![index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      addPaymentController
                                                          .currencyID
                                                          .value = data.id
                                                          .toString();
                                                      selectedcurrency.value =
                                                          data.code.toString();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      height: 44,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFFF5F6FA,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade200,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      child: Text(
                                                        '${data.symbol}  ${data.code}',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // ── Payment date ────────────────────────────
                        _label(languagesController.tr("PAYMENT_DATE")),
                        const SizedBox(height: 6),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    addPaymentController.selectedDate.value,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => pickStartDate(context),
                                child: Icon(
                                  Icons.calendar_month_rounded,
                                  size: 20,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Tracking code ───────────────────────────
                        _label(languagesController.tr("TRACKING_CODE")),
                        const SizedBox(height: 6),
                        Authtextfield(
                          hinttext: "",
                          controller:
                              addPaymentController.trackingCodeController,
                        ),
                        const SizedBox(height: 14),

                        // ── Notes (optional) ────────────────────────
                        Row(
                          children: [
                            _label(languagesController.tr("NOTES")),
                            const SizedBox(width: 6),
                            Text(
                              "(${languagesController.tr("OPTIONAL")})",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Authtextfield(
                          hinttext: "",
                          controller: addPaymentController.noteController,
                        ),
                        const SizedBox(height: 14),

                        // ── Payment type ────────────────────────────
                        _label(languagesController.tr("PAYMENT_TYPE")),
                        const SizedBox(height: 6),
                        _buildSelector(
                          valueObs: selectedType,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              contentPadding: const EdgeInsets.all(14),
                              content: SizedBox(
                                height: 170,
                                width: screenWidth,
                                child: Obx(
                                  () =>
                                      paymentTypeController.isLoading.value ==
                                          false
                                      ? ListView.builder(
                                          itemCount: paymentTypeController
                                              .alltypes
                                              .value
                                              .data!
                                              .paymentTypes!
                                              .length,
                                          itemBuilder: (context, index) {
                                            final data = paymentTypeController
                                                .alltypes
                                                .value
                                                .data!
                                                .paymentTypes![index];
                                            return GestureDetector(
                                              onTap: () {
                                                addPaymentController
                                                    .payment_type_id
                                                    .value = data.id
                                                    .toString();
                                                selectedType.value = data.name
                                                    .toString();
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFF5F6FA,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey.shade200,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  data.name.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Upload images ───────────────────────────
                        _label(languagesController.tr("UPLOAD_IMAGES")),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              buildImageUploaderBox(
                                context,
                                languagesController.tr("IMAGE_ONE"),
                                addPaymentController.paymentImagePath,
                                () => addPaymentController.pickImage("payment"),
                              ),
                              const SizedBox(width: 10),
                              buildImageUploaderBox(
                                context,
                                languagesController.tr("IMAGE_TOW"),
                                addPaymentController.extraImage1Path,
                                () => addPaymentController.pickImage("extra1"),
                              ),
                              const SizedBox(width: 10),
                              buildImageUploaderBox(
                                context,
                                languagesController.tr("IMAGE_THREE"),
                                addPaymentController.extraImage2Path,
                                () => addPaymentController.pickImage("extra2"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Submit ──────────────────────────────────
                        Obx(
                          () => DefaultButton1(
                            height: 50,
                            width: screenWidth,
                            buttonName:
                                addPaymentController.isLoading.value == false
                                ? languagesController.tr("ADD_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            onpressed: () {
                              if (addPaymentController
                                      .payment_method_id
                                      .value
                                      .isEmpty ||
                                  addPaymentController
                                      .amountController
                                      .text
                                      .isEmpty ||
                                  addPaymentController
                                      .currencyID
                                      .value
                                      .isEmpty ||
                                  addPaymentController
                                      .selectedDate
                                      .value
                                      .isEmpty ||
                                  addPaymentController
                                      .trackingCodeController
                                      .text
                                      .isEmpty) {
                                Fluttertoast.showToast(
                                  msg:
                                      "Please fill all required fields correctly",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                addPaymentController.addNow();
                              }
                            },
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

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade600,
    ),
  );

  // Generic selector field
  Widget _buildSelector({
    required RxString valueObs,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => Text(
                  valueObs.value,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
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
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// buildImageUploaderBox
// ══════════════════════════════════════════════════════════════════════════════
Widget buildImageUploaderBox(
  BuildContext context,
  String label,
  RxString imagePath,
  VoidCallback onPick,
) {
  return Obx(
    () => Stack(
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: 120,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 0.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: imagePath.value.isNotEmpty
                ? Image.file(
                    File(imagePath.value),
                    width: 120,
                    height: 110,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 26,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (imagePath.value.isNotEmpty)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => imagePath.value = '',
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// PaymentMethodBox
// ══════════════════════════════════════════════════════════════════════════════
class PaymentMethodBox extends StatelessWidget {
  PaymentMethodBox({
    super.key,
    this.methodName,
    this.bankName,
    this.holderName,
    this.cardNumber,
    this.accountNumber,
    this.sebaNumber,
    this.details,
    this.imagelink,
  });

  String? methodName, bankName, holderName, cardNumber;
  String? accountNumber, sebaNumber, details, imagelink;

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: cardNumber != null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent bar
              Container(width: 4, color: AppColors.primaryColor),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Method name + logo
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.payment_rounded,
                              size: 16,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              methodName.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                          if (imagelink != null && imagelink!.isNotEmpty) ...[
                            Container(
                              width: 48,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 0.5,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                imagelink!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.broken_image_outlined,
                                  size: 18,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: Colors.grey.shade100,
                        thickness: 1,
                        height: 1,
                      ),
                      const SizedBox(height: 10),

                      // Card number with copy
                      _copyRow(
                        label: languagesController.tr("CARD_NUMBER"),
                        value: cardNumber.toString(),
                        onCopy: () => _copy(cardNumber!, 'Card number'),
                      ),
                      const SizedBox(height: 8),

                      // Account number with copy
                      _copyRow(
                        label: languagesController.tr("ACCOUNT_NUMBER"),
                        value: accountNumber.toString(),
                        onCopy: () => _copy(accountNumber!, 'Account number'),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Colors.grey.shade100,
                        thickness: 1,
                        height: 1,
                      ),
                      const SizedBox(height: 10),

                      // Holder name
                      _infoRow(
                        languagesController.tr("HOLDER_NAME"),
                        holderName.toString(),
                      ),
                      const SizedBox(height: 6),

                      // Bank name
                      _infoRow(
                        languagesController.tr("BANK_NAME"),
                        bankName.toString(),
                      ),

                      // SEBA
                      if (sebaNumber != null) ...[
                        const SizedBox(height: 6),
                        _infoRow(
                          languagesController.tr("SEBA_NUMBER"),
                          sebaNumber.toString(),
                        ),
                      ],

                      // Details
                      if (details != null && details!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _infoRow(
                          languagesController.tr("DETAILS"),
                          details.toString(),
                          maxLines: 2,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copy(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      '$label copied',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: AppColors.primaryColor,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

  Widget _copyRow({
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.copy_rounded,
                size: 14,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      ],
    );
  }
}
