import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:fasttopup/pages/orders.dart';
import 'package:fasttopup/pages/transactions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:fasttopup/screens/financial_screen.dart';
import 'package:fasttopup/widgets/custom_text.dart';
import 'package:fasttopup/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/controllers/bundle_controller.dart';
import 'package:fasttopup/controllers/confirm_pin_controller.dart';
import 'package:fasttopup/controllers/country_list_controller.dart';
import 'package:fasttopup/controllers/dashboard_controller.dart';
import 'package:fasttopup/controllers/drawer_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/screens/credit_transfer.dart';
import 'package:lottie/lottie.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/custom_history_controller.dart';
import '../controllers/custom_recharge_controller.dart';
import '../global_controller/afghan_recharge_controller.dart';
import '../global_controller/balance_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/country_selection.dart';
import '../screens/receipts_screen.dart';
import '../screens/service_screen.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';
import 'package:intl/intl.dart';

import '../widgets/menuiconwidget.dart';

class Homepages extends StatefulWidget {
  Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  List mycolor = [
    Color(0xffF4EBFC),
    Color(0xff7D9AFF).withOpacity(0.14),
    Color(0xffE9F2ED),
    Color(0xffFBF5F1),
    Color(0xffEAFBFB),
    Color(0xffF7FBEF),
  ];

  final List<String> icons = [
    "assets/icons/sim.png",
    "assets/icons/social-bundles.png",
    "assets/icons/dataplan.png",
    "assets/icons/credit-transfer.png",
    "assets/icons/callsmsplan.png",
  ];

  DashboardController dashboardController = Get.put(DashboardController());
  final bundleController = Get.find<BundleController>();
  final box = GetStorage();
  final confirmPinController = Get.find<ConfirmPinController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  final countryListController = Get.find<CountryListController>();
  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  List<Map<String, String>> get items => [
    {
      'name': languagesController.tr("BALANCE"),
      'icon': 'assets/icons/balance2.png',
    },
    {'name': languagesController.tr("DEBIT"), 'icon': 'assets/icons/debit.png'},
    {
      'name': languagesController.tr("PROFIT"),
      'icon': 'assets/icons/profit2.png',
    },
    {
      'name': languagesController.tr("SALE"),
      'icon': 'assets/icons/profit2.png',
    },
    {
      'name': languagesController.tr("COMISSION"),
      'icon': 'assets/icons/profit2.png',
    },
  ];

  RxList<bool> expandedIndices = <bool>[].obs;

