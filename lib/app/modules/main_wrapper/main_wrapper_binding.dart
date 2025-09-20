import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/chat/chat_controller.dart';
import 'package:gourmet_pro_app/app/modules/chef_corner/chef_corner_controller.dart';
import 'package:gourmet_pro_app/app/modules/dashboard/dashboard_controller.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/market_analysis_controller.dart';
import 'package:gourmet_pro_app/app/modules/profile/profile_controller.dart';
import 'package:gourmet_pro_app/app/modules/main_wrapper/main_wrapper_controller.dart';

class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    // We use fenix: true to ensure that controllers are re-created if needed
    // after being disposed when switching tabs. This is the definitive solution.
    Get.lazyPut<MainWrapperController>(() => MainWrapperController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<ChefCornerController>(() => ChefCornerController(), fenix: true);
    Get.lazyPut<MarketAnalysisController>(() => MarketAnalysisController(), fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}

