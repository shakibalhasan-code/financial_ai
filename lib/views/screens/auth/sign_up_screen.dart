import 'package:financial_ai_mobile/controller/auth_controller.dart';
import 'package:financial_ai_mobile/core/models/user_model.dart';
import 'package:financial_ai_mobile/core/utils/app_icons.dart';
import 'package:financial_ai_mobile/core/utils/app_routes.dart';
import 'package:financial_ai_mobile/core/utils/app_styles.dart';
import 'package:financial_ai_mobile/core/utils/global_base.dart';
import 'package:financial_ai_mobile/views/glob_widgets/custom_text_feild.dart';
import 'package:financial_ai_mobile/views/glob_widgets/our_gob_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Create your Account', style: AppStyles.largeText),
                SizedBox(height: 10.h),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name', style: AppStyles.mediumText),
                      SizedBox(height: 5.h),
                      CustomTextFeild(
                        isObsecure: false,
                        hintText: 'Enter your name',
                        type: TextInputType.text,
                        controller: authController.nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),

                      SizedBox(
                        width: Get.width,
                        height: context.height * 0.07,
                        child: Obx(() {
                          return DropdownMenu<String>(
                            initialSelection:
                                authController.selectedCountry.value.isNotEmpty
                                    ? authController.selectedCountry.value
                                    : 'NONE',
                            dropdownMenuEntries:
                                authController.countries
                                    .map(
                                      (country) => DropdownMenuEntry<String>(
                                        value: country['value'],
                                        label: country['label'],
                                      ),
                                    )
                                    .toList(),
                            onSelected: (value) {
                              authController.selectedCountry.value =
                                  value ?? 'NONE';
                              printInfo(info: 'Selected country: ${value}');
                            },
                          );
                        }),
                      ),
                      SizedBox(height: 10.h),
                      Text('Email', style: AppStyles.mediumText),
                      SizedBox(height: 5.h),
                      CustomTextFeild(
                        isObsecure: false,
                        hintText: 'Enter your email',
                        type: TextInputType.emailAddress,
                        controller: authController.emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      Text('Password', style: AppStyles.mediumText),
                      SizedBox(height: 5.h),
                      CustomTextFeild(
                        hintText: 'Enter your password',
                        type: TextInputType.text,
                        isObsecure: true,
                        controller: authController.passController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Checkbox(
                        value: authController.isChecked.value,
                        onChanged: (v) {
                          authController.isChecked.value = v!;
                        },
                      );
                    }),
                    Expanded(
                      child: Text(
                        'I agree to the processing of Personal data',
                        style: AppStyles.smallText.copyWith(
                          color: AppStyles.greyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (authController.isChecked.value) {
                          if (authController.selectedCountry.value == 'NONE') {
                            GlobalBase.showToast(
                              'Please choose a country',
                              true,
                            );
                            return;
                          }

                          final user = UserModel(
                            country: authController.selectedCountry.value,
                            name: authController.nameController.text,
                            email: authController.emailController.text,
                            password: authController.passController.text,
                          );

                          await authController.createUser(user);
                        } else {
                          GlobalBase.showToast('Please check policy', true);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        return authController.isLoading.value
                            ? Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              'Sign Up',
                              style: AppStyles.smallText.copyWith(
                                color: Colors.white,
                              ),
                            );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppStyles.smallText.copyWith(
                        color: AppStyles.greyColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    InkWell(
                      onTap: () => Get.toNamed(AppRoutes.signIn),
                      child: Text(
                        'SignIn',
                        style: AppStyles.smallText.copyWith(
                          color: AppStyles.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
