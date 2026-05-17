import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fasttopup/controllers/change_status_controller.dart';
import 'package:fasttopup/controllers/dashboard_controller.dart';
import 'package:fasttopup/controllers/delete_sub_resellercontroller.dart';
import 'package:fasttopup/controllers/drawer_controller.dart';
import 'package:fasttopup/controllers/subreseller_details_controller.dart';
import 'package:fasttopup/global_controller/languages_controller.dart';
import 'package:fasttopup/global_controller/page_controller.dart';
import 'package:fasttopup/screens/add_new_user.dart';
import 'package:fasttopup/screens/change_balance.dart';
import 'package:fasttopup/screens/set_password.dart';
import 'package:fasttopup/utils/colors.dart';
import 'package:fasttopup/widgets/bottomsheet.dart';
import '../controllers/commission_group_controller.dart';
import '../controllers/set_commission_group_controller.dart';
import '../controllers/sub_reseller_controller.dart';
import '../global_controller/font_controller.dart';
import '../screens/set_subreseller_pin.dart';
import '../widgets/custom_text.dart';
import '../widgets/menuiconwidget.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

final Mypagecontroller mypagecontroller = Get.find();

final subresellercontroller = Get.find<SubresellerController>();
LanguagesController languagesController = Get.put(LanguagesController());
final detailsController = Get.find<SubresellerDetailsController>();

final DeleteSubResellerController deleteSubResellerController = Get.put(
  DeleteSubResellerController(),
);

final ChangeStatusController changeStatusController = Get.put(
  ChangeStatusController(),
);

final commissionlistController = Get.find<CommissionGroupController>();

SetCommissionGroupController controller = Get.put(
  SetCommissionGroupController(),
);

