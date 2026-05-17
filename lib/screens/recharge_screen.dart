import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/controllers/drawer_controller.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/widgets/drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:fasttopup/controllers/bundle_controller.dart';
import 'package:fasttopup/controllers/confirm_pin_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/helpers/price.dart';
import 'package:fasttopup/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasttopup/widgets/menuiconwidget.dart';
import 'package:fasttopup/widgets/number_textfield.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../widgets/custom_text.dart';
import 'country_selection.dart';

class RechargeScreen extends StatefulWidget {
  RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void initializeDuration() {
    duration = [
      {"Name": languagesController.tr("All"), "Value": ""},
      {"Name": languagesController.tr("UNLIMITED"), "Value": "unlimited"},
      {"Name": languagesController.tr("MONTHLY"), "Value": "monthly"},
      {"Name": languagesController.tr("WEEKLY"), "Value": "weekly"},
      {"Name": languagesController.tr("DAILY"), "Value": "daily"},
      {"Name": languagesController.tr("HOURLY"), "Value": "hourly"},
      {"Name": languagesController.tr("NIGHTLY"), "Value": "nightly"},
    ];
  }

  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  List<Map<String, String>> duration = [];

  String search = "";
  String inputNumber = "";

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = bundleController.initialpage;

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
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  void _onTextChanged() {
    if (!mounted) return;

    setState(() {
      inputNumber = confirmPinController.numberController.text;

      // Print debug information
      print("Input Number: $inputNumber");

      if (inputNumber.isEmpty) {
        box.write("company_id", "");
        bundleController.initialpage = 1;
        bundleController.finalList.clear();
        bundleController.fetchallbundles();
        // Handle case where text field is cleared
        print("Text field is empty. Showing all services.");

        // Clear the company_id from the box

        // Reset bundleController and fetch all bundles
      } else if (inputNumber.length == 3 || inputNumber.length == 4) {
        final services = serviceController.allserviceslist.value.data!.services;

        // Print number of services for debugging
        print("Number of services: ${services.length}");

        bool matchFound = false;

        for (var service in services) {
          for (var code in service.company!.companycodes!) {
            // Print reservedDigit for debugging
            print("Checking reservedDigit: ${code.reservedDigit}");

            if (code.reservedDigit == inputNumber) {
              box.write("company_id", service.companyId);
              bundleController.initialpage = 1;
              bundleController.finalList.clear();
              setState(() {
                bundleController.fetchallbundles();
              });

              print("Matched company_id: ${service.companyId}");
              matchFound = true;
              break; // Exit the inner loop
            }
          }
          if (matchFound) break; // Exit the outer loop
        }

        if (!matchFound) {
          print("No match found for input number: $inputNumber");
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    bundleController.finalList.clear();
    bundleController.initialpage = 1;
    serviceController.fetchservices();
    bundleController.fetchallbundles();
    confirmPinController.pinController.clear();
    confirmPinController.numberController.clear();

    confirmPinController.numberController.addListener(_onTextChanged);
    initializeDuration();

    scrollController.addListener(refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    confirmPinController.numberController.removeListener(_onTextChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            mypagecontroller.goBack();
                            confirmPinController.numberController.clear();
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
                            text:
                                " ${box.read("countryName")} ${languagesController.tr("INTERNET_PACKAGE")}",
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
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
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      // ── Phone number field ──────────────────────────────────────
                      Obx(
                        () => CustomTextField(
                          confirmPinController:
                              confirmPinController.numberController,
                          languageData: languagesController.tr(
                            "ENTER_PHONE_NUMBER",
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Company selector ────────────────────────────────────────
                      SizedBox(
                        height: 52,
                        child: Obx(() {
                          final services =
                              serviceController
                                  .allserviceslist
                                  .value
                                  .data
                                  ?.services ??
                              [];
                          final filteredServices = inputNumber.isEmpty
                              ? services
                              : services.where((service) {
                                  return service.company?.companycodes?.any((
                                        code,
                                      ) {
                                        final reservedDigit =
                                            code.reservedDigit ?? '';
                                        return inputNumber.startsWith(
                                          reservedDigit,
                                        );
                                      }) ??
                                      false;
                                }).toList();

                          return serviceController.isLoading.value == false
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemCount: filteredServices.length,
                                  itemBuilder: (context, index) {
                                    final data = filteredServices[index];
                                    final isSelected = selectedIndex == index;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          bundleController.initialpage = 1;
                                          bundleController.finalList.clear();
                                          selectedIndex = index;
                                          box.write(
                                            "company_id",
                                            data.companyId,
                                          );
                                          bundleController.fetchallbundles();
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryColor
                                                    .withOpacity(0.1)
                                              : const Color(0xFFF5F6FA),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade200,
                                            width: isSelected ? 1.5 : 0.5,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              data.company?.companyLogo ?? '',
                                          placeholder: (_, __) => const Center(
                                            child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (_, __, ___) => Icon(
                                            Icons.broken_image_outlined,
                                            size: 18,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                        }),
                      ),
                      const SizedBox(height: 12),

                      // ── Duration chips ──────────────────────────────────────────
                      SizedBox(
                        height: 34,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: duration.length,
                          itemBuilder: (context, index) {
                            final isSelected = duration_selectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  duration_selectedIndex = index;
                                  box.write(
                                    "validity_type",
                                    duration[index]["Value"],
                                  );
                                  bundleController.initialpage = 1;
                                  bundleController.finalList.clear();
                                  bundleController.fetchallbundles();
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : const Color(0xFFF5F6FA),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade200,
                                    width: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: KText(
                                    text: languagesController.tr(
                                      duration[index]["Name"]!,
                                    ),
                                    fontSize: screenWidth * 0.030,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Obx(
                        () =>
                            bundleController.isLoading.value == false &&
                                bundleController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          28,
                                                        ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content: StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                28,
                                                              ),
                                                          gradient:
                                                              LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                                  Colors.white,
                                                                  Colors
                                                                      .grey
                                                                      .shade50,
                                                                ],
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                              blurRadius: 30,
                                                              offset: Offset(
                                                                0,
                                                                15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        height: 480,
                                                        width: screenWidth,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                28,
                                                              ),
                                                          child: Obx(
                                                            () =>
                                                                confirmPinController
                                                                        .isLoading
                                                                        .value ==
                                                                    false
                                                                ? ListView(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          24,
                                                                        ),
                                                                    children: [
                                                                      // Header Section with Company Logo & Info
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                              20,
                                                                            ),
                                                                        decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            colors: [
                                                                              AppColors.primaryColor.withOpacity(
                                                                                0.1,
                                                                              ),
                                                                              AppColors.primaryColor.withOpacity(
                                                                                0.05,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(
                                                                            20,
                                                                          ),
                                                                          border: Border.all(
                                                                            color: AppColors.primaryColor.withOpacity(
                                                                              0.2,
                                                                            ),
                                                                            width:
                                                                                1.5,
                                                                          ),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            // Company Logo
                                                                            Container(
                                                                              height: 50,
                                                                              width: 50,
                                                                              padding: EdgeInsets.all(
                                                                                8,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                shape: BoxShape.circle,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.black.withOpacity(
                                                                                      0.1,
                                                                                    ),
                                                                                    blurRadius: 10,
                                                                                    offset: Offset(
                                                                                      0,
                                                                                      4,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: ClipOval(
                                                                                child: CachedNetworkImage(
                                                                                  imageUrl: data.service!.company!.companyLogo.toString(),
                                                                                  fit: BoxFit.cover,
                                                                                  errorWidget:
                                                                                      (
                                                                                        context,
                                                                                        url,
                                                                                        error,
                                                                                      ) => Icon(
                                                                                        Icons.business,
                                                                                        color: Colors.grey.shade400,
                                                                                        size: 30,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 16,
                                                                            ),

                                                                            // Company Details
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  // Bundle Title
                                                                                  Text(
                                                                                    data.bundleTitle.toString(),
                                                                                    style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.grey.shade800,
                                                                                    ),
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),

                                                                                  // Validity Badge
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(
                                                                                      horizontal: 12,
                                                                                      vertical: 4,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      color:
                                                                                          Color(
                                                                                            0xff826AF9,
                                                                                          ).withOpacity(
                                                                                            0.15,
                                                                                          ),
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        8,
                                                                                      ),
                                                                                    ),
                                                                                    child: Text(
                                                                                      data.validityType.toString() ==
                                                                                              "unlimited"
                                                                                          ? languagesController.tr(
                                                                                              "UNLIMITED",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "monthly"
                                                                                          ? languagesController.tr(
                                                                                              "MONTHLY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "weekly"
                                                                                          ? languagesController.tr(
                                                                                              "WEEKLY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "daily"
                                                                                          ? languagesController.tr(
                                                                                              "DAILY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "hourly"
                                                                                          ? languagesController.tr(
                                                                                              "HOURLY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "nightly"
                                                                                          ? languagesController.tr(
                                                                                              "NIGHTLY",
                                                                                            )
                                                                                          : "",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                          0xff826AF9,
                                                                                        ),
                                                                                        fontSize: 11,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),

                                                                      // Pricing Section
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                              18,
                                                                            ),
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius: BorderRadius.circular(
                                                                            16,
                                                                          ),
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            width:
                                                                                1.5,
                                                                          ),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(
                                                                                0.04,
                                                                              ),
                                                                              blurRadius: 10,
                                                                              offset: Offset(
                                                                                0,
                                                                                4,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child: Column(
                                                                          children: [
                                                                            // Buy Price
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    8,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.primaryColor.withOpacity(
                                                                                      0.1,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.shopping_bag_outlined,
                                                                                    color: AppColors.primaryColor,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 12,
                                                                                ),
                                                                                Text(
                                                                                  languagesController.tr(
                                                                                    "BUY",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                PriceTextView(
                                                                                  price: data.buyingPrice.toString(),
                                                                                  textStyle: TextStyle(
                                                                                    color: Colors.black87,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 4,
                                                                                ),
                                                                                Text(
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.grey.shade600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                vertical: 12,
                                                                              ),
                                                                              child: Divider(
                                                                                height: 1,
                                                                                thickness: 1.5,
                                                                                color: Colors.grey.shade200,
                                                                              ),
                                                                            ),

                                                                            // Sell Price
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    8,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.green.shade50,
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.sell_outlined,
                                                                                    color: Colors.green.shade600,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 12,
                                                                                ),
                                                                                Text(
                                                                                  languagesController.tr(
                                                                                    "SELL",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                PriceTextView(
                                                                                  price: data.sellingPrice.toString(),
                                                                                  textStyle: TextStyle(
                                                                                    color: Colors.green.shade600,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 4,
                                                                                ),
                                                                                Text(
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.grey.shade600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),

                                                                      // Container(
                                                                      //   padding:
                                                                      //       EdgeInsets.all(
                                                                      //         16,
                                                                      //       ),
                                                                      //   decoration: BoxDecoration(
                                                                      //     color: Colors
                                                                      //         .blue
                                                                      //         .shade50,
                                                                      //     borderRadius: BorderRadius.circular(
                                                                      //       14,
                                                                      //     ),
                                                                      //     border: Border.all(
                                                                      //       color:
                                                                      //           Colors.blue.shade100,
                                                                      //       width:
                                                                      //           1,
                                                                      //     ),
                                                                      //   ),
                                                                      //   child: Row(
                                                                      //     crossAxisAlignment:
                                                                      //         CrossAxisAlignment.start,
                                                                      //     children: [
                                                                      //       Icon(
                                                                      //         Icons.info_outline_rounded,
                                                                      //         color: Colors.blue.shade600,
                                                                      //         size: 20,
                                                                      //       ),
                                                                      //       SizedBox(
                                                                      //         width: 10,
                                                                      //       ),
                                                                      //       Expanded(
                                                                      //         child: Text(
                                                                      //           "If there is any explanation about the package, it will be included in this section...",
                                                                      //           style: TextStyle(
                                                                      //             color: Colors.grey.shade700,
                                                                      //             fontSize: 12,
                                                                      //             height: 1.4,
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ],
                                                                      //   ),
                                                                      // ),

                                                                      // SizedBox(
                                                                      //   height:
                                                                      //       16,
                                                                      // ),

                                                                      // Phone Number Display
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16,
                                                                          vertical:
                                                                              12,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade50,
                                                                          borderRadius: BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            width:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              languagesController.tr(
                                                                                "PHONENUMBER",
                                                                              ),
                                                                              style: TextStyle(
                                                                                color: Colors.grey.shade600,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              confirmPinController.numberController.text.toString(),
                                                                              style: TextStyle(
                                                                                color: Colors.grey.shade800,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),

                                                                      // PIN Input
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              140,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            border: Border.all(
                                                                              width: 2,
                                                                              color: Colors.grey.shade300,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(
                                                                                  0.05,
                                                                                ),
                                                                                blurRadius: 10,
                                                                                offset: Offset(
                                                                                  0,
                                                                                  4,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.lock_outline_rounded,
                                                                                color: AppColors.primaryColor,
                                                                                size: 18,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 4,
                                                                              ),
                                                                              TextField(
                                                                                maxLength: 4,
                                                                                controller: confirmPinController.pinController,
                                                                                keyboardType: TextInputType.phone,
                                                                                textAlign: TextAlign.center,
                                                                                obscureText: true,
                                                                                decoration: InputDecoration(
                                                                                  counterText: '',
                                                                                  hintText: languagesController.tr(
                                                                                    "PIN",
                                                                                  ),
                                                                                  hintStyle: TextStyle(
                                                                                    color: Colors.grey.shade400,
                                                                                    fontSize: 13,
                                                                                  ),
                                                                                  border: InputBorder.none,
                                                                                  isDense: true,
                                                                                  contentPadding: EdgeInsets.zero,
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),

                                                                      // Action Buttons
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                3,
                                                                            child: GestureDetector(
                                                                              onTap: () async {
                                                                                if (!confirmPinController.isLoading.value) {
                                                                                  if (confirmPinController.pinController.text.isEmpty ||
                                                                                      confirmPinController.pinController.text.length !=
                                                                                          4) {
                                                                                    Fluttertoast.showToast(
                                                                                      msg: languagesController.tr(
                                                                                        "ENTER_YOUR_PIN",
                                                                                      ),
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                      timeInSecForIosWeb: 1,
                                                                                      backgroundColor: Colors.black,
                                                                                      textColor: Colors.white,
                                                                                      fontSize: 16.0,
                                                                                    );
                                                                                  } else {
                                                                                    await confirmPinController.placeOrder(
                                                                                      context,
                                                                                    );
                                                                                    if (confirmPinController.loadsuccess.value ==
                                                                                        true) {
                                                                                      print(
                                                                                        "recharge Done...........",
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: 52,
                                                                                decoration: BoxDecoration(
                                                                                  gradient: LinearGradient(
                                                                                    colors: [
                                                                                      Colors.green.shade400,
                                                                                      Colors.green.shade600,
                                                                                    ],
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    16,
                                                                                  ),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.green.withOpacity(
                                                                                        0.3,
                                                                                      ),
                                                                                      blurRadius: 12,
                                                                                      offset: Offset(
                                                                                        0,
                                                                                        6,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.check_circle_rounded,
                                                                                      color: Colors.white,
                                                                                      size: 20,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                    Text(
                                                                                      languagesController.tr(
                                                                                        "CONFIRMATION",
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                12,
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.pop(
                                                                                  context,
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                height: 52,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    16,
                                                                                  ),
                                                                                  border: Border.all(
                                                                                    width: 2,
                                                                                    color: Colors.grey.shade300,
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.close_rounded,
                                                                                      color: Colors.grey.shade700,
                                                                                      size: 20,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    Text(
                                                                                      languagesController.tr(
                                                                                        "CANCEL",
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                        color: Colors.grey.shade700,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Center(
                                                                    child: Container(
                                                                      height:
                                                                          250,
                                                                      width:
                                                                          250,
                                                                      child: Lottie.asset(
                                                                        'assets/loties/recharge.json',
                                                                      ),
                                                                    ),
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
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 4,
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
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
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 10,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        // Company logo
                                                        Container(
                                                          width: 46,
                                                          height: 46,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              width: 0.5,
                                                            ),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: CachedNetworkImageProvider(
                                                                data
                                                                    .service!
                                                                    .company!
                                                                    .companyLogo
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),

                                                        // Bundle title + buy price
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data.bundleTitle
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 13,
                                                                  color: Color(
                                                                    0xFF1A1A2E,
                                                                  ),
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              const SizedBox(
                                                                height: 6,
                                                              ),
                                                              // Buy price
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          7,
                                                                      vertical:
                                                                          2,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color: const Color(
                                                                        0xFFFEF2F2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            6,
                                                                          ),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Obx(
                                                                          () => Text(
                                                                            languagesController.tr(
                                                                              "BUY",
                                                                            ),
                                                                            style: const TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(
                                                                                0xFFE24B4A,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Text(
                                                                          "  ",
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                        PriceTextView(
                                                                          price: data
                                                                              .buyingPrice
                                                                              .toString(),
                                                                          textStyle: const TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Color(
                                                                              0xFFE24B4A,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          " ${box.read("currency_code")}",
                                                                          style: const TextStyle(
                                                                            fontSize:
                                                                                9,
                                                                            color: Color(
                                                                              0xFFE24B4A,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),

                                                        // Validity + sell price
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // Validity pill
                                                            Obx(() {
                                                              String
                                                              validityLabel =
                                                                  "";
                                                              switch (data
                                                                  .validityType
                                                                  .toString()) {
                                                                case "unlimited":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "UNLIMITED",
                                                                      );
                                                                  break;
                                                                case "monthly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "MONTHLY",
                                                                      );
                                                                  break;
                                                                case "weekly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "WEEKLY",
                                                                      );
                                                                  break;
                                                                case "daily":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "DAILY",
                                                                      );
                                                                  break;
                                                                case "hourly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "HOURLY",
                                                                      );
                                                                  break;
                                                                case "nightly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "NIGHTLY",
                                                                      );
                                                                  break;
                                                                case "yearly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "YEARLY",
                                                                      );
                                                                  break;
                                                              }
                                                              return validityLabel
                                                                      .isNotEmpty
                                                                  ? Container(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            2,
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
                                                                        validityLabel,
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              AppColors.primaryColor,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox();
                                                            }),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),

                                                            // Sell price
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        7,
                                                                    vertical: 2,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    const Color(
                                                                      0xFFE9F2ED,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Obx(
                                                                    () => Text(
                                                                      languagesController
                                                                          .tr(
                                                                            "SALE",
                                                                          ),
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Color(
                                                                          0xFF1D9E75,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    "  ",
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                  PriceTextView(
                                                                    price: data
                                                                        .sellingPrice
                                                                        .toString(),
                                                                    textStyle: const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                        0xFF1D9E75,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${box.read("currency_code")}",
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: Color(
                                                                        0xFF1D9E75,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
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
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : bundleController.finalList.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          28,
                                                        ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content: StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                28,
                                                              ),
                                                          gradient:
                                                              LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                                  Colors.white,
                                                                  Colors
                                                                      .grey
                                                                      .shade50,
                                                                ],
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                              blurRadius: 30,
                                                              offset: Offset(
                                                                0,
                                                                15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        height: 480,
                                                        width: screenWidth,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                28,
                                                              ),
                                                          child: Obx(
                                                            () =>
                                                                confirmPinController
                                                                        .isLoading
                                                                        .value ==
                                                                    false
                                                                ? ListView(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          24,
                                                                        ),
                                                                    children: [
                                                                      // Header Section with Company Logo & Info
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                              20,
                                                                            ),
                                                                        decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            colors: [
                                                                              AppColors.primaryColor.withOpacity(
                                                                                0.1,
                                                                              ),
                                                                              AppColors.primaryColor.withOpacity(
                                                                                0.05,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(
                                                                            20,
                                                                          ),
                                                                          border: Border.all(
                                                                            color: AppColors.primaryColor.withOpacity(
                                                                              0.2,
                                                                            ),
                                                                            width:
                                                                                1.5,
                                                                          ),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            // Company Logo
                                                                            Container(
                                                                              height: 50,
                                                                              width: 50,
                                                                              padding: EdgeInsets.all(
                                                                                8,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                shape: BoxShape.circle,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.black.withOpacity(
                                                                                      0.1,
                                                                                    ),
                                                                                    blurRadius: 10,
                                                                                    offset: Offset(
                                                                                      0,
                                                                                      4,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: ClipOval(
                                                                                child: CachedNetworkImage(
                                                                                  imageUrl: data.service!.company!.companyLogo.toString(),
                                                                                  fit: BoxFit.cover,
                                                                                  errorWidget:
                                                                                      (
                                                                                        context,
                                                                                        url,
                                                                                        error,
                                                                                      ) => Icon(
                                                                                        Icons.business,
                                                                                        color: Colors.grey.shade400,
                                                                                        size: 30,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 16,
                                                                            ),

                                                                            // Company Details
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  // Bundle Title
                                                                                  Text(
                                                                                    data.bundleTitle.toString(),
                                                                                    style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.grey.shade800,
                                                                                    ),
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),

                                                                                  // Validity Badge
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(
                                                                                      horizontal: 12,
                                                                                      vertical: 4,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      color:
                                                                                          Color(
                                                                                            0xff826AF9,
                                                                                          ).withOpacity(
                                                                                            0.15,
                                                                                          ),
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        8,
                                                                                      ),
                                                                                    ),
                                                                                    child: Text(
                                                                                      data.validityType.toString() ==
                                                                                              "unlimited"
                                                                                          ? languagesController.tr(
                                                                                              "UNLIMITED",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "monthly"
                                                                                          ? languagesController.tr(
                                                                                              "MONTHLY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "weekly"
                                                                                          ? languagesController.tr(
                                                                                              "WEEKLY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "daily"
                                                                                          ? languagesController.tr(
                                                                                              "DAILY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "hourly"
                                                                                          ? languagesController.tr(
                                                                                              "HOURLY",
                                                                                            )
                                                                                          : data.validityType.toString() ==
                                                                                                "nightly"
                                                                                          ? languagesController.tr(
                                                                                              "NIGHTLY",
                                                                                            )
                                                                                          : "",
                                                                                      style: TextStyle(
                                                                                        color: Color(
                                                                                          0xff826AF9,
                                                                                        ),
                                                                                        fontSize: 11,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),

                                                                      // Pricing Section
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                              18,
                                                                            ),
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius: BorderRadius.circular(
                                                                            16,
                                                                          ),
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            width:
                                                                                1.5,
                                                                          ),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(
                                                                                0.04,
                                                                              ),
                                                                              blurRadius: 10,
                                                                              offset: Offset(
                                                                                0,
                                                                                4,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child: Column(
                                                                          children: [
                                                                            // Buy Price
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    8,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.primaryColor.withOpacity(
                                                                                      0.1,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.shopping_bag_outlined,
                                                                                    color: AppColors.primaryColor,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 12,
                                                                                ),
                                                                                Text(
                                                                                  languagesController.tr(
                                                                                    "BUY",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                PriceTextView(
                                                                                  price: data.buyingPrice.toString(),
                                                                                  textStyle: TextStyle(
                                                                                    color: Colors.black87,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 4,
                                                                                ),
                                                                                Text(
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.grey.shade600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                vertical: 12,
                                                                              ),
                                                                              child: Divider(
                                                                                height: 1,
                                                                                thickness: 1.5,
                                                                                color: Colors.grey.shade200,
                                                                              ),
                                                                            ),

                                                                            // Sell Price
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    8,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.green.shade50,
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.sell_outlined,
                                                                                    color: Colors.green.shade600,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 12,
                                                                                ),
                                                                                Text(
                                                                                  languagesController.tr(
                                                                                    "SELL",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                PriceTextView(
                                                                                  price: data.sellingPrice.toString(),
                                                                                  textStyle: TextStyle(
                                                                                    color: Colors.green.shade600,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 4,
                                                                                ),
                                                                                Text(
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.grey.shade600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),

                                                                      // Container(
                                                                      //   padding:
                                                                      //       EdgeInsets.all(
                                                                      //         16,
                                                                      //       ),
                                                                      //   decoration: BoxDecoration(
                                                                      //     color: Colors
                                                                      //         .blue
                                                                      //         .shade50,
                                                                      //     borderRadius: BorderRadius.circular(
                                                                      //       14,
                                                                      //     ),
                                                                      //     border: Border.all(
                                                                      //       color:
                                                                      //           Colors.blue.shade100,
                                                                      //       width:
                                                                      //           1,
                                                                      //     ),
                                                                      //   ),
                                                                      //   child: Row(
                                                                      //     crossAxisAlignment:
                                                                      //         CrossAxisAlignment.start,
                                                                      //     children: [
                                                                      //       Icon(
                                                                      //         Icons.info_outline_rounded,
                                                                      //         color: Colors.blue.shade600,
                                                                      //         size: 20,
                                                                      //       ),
                                                                      //       SizedBox(
                                                                      //         width: 10,
                                                                      //       ),
                                                                      //       Expanded(
                                                                      //         child: Text(
                                                                      //           "If there is any explanation about the package, it will be included in this section...",
                                                                      //           style: TextStyle(
                                                                      //             color: Colors.grey.shade700,
                                                                      //             fontSize: 12,
                                                                      //             height: 1.4,
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ],
                                                                      //   ),
                                                                      // ),

                                                                      // SizedBox(
                                                                      //   height:
                                                                      //       16,
                                                                      // ),

                                                                      // Phone Number Display
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16,
                                                                          vertical:
                                                                              12,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade50,
                                                                          borderRadius: BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            width:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              languagesController.tr(
                                                                                "PHONENUMBER",
                                                                              ),
                                                                              style: TextStyle(
                                                                                color: Colors.grey.shade600,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              confirmPinController.numberController.text.toString(),
                                                                              style: TextStyle(
                                                                                color: Colors.grey.shade800,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),

                                                                      // PIN Input
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              140,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            border: Border.all(
                                                                              width: 2,
                                                                              color: Colors.grey.shade300,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(
                                                                                  0.05,
                                                                                ),
                                                                                blurRadius: 10,
                                                                                offset: Offset(
                                                                                  0,
                                                                                  4,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.lock_outline_rounded,
                                                                                color: AppColors.primaryColor,
                                                                                size: 18,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 4,
                                                                              ),
                                                                              TextField(
                                                                                maxLength: 4,
                                                                                controller: confirmPinController.pinController,
                                                                                keyboardType: TextInputType.phone,
                                                                                textAlign: TextAlign.center,
                                                                                obscureText: true,
                                                                                decoration: InputDecoration(
                                                                                  counterText: '',
                                                                                  hintText: languagesController.tr(
                                                                                    "PIN",
                                                                                  ),
                                                                                  hintStyle: TextStyle(
                                                                                    color: Colors.grey.shade400,
                                                                                    fontSize: 13,
                                                                                  ),
                                                                                  border: InputBorder.none,
                                                                                  isDense: true,
                                                                                  contentPadding: EdgeInsets.zero,
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),

                                                                      // Action Buttons
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                3,
                                                                            child: GestureDetector(
                                                                              onTap: () async {
                                                                                if (!confirmPinController.isLoading.value) {
                                                                                  if (confirmPinController.pinController.text.isEmpty ||
                                                                                      confirmPinController.pinController.text.length !=
                                                                                          4) {
                                                                                    Fluttertoast.showToast(
                                                                                      msg: languagesController.tr(
                                                                                        "ENTER_YOUR_PIN",
                                                                                      ),
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                      timeInSecForIosWeb: 1,
                                                                                      backgroundColor: Colors.black,
                                                                                      textColor: Colors.white,
                                                                                      fontSize: 16.0,
                                                                                    );
                                                                                  } else {
                                                                                    await confirmPinController.placeOrder(
                                                                                      context,
                                                                                    );
                                                                                    if (confirmPinController.loadsuccess.value ==
                                                                                        true) {
                                                                                      print(
                                                                                        "recharge Done...........",
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: 52,
                                                                                decoration: BoxDecoration(
                                                                                  gradient: LinearGradient(
                                                                                    colors: [
                                                                                      Colors.green.shade400,
                                                                                      Colors.green.shade600,
                                                                                    ],
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    16,
                                                                                  ),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.green.withOpacity(
                                                                                        0.3,
                                                                                      ),
                                                                                      blurRadius: 12,
                                                                                      offset: Offset(
                                                                                        0,
                                                                                        6,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.check_circle_rounded,
                                                                                      color: Colors.white,
                                                                                      size: 20,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                    Text(
                                                                                      languagesController.tr(
                                                                                        "CONFIRMATION",
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                12,
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.pop(
                                                                                  context,
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                height: 52,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    16,
                                                                                  ),
                                                                                  border: Border.all(
                                                                                    width: 2,
                                                                                    color: Colors.grey.shade300,
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.close_rounded,
                                                                                      color: Colors.grey.shade700,
                                                                                      size: 20,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    Text(
                                                                                      languagesController.tr(
                                                                                        "CANCEL",
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                        color: Colors.grey.shade700,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Center(
                                                                    child: Container(
                                                                      height:
                                                                          250,
                                                                      width:
                                                                          250,
                                                                      child: Lottie.asset(
                                                                        'assets/loties/recharge.json',
                                                                      ),
                                                                    ),
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
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 4,
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
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
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 10,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        // Company logo
                                                        Container(
                                                          width: 46,
                                                          height: 46,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              width: 0.5,
                                                            ),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: CachedNetworkImageProvider(
                                                                data
                                                                    .service!
                                                                    .company!
                                                                    .companyLogo
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),

                                                        // Bundle title + buy price
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data.bundleTitle
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 13,
                                                                  color: Color(
                                                                    0xFF1A1A2E,
                                                                  ),
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              const SizedBox(
                                                                height: 6,
                                                              ),
                                                              // Buy price
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          7,
                                                                      vertical:
                                                                          2,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color: const Color(
                                                                        0xFFFEF2F2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            6,
                                                                          ),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Obx(
                                                                          () => Text(
                                                                            languagesController.tr(
                                                                              "BUY",
                                                                            ),
                                                                            style: const TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(
                                                                                0xFFE24B4A,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Text(
                                                                          "  ",
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                        PriceTextView(
                                                                          price: data
                                                                              .buyingPrice
                                                                              .toString(),
                                                                          textStyle: const TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Color(
                                                                              0xFFE24B4A,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          " ${box.read("currency_code")}",
                                                                          style: const TextStyle(
                                                                            fontSize:
                                                                                9,
                                                                            color: Color(
                                                                              0xFFE24B4A,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),

                                                        // Validity + sell price
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // Validity pill
                                                            Obx(() {
                                                              String
                                                              validityLabel =
                                                                  "";
                                                              switch (data
                                                                  .validityType
                                                                  .toString()) {
                                                                case "unlimited":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "UNLIMITED",
                                                                      );
                                                                  break;
                                                                case "monthly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "MONTHLY",
                                                                      );
                                                                  break;
                                                                case "weekly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "WEEKLY",
                                                                      );
                                                                  break;
                                                                case "daily":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "DAILY",
                                                                      );
                                                                  break;
                                                                case "hourly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "HOURLY",
                                                                      );
                                                                  break;
                                                                case "nightly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "NIGHTLY",
                                                                      );
                                                                  break;
                                                                case "yearly":
                                                                  validityLabel =
                                                                      languagesController.tr(
                                                                        "YEARLY",
                                                                      );
                                                                  break;
                                                              }
                                                              return validityLabel
                                                                      .isNotEmpty
                                                                  ? Container(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            2,
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
                                                                        validityLabel,
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              AppColors.primaryColor,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox();
                                                            }),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),

                                                            // Sell price
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        7,
                                                                    vertical: 2,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    const Color(
                                                                      0xFFE9F2ED,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Obx(
                                                                    () => Text(
                                                                      languagesController
                                                                          .tr(
                                                                            "SALE",
                                                                          ),
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Color(
                                                                          0xFF1D9E75,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    "  ",
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                  PriceTextView(
                                                                    price: data
                                                                        .sellingPrice
                                                                        .toString(),
                                                                    textStyle: const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                        0xFF1D9E75,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${box.read("currency_code")}",
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: Color(
                                                                        0xFF1D9E75,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
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
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
    );
  }
}
