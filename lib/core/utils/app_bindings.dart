import 'package:financial_ai_mobile/controller/add_data_controller/add_data_controller.dart';
import 'package:financial_ai_mobile/controller/auth_controller.dart';
import 'package:financial_ai_mobile/controller/home/accounts_controller.dart';
import 'package:financial_ai_mobile/controller/tab_controller.dart';
import 'package:financial_ai_mobile/controller/welcome_controller.dart';
import 'package:get/get.dart';

class AppBindings {
  static Bindings bindings = BindingsBuilder(() {
    Get.lazyPut(() => WelcomeController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => MyTabController(), fenix: true);
    Get.lazyPut(() => AccountsController, fenix: true);
    Get.lazyPut(() => AddDataController(), fenix: true);
  });
}
