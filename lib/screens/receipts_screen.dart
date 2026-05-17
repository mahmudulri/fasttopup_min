import 'package:fasttopup/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/controllers/dashboard_controller.dart';
import 'package:fasttopup/controllers/drawer_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:fasttopup/screens/add_new_user.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/widgets/menuiconwidget.dart';
import '../controllers/payments_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/custom_text.dart';
import 'create_payments_screen.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

final Mypagecontroller mypagecontroller = Get.find();

LanguagesController languagesController = Get.put(LanguagesController());

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  List orderStatus = [];
  String defaultValue = "";

  String secondDropDown = "";
  @override
  void initState() {
    super.initState();
    paymentsController.fetchpayments();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  PaymentsController paymentsController = Get.put(PaymentsController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 40),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mypagecontroller.goBack();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            "assets/icons/backicon.png",
                            height: 40,
                          ),
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => KText(
                          text: languagesController.tr(
                            "PAYMENT_RECEIPT_REQUEST",
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          CustomFullScreenSheet.show(context);
                        },
                        child: MenuiconWIdget(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () => mypagecontroller.changePage(
                  CreatePaymentsScreen(),
                  isMainPage: false,
                ),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => KText(
                          text: languagesController.tr("ADD_NEW_RECEIPT"),
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(
                  () => paymentsController.isLoading.value == false
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 4, bottom: 16),
                          itemCount: paymentsController
                              .allpaymentslist
                              .value
                              .data!
                              .payments
                              .length,
                          itemBuilder: (context, index) {
                            final data = paymentsController
                                .allpaymentslist
                                .value
                                .data!
                                .payments[index];
                            return _buildPaymentCard(
                              context,
                              data,
                              screenWidth,
                            );
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class PaymentDialog extends StatelessWidget {
  PaymentDialog({
    super.key,
    this.status,
    this.paymentmethod,
    this.amount,
    this.performedByName,
    this.notes,
    this.currency,
    this.date,
    this.image1,
    this.image2,
    this.image3,
  });

  String? status;
  String? paymentmethod;
  String? amount;
  String? performedByName;
  String? notes;
  String? currency;
  String? date;
  String? image1;
  String? image2;
  String? image3;

  final box = GetStorage();
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  Color get _statusColor {
    if (status == "pending") return const Color(0xFFFFC107);
    if (status == "completed") return const Color(0xFF1D9E75);
    return const Color(0xFFE24B4A);
  }

  Color get _statusBg {
    if (status == "pending") return const Color(0xFFFFF8E1);
    if (status == "completed") return const Color(0xFFE9F2ED);
    return const Color(0xFFFEF2F2);
  }

  String get _statusIcon {
    if (status == "pending") return "assets/icons/pending.png";
    if (status == "completed") return "assets/icons/successful.png";
    return "assets/icons/rejected.png";
  }

  String get _statusLabel {
    if (status == "pending") return languagesController.tr("PENDING");
    if (status == "completed") return languagesController.tr("COMPLETED");
    return languagesController.tr("REJECTED");
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
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient header ─────────────────────────────────────────
          Container(
            width: double.infinity,
            color: _statusBg,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Status icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _statusColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(_statusIcon),
                ),
                const SizedBox(height: 10),
                // Status label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Amount
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: amount.toString(),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _statusColor,
                        ),
                      ),
                      TextSpan(
                        text: '  $currency',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _statusColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Info rows ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              children: [
                _row(
                  languagesController.tr("PAYMENT_METHOD"),
                  paymentmethod.toString(),
                ),
                _divider(),
                _row(
                  languagesController.tr("PERFORMED_BY"),
                  performedByName.toString(),
                ),
                _divider(),
                _row(
                  languagesController.tr("DATE"),
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(DateTime.parse(date.toString())),
                ),
                if (notes != null && notes!.isNotEmpty) ...[
                  _divider(),
                  _row(
                    languagesController.tr("NOTES"),
                    notes.toString(),
                    fontFamily: fontFamily,
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Image thumbnails ────────────────────────────────────────
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _imageThumb(image1),
                const SizedBox(width: 8),
                _imageThumb(image2),
                const SizedBox(width: 8),
                _imageThumb(image3),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Dashed divider ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                30,
                (i) => Expanded(
                  child: Container(
                    height: 1,
                    color: i.isEven ? Colors.grey.shade200 : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Close button ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: KText(
                    text: languagesController.tr("CLOSE"),
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    String? fontFamily,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(color: Colors.grey.shade100, thickness: 1, height: 1);

  Widget _imageThumb(String? url) {
    final isEmpty = url == null || url.isEmpty || url == 'null';
    return Container(
      width: 90,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: isEmpty
          ? Center(
              child: Icon(
                Icons.image_outlined,
                size: 24,
                color: Colors.grey.shade300,
              ),
            )
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 22,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
    );
  }
}
// ── Payment card builder (add inside your State class) ────────────────────────

Color _statusColor(String status) {
  if (status == "pending") return const Color(0xFFFFC107);
  if (status == "completed") return const Color(0xFF1D9E75);
  return const Color(0xFFE24B4A);
}

Color _statusBg(String status) {
  if (status == "pending") return const Color(0xFFFFF8E1);
  if (status == "completed") return const Color(0xFFE9F2ED);
  return const Color(0xFFFEF2F2);
}

Widget _buildPaymentCard(
  BuildContext context,
  dynamic data,
  double screenWidth,
) {
  final status = data.status.toString();
  final statusColor = _statusColor(status);
  final statusBg = _statusBg(status);

  return GestureDetector(
    onTap: () => showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        contentPadding: EdgeInsets.zero,
        content: PaymentDialog(
          status: data.status,
          paymentmethod: data.paymentMethod!.methodName,
          amount: data.amount,
          performedByName: data.performedByName,
          currency: data.currency!.code,
          notes: data.notes,
          date: data.paymentDate.toString(),
          image1: data.paymentImageUrl,
          image2: data.extraImage1Url,
          image3: data.extraImage2Url,
        ),
      ),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Header: amount + status ────────────────────────────
          Container(
            color: statusBg,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                // Status dot + label
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Amount
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: data.amount.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                      TextSpan(
                        text: '  ${data.currency!.symbol}',
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Info rows ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Column(
              children: [
                _payRow(
                  languagesController.tr("PAYMENT_METHOD"),
                  data.paymentMethod!.methodName.toString(),
                ),
                _payDivider(),
                _payRow(
                  languagesController.tr("PERFORMED_BY"),
                  data.performedByName.toString(),
                ),
                _payDivider(),
                if (data.notes != null) ...[
                  _payRow(
                    languagesController.tr("NOTES"),
                    data.notes.toString(),
                    valueMaxLines: 1,
                  ),
                  _payDivider(),
                ],
                _payRow(
                  languagesController.tr("DATE"),
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(DateTime.parse(data.paymentDate.toString())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Images row ─────────────────────────────────────────
          SizedBox(
            height: 88,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _buildImageThumb(data.paymentImageUrl),
                const SizedBox(width: 8),
                _buildImageThumb(data.extraImage1Url),
                const SizedBox(width: 8),
                _buildImageThumb(data.extraImage2Url),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

Widget _payRow(String label, String value, {int valueMaxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade900),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: valueMaxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _payDivider() {
  return Divider(color: Colors.grey.shade100, thickness: 1, height: 1);
}

Widget _buildImageThumb(dynamic imageUrl) {
  final url = imageUrl?.toString() ?? '';
  final isEmpty = url.isEmpty || url == 'null';

  return Container(
    width: 100,
    height: 88,
    decoration: BoxDecoration(
      color: const Color(0xFFF5F6FA),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade200, width: 0.5),
    ),
    clipBehavior: Clip.antiAlias,
    child: isEmpty
        ? Center(
            child: Icon(
              Icons.image_outlined,
              size: 28,
              color: Colors.grey.shade300,
            ),
          )
        : Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 24,
                color: Colors.grey.shade300,
              ),
            ),
          ),
  );
}
