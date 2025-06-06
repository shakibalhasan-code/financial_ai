import 'package:financial_ai_mobile/views/screens/auth/forget_pass_screen.dart';
import 'package:financial_ai_mobile/views/screens/auth/sign_in_screen.dart';
import 'package:financial_ai_mobile/views/screens/auth/sign_up_screen.dart';
import 'package:financial_ai_mobile/views/screens/on_boarding/bindings/splash_bindings.dart';
import 'package:financial_ai_mobile/views/screens/on_boarding/on_board_screen.dart';
import 'package:financial_ai_mobile/views/screens/on_boarding/splash_screen.dart';
import 'package:financial_ai_mobile/views/screens/profie/bank_screen.dart';
import 'package:financial_ai_mobile/views/screens/profie/bindings/profile_binding.dart';
import 'package:financial_ai_mobile/views/screens/profie/edit_profile_screen.dart';
import 'package:financial_ai_mobile/views/screens/profie/privacy_policy_screen.dart';
import 'package:financial_ai_mobile/views/screens/profie/profile_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splash = '/splash';

  static String onBoarding = '/onBoarding';
  static String signUp = '/signUp';
  static String signIn = '/signIn';
  static String forget = '/forget';
  static String bankScreen = '/bankScreen';

  // profile
  static String profile = '/profile';
  static String editProfile = '/edit_profile';
  static String privacyPolicy = '/privacy_policy';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      binding: SplashBindings(),
    ),
    GetPage(name: onBoarding, page: () => OnBoarding()),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forget, page: () => ForgetPassScreen()),

    // profile
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfileScreen()),
    GetPage(name: privacyPolicy, page: () => PrivacyPolicyScreen()),
    GetPage(
      name: AppRoutes.bankScreen,
      page: () => BankScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
