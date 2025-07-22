import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:financial_ai_mobile/controller/analyze/analyze_controller.dart';
import 'package:financial_ai_mobile/controller/home/home_controller.dart';
import 'package:financial_ai_mobile/core/utils/app_icons.dart';
import 'package:financial_ai_mobile/core/utils/app_routes.dart';
import 'package:financial_ai_mobile/core/utils/app_styles.dart';
// import 'package:financial_ai_mobile/views/screens/analyze/ai_optimizes_screen.dart';
import 'package:financial_ai_mobile/views/screens/home/subs_screen/accounts/accounts_screen.dart';
import 'package:financial_ai_mobile/views/screens/home/subs_screen/courses/courses_item.dart';
// import 'package:financial_ai_mobile/views/screens/home/subs_screen/courses/courses_screen.dart';
import 'package:financial_ai_mobile/views/screens/home/subs_screen/expense_details/espense_details_screen.dart';
import 'package:financial_ai_mobile/views/screens/notification/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final AnalyzeController controller = Get.put(AnalyzeController());

  @override
  void initState() {
    super.initState();
    // You can perform initial data loading here if needed
    // homeController.getUserPresentMonthData();
    // controller.getReportCategory();
  }

  @override
  void dispose() {
    // This is important if HomeController and AnalyzeController should only live
    // as long as HomeScreen. If they are global, you might not delete them here.
    // Get.delete<HomeController>();
    // Get.delete<AnalyzeController>();
    super.dispose();
  }

  // This is AnalyzeController
  String _getIconForCategory(String categoryName) {
    final Map<String, String> categoryIconMap = {
      "food_dining": AppIcons.foodIcon,
      "transportation": AppIcons.transportIcon,
      "utilities": AppIcons.utilitiesIcon,
      "health_medical": AppIcons.health2dIcon,
      "entertainment": AppIcons.entertainment,
      "shopping": AppIcons.shopingBag,
      "education": AppIcons.educationIcon,
      "travel": AppIcons.transpost,
      "rent_mortgage": AppIcons.home,
      "personal_care": AppIcons.profileIcon,
      "insurance": AppIcons.insuranceIcon,
      "transfer": AppIcons.transferIcon,
      "other": AppIcons.otherIcon,
    };
    final key = categoryName.toLowerCase();
    return categoryIconMap[key] ?? AppIcons.otherIcon;
  }

  String _getTitleForCategory(String categoryName) {
    final Map<String, String> categoryTitleMap = {
      "food_dining": 'Food & Dining',
      "transportation": 'Transportation',
      "utilities": 'Utilities',
      "health_medical": 'Health & Medical',
      "entertainment": 'Entertainment',
      "shopping": 'Shopping',
      "education": 'Education',
      "travel": 'Travel',
      "rent_mortgage": 'Housing / Rent / Mortgage',
      "personal_care": 'Personal Care',
      "insurance": 'Insurance',
      "transfer": 'Transfer',
      "other": 'Other',
    };
    final key = categoryName.toLowerCase();
    return categoryTitleMap[key] ?? 'Empty';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyles.bgColor,
        body: CustomMaterialIndicator(
          onRefresh: () async {
            print("[HomeScreen - onRefresh] Refresh initiated by user.");
            // It's generally better if isLoading flags are managed within the controllers
            // themselves, tied to their specific data fetching operations.
            // For example, homeController.isLoading.value could be set true/false
            // within getUserPresentMonthData.

            try {
              print(
                "[HomeScreen - onRefresh] Starting homeController.getUserPresentMonthData()...",
              );
              // Ensure getUserPresentMonthData is an async function that returns a Future
              // and correctly updates Rx variables within HomeController.
              await homeController.getUserPresentMonthData();
              print(
                "[HomeScreen - onRefresh] Finished homeController.getUserPresentMonthData().",
              );

              print(
                "[HomeScreen - onRefresh] Starting controller.getReportCategory()...",
              ); // 'controller' is AnalyzeController
              // Ensure getReportCategory is an async function that returns a Future
              // and correctly updates Rx variables within AnalyzeController.
              await controller.getReportCategory();
              print(
                "[HomeScreen - onRefresh] Finished controller.getReportCategory().",
              );

              // If the UI isn't updating after these calls, the primary suspects are:
              // 1. The controller methods are not actually fetching new data.
              // 2. New data is fetched, but Rx variables (e.g., homeController.availableMoney, controller.expenseCategoryList)
              //    are not being updated correctly (e.g., using .value = newValue, or list.assignAll(newListData)).
              // 3. There are silent errors occurring within these controller methods.

              print(
                "[HomeScreen - onRefresh] All data fetching tasks complete.",
              );
            } catch (error, stackTrace) {
              print("[HomeScreen - onRefresh] Error during refresh: $error");
              print("[HomeScreen - onRefresh] StackTrace: $stackTrace");
              // Optionally, show a user-facing error message
              if (Get.isSnackbarOpen == false) {
                // Prevent multiple snackbars if already open
                Get.snackbar(
                  "Refresh Error",
                  "Could not update data. Please try again.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            } finally {
              // Any UI cleanup or state reset if needed, though CustomMaterialIndicator handles its own state.
              print("[HomeScreen - onRefresh] Refresh process finalized.");
            }
            // The CustomMaterialIndicator automatically hides when this Future completes.
            // No explicit "stop" signal is usually needed if using async/await correctly.
          },
          indicatorBuilder: (context, indicatorController) {
            // Renamed 'controller' to 'indicatorController' to avoid confusion
            // indicatorController is of type IndicatorController from the package
            return const CupertinoActivityIndicator();
          },
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Ensure it's always scrollable for pull-to-refresh
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 15.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customAppBar(),
                      SizedBox(height: 26.h),
                      InkWell(
                        onTap: () => Get.to(() => AccountsScreen()),
                        child: headerBodySection(homeController),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                InkWell(
                  onTap:
                      () => Get.to(
                        () => ExpenseDetailsScreen(
                          totalCost: homeController.espenseBalancePer.value,
                          availableBalance:
                              homeController.availableBalancePer.value,
                        ),
                      ),
                  child: financialHealth(homeController),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 36,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Ai',
                                style:
                                    AppStyles.mediumText?.copyWith(
                                      color: AppStyles.primaryColor,
                                      fontSize: 20.sp,
                                    ) ??
                                    TextStyle(
                                      color: AppStyles.primaryColor,
                                      fontSize: 20.sp,
                                    ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Financial Alert!',
                                style:
                                    AppStyles.mediumText?.copyWith(
                                      color: const Color.fromARGB(
                                        255,
                                        221,
                                        202,
                                        202,
                                      ),
                                      fontSize: 20.sp,
                                    ) ??
                                    TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        221,
                                        202,
                                        202,
                                      ),
                                      fontSize: 20.sp,
                                    ),
                              ),
                            ],
                          ),
                          Obx(() {
                            final totalIncome =
                                homeController.totalIncome.value;
                            final totalExpense =
                                homeController.totalExpense.value;
                            String percentageText;

                            if (homeController.isLoading.value &&
                                (totalIncome == 0 && totalExpense == 0)) {
                              // Show loading if still loading initial data perhaps
                              percentageText = "...";
                            } else if (totalIncome > 0) {
                              final percentage =
                                  (totalExpense / totalIncome) * 100;
                              percentageText =
                                  '${percentage.toStringAsFixed(0)}%';
                            } else if (totalExpense > 0 && totalIncome <= 0) {
                              percentageText = "N/A";
                            } else {
                              percentageText = "0%";
                            }

                            return Text.rich(
                              TextSpan(
                                text: "You're Spending ",
                                style:
                                    AppStyles.smallText?.copyWith(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ) ??
                                    TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: percentageText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' of your income',
                                    style:
                                        AppStyles.smallText?.copyWith(
                                          color: Colors.grey,
                                          fontSize: 12.sp,
                                        ) ??
                                        TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.sp,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: 20.h),
                          Obx(() {
                            if (controller.isLoading.value &&
                                controller.expenseCategoryList.isEmpty) {
                              // Assuming AnalyzeController has isLoadingReport
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                            }
                            if (controller.expenseCategoryList.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Text(
                                    "No expense categories to display.",
                                    style:
                                        AppStyles.smallText?.copyWith(
                                          color: Colors.grey,
                                        ) ??
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children:
                                  controller.expenseCategoryList.map((expense) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 5.h),
                                      child: financial_item(
                                        iconPath: _getIconForCategory(
                                          expense.category,
                                        ),
                                        title: _getTitleForCategory(
                                          expense.category,
                                        ),
                                        percents: expense.percent,
                                      ),
                                    );
                                  }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget financial_item({
    required String iconPath,
    required String title,
    required int percents,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppStyles.lightGreyColor ?? Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Row(
          children: [
            Container(
              height: 44.h,
              width: 44.w,
              decoration: BoxDecoration(
                color: AppStyles.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style:
                    AppStyles.smallText?.copyWith(
                      color: Colors.black,
                      fontSize: 14.sp,
                    ) ??
                    TextStyle(color: Colors.black, fontSize: 14.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            CircularPercentIndicator(
              animation: true,
              radius: 25.0,
              lineWidth: 8.0,
              percent: (percents / 100.0).clamp(
                0.0,
                1.0,
              ), // Ensure percent is between 0.0 and 1.0
              center: Text(
                "$percents%",
                style:
                    AppStyles.smallText?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 12.sp,
                    ) ??
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),
              ),
              progressColor: AppStyles.primaryColor,
              backgroundColor: AppStyles.lightGreyColor ?? Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget financialHealth(HomeController homeController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Obx(() {
        // Check if still loading and data might be stale or zero
        if (homeController.isLoading.value &&
            (homeController.espenseBalancePer.value == 0 &&
                homeController.availableBalancePer.value == 0)) {
          return Container(
            // Placeholder for loading state
            width: double.infinity,
            height: 180.h, // Adjust height to match the loaded content
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  blurRadius: 36,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 36,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Removed Row as it was redundant for a single Text
                      'Your Financial Health',
                      style:
                          AppStyles.mediumText?.copyWith(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ) ??
                          TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 16.w,
                                    height: 16.h,
                                    decoration: BoxDecoration(
                                      color:
                                          AppStyles.orangeColor ??
                                          const Color(
                                            0xffF38042,
                                          ), // Use AppStyles.orangeColor if defined
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: Text(
                                      'Total cost in month',
                                      style:
                                          AppStyles.smallText?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                          ) ??
                                          TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Container(
                                    width: 16.w,
                                    height: 16.h,
                                    decoration: BoxDecoration(
                                      color: AppStyles.primaryColor,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: Text(
                                      'Save in month',
                                      style:
                                          AppStyles.smallText?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                          ) ??
                                          TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                'Use AI to cut non-essentials and reduce fixed costs.',
                                style:
                                    AppStyles.smallText?.copyWith(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ) ??
                                    TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150.w,
                          height: 150.h,
                          child:
                              (!mounted ||
                                      homeController.espenseBalancePer.value ==
                                              0 &&
                                          homeController
                                                  .availableBalancePer
                                                  .value ==
                                              0 &&
                                          !homeController.isLoading.value)
                                  ? Center(
                                    child: Text(
                                      "No data",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                  : SfCircularChart(
                                    series: <CircularSeries>[
                                      PieSeries<ChartData, String>(
                                        dataSource: <ChartData>[
                                          ChartData(
                                            'Expense',
                                            homeController
                                                .espenseBalancePer
                                                .value,
                                          ),
                                          ChartData(
                                            'Available',
                                            homeController
                                                .availableBalancePer
                                                .value,
                                          ),
                                        ],
                                        pointColorMapper: (ChartData data, _) {
                                          if (data.category == 'Expense') {
                                            return AppStyles.orangeColor ??
                                                const Color(0xffF38042);
                                          } else {
                                            return AppStyles.primaryColor;
                                          }
                                        },
                                        xValueMapper:
                                            (ChartData data, _) =>
                                                data.category,
                                        yValueMapper:
                                            (ChartData data, _) => data.amount,
                                        dataLabelMapper:
                                            (ChartData data, _) =>
                                                '${data.amount.toStringAsFixed(0)}%',
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                              isVisible: true,
                                              textStyle: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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
        );
      }),
    );
  }

  Row customAppBar() {
    return Row(
      children: [
        SizedBox(
          width: 65.w,
          height: 32.h,
          child: Image.asset(
            AppIcons.appBrandLogo,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error_outline, color: Colors.red);
            },
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () => Get.to(() => NotificationScreen()),
          child: SvgPicture.asset(
            AppIcons.bellIcon,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            placeholderBuilder:
                (context) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoActivityIndicator(),
                ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.profile);
          },
          child: SvgPicture.asset(
            AppIcons.profileIcon,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            placeholderBuilder:
                (context) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoActivityIndicator(),
                ),
          ),
        ),
        // SizedBox(width: 10.w), // This last SizedBox might be unnecessary unless there's content after it.
      ],
    );
  }

  Widget courseSection(HomeController homeController) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        if (homeController.isLoading.value &&
            homeController.coursesModel.isEmpty) {
          return SizedBox(
            height: 100.h, // Example height for course items
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }
        if (homeController.coursesModel.isEmpty) {
          return SizedBox(
            height: 100.h,
            child: Center(
              child: Text(
                "No courses available.",
                style: AppStyles.smallText?.copyWith(color: Colors.grey),
              ),
            ),
          );
        }
        return Row(
          children: List.generate(homeController.coursesModel.length, (index) {
            return CoursesItem(course: homeController.coursesModel[index]);
          }),
        );
      }),
    );
  }

  Widget headerBodySection(HomeController homeController) {
    return Obx(() {
      // Show a shimmer or loading placeholder if data isn't ready
      if (homeController.isLoading.value &&
          homeController.availableMoney.value == 0) {
        return Container(
          // Placeholder for loading state
          width: double.infinity,
          height: 250.h, // Adjust height to match the loaded content
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                blurRadius: 36,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(child: CupertinoActivityIndicator()),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 36,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  gradient: LinearGradient(
                    colors: [
                      AppStyles.primaryColor ?? Colors.blue,
                      AppStyles.primarySecondColor ?? Colors.lightBlue,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'USD',
                        style:
                            AppStyles.smallText?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ) ??
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Available Balance',
                        style:
                            AppStyles.smallText?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ) ??
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '\$${homeController.availableMoney.value.toStringAsFixed(2)}',
                        style:
                            AppStyles.smallText?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 40.sp,
                            ) ??
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 40.sp,
                            ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Today (-\$${homeController.todayExpense.value.toStringAsFixed(2)})',
                        style:
                            AppStyles.smallText?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ) ??
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 60.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Income',
                            style:
                                AppStyles.smallText?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ) ??
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            '\$${homeController.totalIncome.value.toStringAsFixed(2)}',
                            style:
                                AppStyles.smallText?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ) ??
                                TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppStyles.lightGreyColor ?? Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Expense',
                            style:
                                AppStyles.smallText?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ) ??
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            '\$${homeController.totalExpense.value.toStringAsFixed(2)}',
                            style:
                                AppStyles.smallText?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ) ??
                                TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
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
    });
  }
}

class ChartData {
  ChartData(this.category, this.amount);
  final String category;
  final double amount;
}
