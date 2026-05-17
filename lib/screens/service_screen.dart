import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/controllers/drawer_controller.dart';
import 'package:fasttopup/utils/colors.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import 'package:fasttopup/controllers/bundle_controller.dart';
import 'package:fasttopup/controllers/service_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:fasttopup/widgets/menuiconwidget.dart';
import '../widgets/custom_text.dart';
import 'social_bundles.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final serviceController = Get.find<ServiceController>();

  final bundleController = Get.find<BundleController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  // final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    serviceController.fetchservices();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                            text: "${languagesController.tr("SERVICES")}",
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
              SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(() {
                    if (serviceController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                          strokeWidth: 1.5,
                        ),
                      );
                    }

                    final services =
                        serviceController
                            .allserviceslist
                            .value
                            .data
                            ?.services ??
                        [];

                    if (services.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 48,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No services available',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Tint colors cycling per item
                    final List<Color> bgColors = [
                      const Color(0xFFF4EBFC),
                      const Color(0xFFE6F1FB),
                      const Color(0xFFE9F2ED),
                      const Color(0xFFFBF5F1),
                      const Color(0xFFEAFBFB),
                      const Color(0xFFF7FBEF),
                      const Color(0xFFFFF8E1),
                      const Color(0xFFFEF2F2),
                    ];
                    final List<Color> accentColors = [
                      const Color(0xFF7d5fff),
                      const Color(0xFF185FA5),
                      const Color(0xFF1D9E75),
                      const Color(0xFF8E5B42),
                      const Color(0xFF0F6E56),
                      const Color(0xFF3B6D11),
                      const Color(0xFFB8860B),
                      const Color(0xFFE24B4A),
                    ];

                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 10),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.72,
                          ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final data = services[index];
                        final bg = bgColors[index % bgColors.length];
                        final accent =
                            accentColors[index % accentColors.length];

                        return _ServiceCard(
                          data: data,
                          bgColor: bg,
                          accentColor: accent,
                          onTap: () {
                            box.write("company_id", data.companyId);
                            mypagecontroller.changePage(
                              SocialBundles(),
                              isMainPage: false,
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// ── _ServiceCard (add inside your State class or as a private widget) ─────────

class _ServiceCard extends StatefulWidget {
  final dynamic data;
  final Color bgColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.data,
    required this.bgColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_pressed ? 0.93 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _pressed
                ? widget.accentColor.withOpacity(0.5)
                : widget.accentColor.withOpacity(0.2),
            width: _pressed ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo circle
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.accentColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: CachedNetworkImage(
                imageUrl: widget.data.company?.companyLogo ?? '',
                placeholder: (_, __) => Center(
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Icon(
                  Icons.broken_image_outlined,
                  size: 18,
                  color: Colors.grey.shade300,
                ),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 7),

            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.data.company?.companyName ?? 'Unknown',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: widget.accentColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
