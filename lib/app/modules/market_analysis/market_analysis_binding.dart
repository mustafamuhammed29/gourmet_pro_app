import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/market_analysis_controller.dart';

class MarketAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketAnalysisController>(
          () => MarketAnalysisController(),
    );
  }
}
