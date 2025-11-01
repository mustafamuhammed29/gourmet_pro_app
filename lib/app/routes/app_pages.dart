import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/review_responder/review_responder_binding.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/review_responder/review_responder_screen.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/social_post_generator/social_post_generator_binding.dart';
import 'package:gourmet_pro_app/app/modules/ai_features/social_post_generator/social_post_generator_screen.dart';
import 'package:gourmet_pro_app/app/modules/auth/auth_binding.dart';
import 'package:gourmet_pro_app/app/modules/auth/screens/login_screen.dart';
import 'package:gourmet_pro_app/app/modules/auth/screens/pending_approval_screen.dart';
import 'package:gourmet_pro_app/app/modules/auth/screens/register_screen.dart';
import 'package:gourmet_pro_app/app/modules/chat/chat_binding.dart';
import 'package:gourmet_pro_app/app/modules/chat/chat_screen.dart';
import 'package:gourmet_pro_app/app/modules/chef_corner/chef_corner_binding.dart';
import 'package:gourmet_pro_app/app/modules/chef_corner/chef_corner_screen.dart';
import 'package:gourmet_pro_app/app/modules/main_wrapper/main_wrapper_binding.dart';
import 'package:gourmet_pro_app/app/modules/main_wrapper/main_wrapper_screen.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/market_analysis_binding.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/screens/discover_map_screen.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/screens/restaurant_details_screen.dart';
import 'package:gourmet_pro_app/app/modules/other_screens/notifications_screen.dart';
import 'package:gourmet_pro_app/app/modules/other_screens/staff_management_screen.dart';
import 'package:gourmet_pro_app/app/modules/product_management/product_management_binding.dart';
import 'package:gourmet_pro_app/app/modules/product_management/screens/add_edit_dish_screen.dart';
import 'package:gourmet_pro_app/app/modules/product_management/screens/manage_menu_screen.dart';
import 'package:gourmet_pro_app/app/modules/profile/profile_binding.dart';
import 'package:gourmet_pro_app/app/modules/profile/screens/edit_profile_screen.dart';
import 'package:gourmet_pro_app/app/modules/profile/screens/profile_screen.dart';
import 'package:gourmet_pro_app/app/modules/promo_tools/promo_tools_binding.dart';
import 'package:gourmet_pro_app/app/modules/services/services_binding.dart';
import 'package:gourmet_pro_app/app/modules/services/services_screen.dart';
import 'package:gourmet_pro_app/app/modules/splash/splash_binding.dart';
import 'package:gourmet_pro_app/app/modules/splash/splash_screen.dart';
import 'package:gourmet_pro_app/app/modules/orders/orders_binding.dart';
import 'package:gourmet_pro_app/app/modules/orders/orders_screen.dart';

import '../modules/promo_tools/digital_menu_screen.dart';
import '../modules/promo_tools/promo_tools_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.splash;

  static final routes = [
    GetPage(name: Routes.splash, page: () => const SplashScreen(), binding: SplashBinding()),
    GetPage(name: Routes.login, page: () => const LoginScreen(), binding: AuthBinding()),
    GetPage(name: Routes.register, page: () => const RegisterScreen(), binding: AuthBinding()),
    GetPage(name: Routes.pendingApproval, page: () => const PendingApprovalScreen()),
    GetPage(name: Routes.mainWrapper, page: () => const MainWrapperScreen(), binding: MainWrapperBinding()),
    GetPage(name: Routes.promoTools, page: () => const PromoToolsScreen(), binding: PromoToolsBinding()),
    GetPage(name: Routes.digitalMenu, page: () => const DigitalMenuScreen(), binding: PromoToolsBinding()),
    GetPage(name: Routes.editProfile, page: () => const EditProfileScreen(), binding: ProfileBinding()),
    GetPage(name: Routes.profile, page: () => const ProfileScreen(), binding: ProfileBinding()),
    GetPage(name: Routes.reviewResponder, page: () => const ReviewResponderScreen(), binding: ReviewResponderBinding()),
    GetPage(name: Routes.socialPostGenerator, page: () => const SocialPostGeneratorScreen(), binding: SocialPostGeneratorBinding()),
    GetPage(name: Routes.manageMenu, page: () => const ManageMenuScreen(), binding: ProductManagementBinding()),
    GetPage(name: Routes.addEditDish, page: () => const AddEditDishScreen(), binding: ProductManagementBinding()),
    GetPage(name: Routes.chefCorner, page: () => const ChefCornerScreen(), binding: ChefCornerBinding()),
    GetPage(name: Routes.discoverMap, page: () => const DiscoverMapScreen(), binding: MarketAnalysisBinding()),
    GetPage(name: Routes.restaurantDetails, page: () => const RestaurantDetailsScreen(), binding: MarketAnalysisBinding()),
    GetPage(name: Routes.notifications, page: () => const NotificationsScreen()),
    GetPage(name: Routes.staffManagement, page: () => const StaffManagementScreen()),
    GetPage(name: Routes.services, page: () => const ServicesScreen(), binding: ServicesBinding()),
    GetPage(name: Routes.chat, page: () => const ChatScreen(), binding: ChatBinding()),
    GetPage(name: Routes.orders, page: () => const OrdersScreen(), binding: OrdersBinding()),
  ];
}

