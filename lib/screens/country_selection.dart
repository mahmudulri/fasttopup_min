import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/controllers/bundle_controller.dart';
import 'package:fasttopup/controllers/country_list_controller.dart';
import 'package:fasttopup/controllers/dashboard_controller.dart';
import 'package:fasttopup/controllers/drawer_controller.dart';
import 'package:fasttopup/controllers/service_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/pages/homepages.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/widgets/drawer.dart';

import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/menuiconwidget.dart';
import 'recharge_screen.dart';

class InternetPack extends StatefulWidget {
  InternetPack({super.key});

  @override
  State<InternetPack> createState() => _InternetPackState();
}

class _InternetPackState extends State<InternetPack> {
  LanguagesController languagesController = Get.put(LanguagesController());
  CountryListController countrylistController = Get.put(
    CountryListController(),
  );
  BundleController bundleController = Get.put(BundleController());
  ServiceController serviceController = Get.put(ServiceController());
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final box = GetStorage();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Mypagecontroller mypagecontroller = Get.find();

  int? _pressedIndex;

  final List<Color> _cardColors = [
    const Color(0xFFF4EBFC),
    const Color(0xFFE6F1FB),
    const Color(0xFFE9F2ED),
    const Color(0xFFFBF5F1),
    const Color(0xFFEAFBFB),
    const Color(0xFFF7FBEF),
    const Color(0xFFFFF8E1),
    const Color(0xFFFEF2F2),
  ];

  final List<Color> _borderColors = [
    const Color(0xFFDDD6FE),
    const Color(0xFFB5D4F4),
    const Color(0xFFA5D6B0),
    const Color(0xFFFFD5C2),
    const Color(0xFF9FE1CB),
    const Color(0xFFC0DD97),
    const Color(0xFFFFE082),
    const Color(0xFFFECACA),
  ];

  final List<Color> _textColors = [
    const Color(0xFF7d5fff),
    const Color(0xFF185FA5),
    const Color(0xFF1D9E75),
    const Color(0xFF8E5B42),
    const Color(0xFF0F6E56),
    const Color(0xFF3B6D11),
    const Color(0xFFB8860B),
    const Color(0xFFE24B4A),
  ];

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      key: scaffoldKey,
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
                    () => Text(
                      languagesController.tr("COUNTRY_SELECTION"),
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
            const SizedBox(height: 14),

            // ── Grid ─────────────────────────────────────────────────
            Expanded(
              child: Obx(
                () => countrylistController.isLoading.value == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                languagesController.tr("BOOKING_FOR"),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.4,
                                    ),
                                itemCount: countrylistController
                                    .finalCountryList
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = countrylistController
                                      .finalCountryList[index];

                                  final cardColor =
                                      _cardColors[index % _cardColors.length];
                                  final borderColor =
                                      _borderColors[index %
                                          _borderColors.length];
                                  final textColor =
                                      _textColors[index % _textColors.length];

                                  return GestureDetector(
                                    onTapDown: (_) =>
                                        setState(() => _pressedIndex = index),
                                    onTapUp: (_) {
                                      setState(() => _pressedIndex = null);
                                      box.write("country_id", data["id"]);
                                      box.write(
                                        "countryName",
                                        data["country_name"],
                                      );
                                      serviceController.reserveDigit.clear();
                                      bundleController.finalList.clear();
                                      box.write(
                                        "maxlength",
                                        data["phone_number_length"],
                                      );
                                      box.write("validity_type", "");
                                      box.write("company_id", "");
                                      box.write("search_tag", "");
                                      mypagecontroller.changePage(
                                        RechargeScreen(),
                                        isMainPage: false,
                                      );
                                    },
                                    onTapCancel: () =>
                                        setState(() => _pressedIndex = null),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      curve: Curves.easeInOut,
                                      transform: Matrix4.identity()
                                        ..scale(
                                          _pressedIndex == index ? 0.95 : 1.0,
                                        ),
                                      transformAlignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _pressedIndex == index
                                              ? textColor.withOpacity(0.5)
                                              : borderColor,
                                          width: _pressedIndex == index
                                              ? 1.5
                                              : 0.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Flag
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 150,
                                            ),
                                            width: _pressedIndex == index
                                                ? 54
                                                : 50,
                                            height: _pressedIndex == index
                                                ? 54
                                                : 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: textColor.withOpacity(
                                                  0.4,
                                                ),
                                                width: 2,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data["country_flag_image_url"],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          // Country name
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              data["country_name"],
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: screenHeight * 0.016,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
