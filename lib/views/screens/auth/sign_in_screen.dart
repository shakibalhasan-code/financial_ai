import 'package:financial_ai_mobile/controller/auth_controller.dart';
import 'package:financial_ai_mobile/core/models/user_model.dart';
import 'package:financial_ai_mobile/core/utils/app_icons.dart';
import 'package:financial_ai_mobile/core/utils/app_routes.dart';
import 'package:financial_ai_mobile/core/utils/app_styles.dart';
import 'package:financial_ai_mobile/views/glob_widgets/custom_text_feild.dart';
import 'package:financial_ai_mobile/views/glob_widgets/our_gob_text_button.dart';
import 'package:financial_ai_mobile/views/screens/auth/sign_up_screen.dart';
import 'package:financial_ai_mobile/views/screens/on_boarding/user_info/user_chose_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  // Key for the Form widget
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
                Text('Login to your Account', style: AppStyles.largeText),
                SizedBox(height: 10.h),
                Form(
                  key: _formKey, // Assign the key to the Form
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    Text(
                      'Remember Me',
                      style: AppStyles.smallText.copyWith(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.forget),
                      child: Text(
                        'Forget Password?',
                        style: AppStyles.smallText.copyWith(
                          color: AppStyles.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
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
                        final user = {
                          'email': authController.emailController.text,
                          'password': authController.passController.text,
                        };
                        await authController.signInUser(user);
                      } else
                        return;
                    },
                    child: Obx(() {
                      return authController.isLoading.value
                          ? const CupertinoActivityIndicator()
                          : Text(
                            'Login',
                            style: AppStyles.smallText.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          );
                    }),
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have a account?',
                      style: AppStyles.smallText.copyWith(
                        color: AppStyles.greyColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    InkWell(
                      onTap: () => Get.to(SignUpScreen()),
                      child: Text(
                        'SignUp',
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