class _NetworkState extends State<Network> {
  Set<int> expandedIndices = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    subresellercontroller.fetchSubReseller();
    commissionlistController.fetchGrouplist();
  }

  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => dashboardController.deactiveStatus.value != "Deactivated"
          ? Scaffold(
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
                              Obx(() {
                                final profileImageUrl = dashboardController
                                    .alldashboardData
                                    .value
                                    .data
                                    ?.userInfo
                                    ?.profileImageUrl;

                                if (dashboardController.isLoading.value ||
                                    profileImageUrl == null ||
                                    profileImageUrl.isEmpty) {
                                  return Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  );
                                }

                                return Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(profileImageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                              Spacer(),
                              Obx(
                                () => KText(
                                  text: languagesController.tr("NETWORK"),
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            // ── Add User button ───────────────────────────────────────────
                            GestureDetector(
                              onTap: () => mypagecontroller.changePage(
                                AddNewUser(),
                                isMainPage: false,
                              ),
                              child: Obx(
                                () => Container(
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: languagesController.tr(
                                          "ADD_USER",
                                        ),
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // ── Search by phone ───────────────────────────────────────────
                            Container(
                              height: 46,
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
                                    Icons.search_rounded,
                                    color: Colors.grey.shade400,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Obx(
                                      () => TextField(
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.036,
                                          color: Colors.grey.shade700,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: languagesController.tr(
                                            "SEARCH_BY_PHOENUMBER",
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: screenWidth * 0.036,
                                            fontFamily:
                                                box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                      .currentFont
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ── Search by name ────────────────────────────────────────────
                            Container(
                              height: 46,
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
                                    Icons.person_search_rounded,
                                    color: Colors.grey.shade400,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Obx(
                                      () => TextField(
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.036,
                                          color: Colors.grey.shade700,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: languagesController.tr(
                                            "SEARCH_BY_NAME",
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: screenWidth * 0.036,
                                            fontFamily:
                                                box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                      .currentFont
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: 410,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Obx(
                            () => subresellercontroller.isLoading.value == false
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: ListView.separated(
                                      padding: EdgeInsets.all(0),
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 8);
                                      },
                                      itemCount: subresellercontroller
                                          .allsubresellerData
                                          .value
                                          .data!
                                          .resellers
                                          .length,
                                      itemBuilder: (context, index) {
                                        final data = subresellercontroller
                                            .allsubresellerData
                                            .value
                                            .data!
                                            .resellers[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 0.5,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent,
                                            ),
                                            child: ExpansionTile(
                                              onExpansionChanged: (isExpanded) {
                                                setState(() {
                                                  if (isExpanded) {
                                                    expandedIndices.add(index);
                                                    detailsController
                                                        .fetchSubResellerDetails(
                                                          data.id.toString(),
                                                        );
                                                  } else {
                                                    expandedIndices.remove(
                                                      index,
                                                    );
                                                  }
                                                });
                                              },

                                              // ── Tile header ────────────────────────────────────────────────
                                              tilePadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 4,
                                                  ),
                                              title: Row(
                                                children: [
                                                  // Avatar
                                                  data.profileImageUrl != null
                                                      ? Container(
                                                          height: 44,
                                                          width: 44,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                              image: NetworkImage(
                                                                data.profileImageUrl
                                                                    .toString(),
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 44,
                                                          width: 44,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                expandedIndices
                                                                    .contains(
                                                                      index,
                                                                    )
                                                                ? AppColors
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                        0.12,
                                                                      )
                                                                : const Color(
                                                                    0xFFE6F1FB,
                                                                  ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .person_rounded,
                                                            color:
                                                                expandedIndices
                                                                    .contains(
                                                                      index,
                                                                    )
                                                                ? AppColors
                                                                      .primaryColor
                                                                : const Color(
                                                                    0xFF185FA5,
                                                                  ),
                                                            size: 22,
                                                          ),
                                                        ),
                                                  const SizedBox(width: 12),

                                                  // Name + phone
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        KText(
                                                          text: data.contactName
                                                              .toString(),
                                                          color: Colors
                                                              .grey
                                                              .shade800,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              screenHeight *
                                                              0.018,
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          data.phone.toString(),
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey
                                                                .shade500,
                                                            fontSize:
                                                                screenHeight *
                                                                0.015,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Eye icon
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    margin:
                                                        const EdgeInsets.only(
                                                          right: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFF5F6FA,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      expandedIndices.contains(
                                                            index,
                                                          )
                                                          ? Icons
                                                                .visibility_rounded
                                                          : Icons
                                                                .visibility_off_outlined,
                                                      size: 16,
                                                      color:
                                                          expandedIndices
                                                              .contains(index)
                                                          ? AppColors
                                                                .primaryColor
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // ── Edit button (trailing) ──────────────────────────────────────
                                              trailing: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        content: Container(
                                                          width: screenWidth,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.fromLTRB(
                                                                20,
                                                                20,
                                                                20,
                                                                16,
                                                              ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              _buildMenuAction(
                                                                assetPath:
                                                                    "assets/icons/usdicon.png",
                                                                label: languagesController.tr(
                                                                  "CHANGE_BALANCE",
                                                                ),
                                                                onTap: () {
                                                                  mypagecontroller.changePage(
                                                                    ChangeBalance(
                                                                      subID: data
                                                                          .id
                                                                          .toString(),
                                                                    ),
                                                                    isMainPage:
                                                                        false,
                                                                  );
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                screenHeight:
                                                                    screenHeight,
                                                              ),
                                                              _buildMenuDivider(),
                                                              _buildMenuAction(
                                                                assetPath:
                                                                    "assets/icons/padlock.png",
                                                                label: languagesController.tr(
                                                                  "SET_PASSWORD",
                                                                ),
                                                                onTap: () {
                                                                  mypagecontroller.changePage(
                                                                    SetPassword(
                                                                      subID: data
                                                                          .id
                                                                          .toString(),
                                                                    ),
                                                                    isMainPage:
                                                                        false,
                                                                  );
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                screenHeight:
                                                                    screenHeight,
                                                              ),
                                                              _buildMenuDivider(),
                                                              _buildMenuAction(
                                                                assetPath:
                                                                    "assets/icons/discount.png",
                                                                label: languagesController.tr(
                                                                  "SET_COMMISSION_GROUP",
                                                                ),
                                                                iconColor:
                                                                    Colors
                                                                        .green,
                                                                onTap: () async {
                                                                  showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.vertical(
                                                                            top: Radius.circular(
                                                                              20,
                                                                            ),
                                                                          ),
                                                                    ),
                                                                    builder: (context) {
                                                                      return Obx(() {
                                                                        if (commissionlistController
                                                                            .isLoading
                                                                            .value) {
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        }
                                                                        final groups =
                                                                            commissionlistController.allgrouplist.value.data?.groups ??
                                                                            [];
                                                                        return ListView.builder(
                                                                          itemCount:
                                                                              groups.length,
                                                                          itemBuilder:
                                                                              (
                                                                                context,
                                                                                index,
                                                                              ) {
                                                                                final group = groups[index];
                                                                                return ListTile(
                                                                                  title: Text(
                                                                                    group.groupName ??
                                                                                        '',
                                                                                  ),
                                                                                  subtitle: Text(
                                                                                    "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}",
                                                                                  ),
                                                                                  trailing:
                                                                                      data.subResellerCommissionGroupId.toString() ==
                                                                                          group.id.toString()
                                                                                      ? const Icon(
                                                                                          Icons.check,
                                                                                          color: Colors.green,
                                                                                        )
                                                                                      : null,
                                                                                  onTap: () async {
                                                                                    Navigator.pop(
                                                                                      context,
                                                                                    );
                                                                                    await controller.setgroup(
                                                                                      data.id.toString(),
                                                                                      group.id.toString(),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                        );
                                                                      });
                                                                    },
                                                                  );
                                                                },
                                                                screenHeight:
                                                                    screenHeight,
                                                              ),
                                                              _buildMenuDivider(),
                                                              _buildMenuAction(
                                                                assetPath:
                                                                    "assets/icons/key.png",
                                                                label: languagesController
                                                                    .tr(
                                                                      "SET_PIN",
                                                                    ),
                                                                onTap: () {
                                                                  mypagecontroller.changePage(
                                                                    SetSubresellerPin(
                                                                      subID: data
                                                                          .id
                                                                          .toString(),
                                                                    ),
                                                                    isMainPage:
                                                                        false,
                                                                  );
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                screenHeight:
                                                                    screenHeight,
                                                              ),
                                                              _buildMenuDivider(),
                                                              _buildMenuAction(
                                                                assetPath:
                                                                    data.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? "assets/icons/pause.png"
                                                                    : "assets/icons/active.png",
                                                                label:
                                                                    data.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? languagesController.tr(
                                                                        "DEACTIVE",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "ACTIVE",
                                                                      ),
                                                                onTap: () {
                                                                  changeStatusController
                                                                      .channgestatus(
                                                                        data.id
                                                                            .toString(),
                                                                      );
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                screenHeight:
                                                                    screenHeight,
                                                              ),
                                                              _buildMenuDivider(),
                                                              _buildMenuAction(
                                                                assetPath:
                                                                    "assets/icons/delete.png",
                                                                label: languagesController
                                                                    .tr(
                                                                      "DELETE",
                                                                    ),
                                                                labelColor:
                                                                    Colors.red,
                                                                onTap: () {
                                                                  deleteSubResellerController
                                                                      .deletesub(
                                                                        data.id
                                                                            .toString(),
                                                                      );
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                screenHeight:
                                                                    screenHeight,
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child: Container(
                                                                  height: 46,
                                                                  width: double
                                                                      .infinity,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200,
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                  ),
                                                                  child: Center(
                                                                    child: KText(
                                                                      text: languagesController.tr(
                                                                        "CLOSE",
                                                                      ),
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFF4EBFC,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.edit_rounded,
                                                    size: 15,
                                                    color: Color(0xFF7d5fff),
                                                  ),
                                                ),
                                              ),

                                              // ── Expanded content ───────────────────────────────────────────
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade50,
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: Colors
                                                            .grey
                                                            .shade100,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        14,
                                                        12,
                                                        14,
                                                        14,
                                                      ),
                                                  child: Obx(
                                                    () =>
                                                        detailsController
                                                                .isLoading
                                                                .value ==
                                                            false
                                                        ? Column(
                                                            children: [
                                                              // Stats 3x2 grid
                                                              GridView.count(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                crossAxisCount:
                                                                    3,
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                crossAxisSpacing:
                                                                    8,
                                                                mainAxisSpacing:
                                                                    8,
                                                                childAspectRatio:
                                                                    1.1,
                                                                children: [
                                                                  _buildStatCell(
                                                                    label: languagesController.tr(
                                                                      "TODAY_ORDER",
                                                                    ),
                                                                    value: detailsController
                                                                        .allsubresellerDetailsData
                                                                        .value
                                                                        .data!
                                                                        .reseller!
                                                                        .todayOrders
                                                                        .toString(),
                                                                    currency: box
                                                                        .read(
                                                                          "currency_code",
                                                                        ),
                                                                    valueColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade800,
                                                                  ),
                                                                  _buildStatCell(
                                                                    label: languagesController.tr(
                                                                      "TOTAL_ORDER",
                                                                    ),
                                                                    value: detailsController
                                                                        .allsubresellerDetailsData
                                                                        .value
                                                                        .data!
                                                                        .reseller!
                                                                        .totalOrders
                                                                        .toString(),
                                                                    currency: box
                                                                        .read(
                                                                          "currency_code",
                                                                        ),
                                                                    valueColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade800,
                                                                  ),
                                                                  _buildStatCell(
                                                                    label: languagesController.tr(
                                                                      "TODAY_SALE",
                                                                    ),
                                                                    value: detailsController
                                                                        .allsubresellerDetailsData
                                                                        .value
                                                                        .data!
                                                                        .reseller!
                                                                        .todaySale
                                                                        .toString(),
                                                                    currency: box
                                                                        .read(
                                                                          "currency_code",
                                                                        ),
                                                                    valueColor:
                                                                        const Color(
                                                                          0xFF1D9E75,
                                                                        ),
                                                                  ),
                                                                  _buildStatCell(
                                                                    label: languagesController.tr(
                                                                      "TOTAL_SALE",
                                                                    ),
                                                                    value: detailsController
                                                                        .allsubresellerDetailsData
                                                                        .value
                                                                        .data!
                                                                        .reseller!
                                                                        .totalSale
                                                                        .toString(),
                                                                    currency: box
                                                                        .read(
                                                                          "currency_code",
                                                                        ),
                                                                    valueColor:
                                                                        const Color(
                                                                          0xFF1D9E75,
                                                                        ),
                                                                  ),
                                                                  _buildStatCell(
                                                                    label: languagesController.tr(
                                                                      "TODAY_PROFIT",
                                                                    ),
                                                                    value: detailsController
                                                                        .allsubresellerDetailsData
                                                                        .value
                                                                        .data!
                                                                        .reseller!
                                                                        .todayProfit
                                                                        .toString(),
                                                                    currency: box
                                                                        .read(
                                                                          "currency_code",
                                                                        ),
                                                                    valueColor:
                                                                        const Color(
                                                                          0xFF7d5fff,
                                                                        ),
                                                                  ),
                                                                  _buildStatCell(
                                                                    label: languagesController.tr(
                                                                      "TOTAL_PROFIT",
                                                                    ),
                                                                    value: detailsController
                                                                        .allsubresellerDetailsData
                                                                        .value
                                                                        .data!
                                                                        .reseller!
                                                                        .totalProfit
                                                                        .toString(),
                                                                    currency: box
                                                                        .read(
                                                                          "currency_code",
                                                                        ),
                                                                    valueColor:
                                                                        const Color(
                                                                          0xFF7d5fff,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              // Balance row
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  gradient: const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                        0xFF5B3FCC,
                                                                      ),
                                                                      Color(
                                                                        0xFF7d5fff,
                                                                      ),
                                                                    ],
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    KText(
                                                                      text: languagesController.tr(
                                                                        "ACCOUNT_BALANCE",
                                                                      ),
                                                                      fontSize:
                                                                          screenHeight *
                                                                          0.016,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                            0.85,
                                                                          ),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    RichText(
                                                                      text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                detailsController.allsubresellerDetailsData.value.data!.reseller!.balance.toString(),
                                                                            style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                "  ${box.read("currency_code")}",
                                                                            style: TextStyle(
                                                                              fontSize: 11,
                                                                              color: Colors.white.withOpacity(
                                                                                0.6,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      dashboardController.deactiveStatus.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      dashboardController.deactivateMessage.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                contentPadding: EdgeInsets.all(0),
                                content: ContactDialogBox(),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 45,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/whatsapp.png",
                                height: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 20),
                              KText(
                                text: languagesController.tr("CONTACTUS"),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              content: LogoutDialogBox(),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
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
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}

Widget _buildMenuDivider() {
  return Divider(color: Colors.grey.shade100, thickness: 1, height: 1);
}

// ── Helpers (add inside your State class) ─────────────────────────────────────

Widget _buildStatCell({
  required String label,
  required String value,
  required String currency,
  required Color valueColor,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade100, width: 0.5),
    ),
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFFBBBBBB),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        Text(
          currency,
          style: const TextStyle(fontSize: 9, color: Color(0xFFBBBBBB)),
        ),
      ],
    ),
  );
}

Widget _buildMenuAction({
  required String assetPath,
  required String label,
  required VoidCallback onTap,
  required double screenHeight,
  Color? iconColor,
  Color? labelColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(7),
            child: Image.asset(assetPath, color: iconColor),
          ),
          const SizedBox(width: 12),
          KText(
            text: label,
            color: labelColor ?? Colors.grey.shade700,
            fontSize: screenHeight * 0.018,
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: Color(0xFFCCCCCC),
          ),
        ],
      ),
    ),
  );
}