  final ScrollController scrollController = ScrollController();
  final Mypagecontroller mypagecontroller = Get.find();
  var currentIndex = 0.obs;
  final companyController = Get.find<CompanyController>();
  ConversationController conversationController = Get.put(
    ConversationController(),
  );
  CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );

  selectcountry() {
    if (countryListController.finalCountryList.isNotEmpty) {
      var afghanistan = countryListController.finalCountryList.firstWhere(
        (c) => c['country_name'] == "Afghanistan",
        orElse: () => null,
      );
      if (afghanistan != null) {
        box.write("country_id", "${afghanistan['id']}");
        box.write("maxlength", "10");
      }
    }
  }

  Future<void> refresh() async {
    final int totalPages =
        customhistoryController
            .allorderlist
            .value
            .payload
            ?.pagination!
            .totalPages ??
        0;
    final int currentPage = customhistoryController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      customhistoryController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (customhistoryController.initialpage <= totalPages) {
        print("Load More...................");
        customhistoryController.fetchHistory();
      } else {
        customhistoryController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final customhistoryController = Get.find<CustomHistoryController>();
  final CurrencyController currencyController = Get.find<CurrencyController>();
  @override
  void initState() {
    super.initState();
    _checkforUpdate();
    selectcountry();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5F6FA),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    controller.reset();
    customhistoryController.finalList.clear();
    customhistoryController.initialpage = 1;
    customhistoryController.fetchHistory();

    companyController.fetchCompany();
    countrylistController.fetchCountryData();

    dashboardController.fetchDashboardData();
    configController.fetchrechargeConfig();
    currencyController.fetchCurrencyList();
    conversationController.resetConversion();
    scrollController.addListener(refresh);

    customRechargeController.numberController.addListener(() {
      final text = customRechargeController.numberController.text;
      companyController.matchCompanyByPhoneNumber(text);
    });
  }

  final AfghanRechargeController controller =
      Get.find<AfghanRechargeController>();

  Future<void> _checkforUpdate() async {
    await InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            if (info.updateAvailability == UpdateAvailability.updateAvailable) {
              _update();
            }
          });
        })
        .catchError((error) {
          print(error.toString());
        });
  }

  void _update() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate()
        .then((_) {})
        .catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedDate = DateFormat("dd MMM yyyy").format(DateTime.now());

    return Obx(() {
      // ── Loading ──────────────────────────────────────────────────────────────
      if (dashboardController.isLoading.value) {
        return Scaffold(
          backgroundColor: Color(0xFFF5F6FA),
          body: Center(child: CircularProgressIndicator(color: Colors.grey)),
        );
      }

      // ── Deactivated ──────────────────────────────────────────────────────────
      if (dashboardController.deactiveStatus.value.trim().toLowerCase() ==
          "deactivated") {
        return Scaffold(
          backgroundColor: Color(0xFFF5F6FA),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dashboardController.deactiveStatus.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dashboardController.deactivateMessage.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          contentPadding: EdgeInsets.zero,
                          content: ContactDialogBox(),
                        ),
                      ),
                      icon: Image.asset(
                        "assets/icons/whatsapp.png",
                        height: 22,
                        color: Colors.white,
                      ),
                      label: KText(
                        text: languagesController.tr("CONTACTUS"),
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        content: LogoutDialogBox(),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        languagesController.tr("LOGOUT"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => dashboardController.fetchDashboardData(),
                    child: Icon(Icons.refresh_rounded, size: 35),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // ── Main ─────────────────────────────────────────────────────────────────

      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xFFFAFAFA),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Enhanced Avatar with Status
                    Stack(
                      children: [
                        Obx(() {
                          final url = dashboardController
                              .alldashboardData
                              .value
                              .data
                              ?.userInfo
                              ?.profileImageUrl;
                          return Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE6F1FB),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                width: 2,
                              ),
                              image: (url != null && url.isNotEmpty)
                                  ? DecorationImage(
                                      image: NetworkImage(url),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: (url == null || url.isEmpty)
                                ? Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFF185FA5),
                                    size: 28,
                                  )
                                : null,
                          );
                        }),
                      ],
                    ),
                    SizedBox(width: 14),
                    // User Info Section
                    Expanded(
                      child: Obx(
                        () => dashboardController.isLoading.value
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // customhistoryController.finalList.clear();
                                      // customhistoryController.initialpage = 1;
                                      // customhistoryController.fetchHistory();
                                      print(box.read("userToken"));
                                    },
                                    child: Text(
                                      dashboardController
                                          .alldashboardData
                                          .value
                                          .data!
                                          .userInfo!
                                          .resellerName
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (dashboardController
                                              .alldashboardData
                                              .value
                                              .data
                                              ?.resellerGroup !=
                                          null &&
                                      dashboardController
                                              .alldashboardData
                                              .value
                                              .data!
                                              .resellerGroup !=
                                          "null")
                                    Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                        dashboardController
                                                .alldashboardData
                                                .value
                                                .data
                                                ?.resellerGroup ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFB0B0B0),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Menu button with modern styling
                    GestureDetector(
                      onTap: () => CustomFullScreenSheet.show(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE8E8E8),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.menu_rounded,
                            color: Colors.black87,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header Section
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: GestureDetector(
                                onTap: () => mypagecontroller.changePage(
                                  FinancialScreen(),
                                  isMainPage: false,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            languagesController.tr(
                                              "FINANCIAL_REPORT",
                                            ),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white.withOpacity(
                                                0.75,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Divider
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            SizedBox(height: 8),

                            // Balance Display Section
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  Obx(
                                    () =>
                                        dashboardController.isLoading.value ==
                                            false
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'en_US',
                                                      symbol: '',
                                                      decimalDigits: 2,
                                                    ).format(
                                                      double.tryParse(
                                                            dashboardController
                                                                .userBalanceController
                                                                .balance
                                                                .toString(),
                                                          ) ??
                                                          0,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    box.read("currency_code") ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                  ),

                                  // Quick Action Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildQuickActionButton(
                                        icon: Icons.add_rounded,
                                        label: languagesController.tr("ADD"),
                                        onpressed: () {
                                          mypagecontroller.changePage(
                                            ReceiptsScreen(),
                                            isMainPage: false,
                                          );
                                        },
                                      ),
                                      _buildQuickActionButton(
                                        icon: Icons.send_rounded,
                                        label: languagesController.tr(
                                          "BALANCE_TRANSACTIONS",
                                        ),
                                        onpressed: () {
                                          mypagecontroller.changePage(
                                            Transactions(),
                                            isMainPage: false,
                                          );
                                        },
                                      ),
                                      _buildQuickActionButton(
                                        icon: Icons.more_horiz_rounded,
                                        label: languagesController.tr("ORDERS"),
                                        onpressed: () {
                                          mypagecontroller.changePage(
                                            Orders(),
                                            isMainPage: false,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 5),
                      Container(
                        width: screenWidth,
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
                            // ── Phone number field ───────────────────────────────────────
                            Container(
                              height: 50,
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
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone_rounded,
                                    size: 18,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      maxLength: 10,
                                      keyboardType: TextInputType.phone,
                                      controller: customRechargeController
                                          .numberController,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none,
                                        isDense: true,
                                        hintText: languagesController.tr(
                                          "PHONENUMBER",
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Company logo
                                  Obx(() {
                                    final company =
                                        companyController.matchedCompany.value;
                                    return Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.shade100,
                                        image: company != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  company.companyLogo ?? '',
                                                ),
                                                fit: BoxFit.contain,
                                              )
                                            : null,
                                      ),
                                      child: company == null
                                          ? Icon(
                                              Icons.business_rounded,
                                              size: 18,
                                              color: Colors.grey.shade300,
                                            )
                                          : null,
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ── Amount field ─────────────────────────────────────────────
                            Container(
                              height: 50,
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
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.payments_rounded,
                                    size: 18,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: controller.calculate,
                                      controller: customRechargeController
                                          .amountController,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        hintText: languagesController.tr(
                                          "AMOUNT",
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "AFN",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // ── Buying / Selling ─────────────────────────────────────────
                            Obx(
                              () => Row(
                                children: [
                                  // Buying
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF8E1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFFFE082),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFFE082,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: const Icon(
                                                  Icons.arrow_downward_rounded,
                                                  size: 10,
                                                  color: Color(0xFFB8860B),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                languagesController.tr(
                                                  "BUYING",
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFB8860B),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                box.read("currency_symbol"),
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Color(0xFFD4A017),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            controller.buyingPrice.value
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFFB8860B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ── Send button ──────────────────────────────────────────────
                            GestureDetector(
                              onTap: () {
                                if (customRechargeController
                                        .numberController
                                        .text
                                        .isEmpty ||
                                    customRechargeController
                                        .amountController
                                        .text
                                        .isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: languagesController.tr(
                                      "ENTER_REQUIRED_DATA",
                                    ),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        content: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              width: screenWidth,
                                              child: Obx(
                                                () =>
                                                    customRechargeController
                                                            .isLoading
                                                            .value ==
                                                        false
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              20,
                                                            ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: 52,
                                                              height: 52,
                                                              decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                      0.1,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      14,
                                                                    ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .send_rounded,
                                                                color: AppColors
                                                                    .primaryColor,
                                                                size: 24,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 14,
                                                            ),
                                                            Text(
                                                              languagesController.tr(
                                                                "ARE_YOU_SURE_TO_TRANSFER",
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                  0xFF1A1A2E,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              children: [
                                                                // Confirm
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: GestureDetector(
                                                                    onTap: () =>
                                                                        customRechargeController.placeOrder(
                                                                          context,
                                                                        ),
                                                                    child: Container(
                                                                      height:
                                                                          46,
                                                                      decoration: BoxDecoration(
                                                                        color: const Color(
                                                                          0xFF1D9E75,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          languagesController.tr(
                                                                            "CONFIRMATION",
                                                                          ),
                                                                          style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                // Cancel
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: GestureDetector(
                                                                    onTap: () =>
                                                                        Navigator.pop(
                                                                          context,
                                                                        ),
                                                                    child: Container(
                                                                      height:
                                                                          46,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                        border: Border.all(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200,
                                                                          width:
                                                                              0.5,
                                                                        ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          languagesController.tr(
                                                                            "CANCEL",
                                                                          ),
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.grey.shade600,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                14,
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
                                                      )
                                                    : SizedBox(
                                                        height: 200,
                                                        child: Lottie.asset(
                                                          'assets/loties/recharge.json',
                                                        ),
                                                      ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
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
                                    const Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    KText(
                                      text: languagesController.tr(
                                        "SEND_TO_DESTINATION",
                                      ),
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 450,
                        width: screenHeight,

                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,

                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                            ),
                            child: Obx(() {
                              if (expandedIndices.length !=
                                  customhistoryController.finalList.length) {
                                expandedIndices.assignAll(
                                  List.generate(
                                    customhistoryController.finalList.length,
                                    (index) => false,
                                  ),
                                );
                              }

                              return customhistoryController.isLoading.value ==
                                          false &&
                                      customhistoryController
                                          .finalList
                                          .isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: refresh,
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: customhistoryController
                                            .finalList
                                            .length,
                                        itemBuilder: (context, index) {
                                          final data = customhistoryController
                                              .finalList[index];

                                          return Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                ExpansionTile(
                                                  key: Key(
                                                    index.toString(),
                                                  ), // Ensure state retention
                                                  initiallyExpanded:
                                                      expandedIndices[index],
                                                  onExpansionChanged:
                                                      (isExpanded) {
                                                        expandedIndices[index] =
                                                            isExpanded;
                                                      },
                                                  tilePadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                  title: Row(
                                                    children: [
                                                      Container(
                                                        height: 45,
                                                        width: 45,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              data
                                                                  .bundle!
                                                                  .service!
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data
                                                                .bundle!
                                                                .bundleTitle
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          Text(
                                                            data.rechargebleAccount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  trailing:
                                                      expandedIndices[index]
                                                      ? null
                                                      : GestureDetector(
                                                          onTap: () {
                                                            expandedIndices[index] =
                                                                true;
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .chevronDown,
                                                                size:
                                                                    screenHeight *
                                                                    0.022,
                                                                color: Color(
                                                                  0xff1890FF,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                languagesController.tr(
                                                                  "TRANSFER_STATUS",
                                                                ),
                                                              ),
                                                              Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languagesController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languagesController.tr(
                                                                        "SUCCESS",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
                                                                          "Fa"
                                                                      ? Get.find<
                                                                              FontController
                                                                            >()
                                                                            .currentFont
                                                                      : null,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                languagesController
                                                                    .tr(
                                                                      "AMOUNT",
                                                                    ),
                                                              ),
                                                              Text(
                                                                "${data.bundle.amount} ${box.read("currency_code")}",
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                languagesController
                                                                    .tr("DATE"),
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
                                                                          "Fa"
                                                                      ? Get.find<
                                                                              FontController
                                                                            >()
                                                                            .currentFont
                                                                      : null,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                  'yyyy-MM-dd',
                                                                ).format(
                                                                  DateTime.parse(
                                                                    data.createdAt
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                languagesController
                                                                    .tr("TIME"),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
                                                                          "Fa"
                                                                      ? Get.find<
                                                                              FontController
                                                                            >()
                                                                            .currentFont
                                                                      : null,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                  'hh:mm a',
                                                                ).format(
                                                                  DateTime.parse(
                                                                    data.createdAt
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : customhistoryController.finalList.isEmpty
                                  ? SizedBox()
                                  : SizedBox();
                            }),
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
    });
  }
}

// ── Helper (add inside your State class) ────────────────────────────────

Widget _buildBottomStat({
  required String label,
  required IconData icon,
  required bool showBorder,
  bool isAction = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border(
        right: showBorder
            ? BorderSide(color: Colors.grey.shade200, width: 0.5)
            : BorderSide.none,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 14,
          color: isAction ? AppColors.primaryColor : AppColors.fontColor,
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isAction ? FontWeight.w600 : FontWeight.w500,
            color: isAction ? AppColors.primaryColor : AppColors.fontColor,
          ),
        ),
      ],
    ),
  );
}

// ── Helper Methods ─────────────────────────────────────────────────────────

Widget _buildQuickActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onpressed,
}) {
  return GestureDetector(
    onTap: onpressed,
    child: Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 24)),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
