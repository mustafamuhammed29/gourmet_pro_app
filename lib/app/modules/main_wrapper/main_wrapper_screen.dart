import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/modules/chat/chat_screen.dart';
import 'package:gourmet_pro_app/app/modules/chef_corner/chef_corner_screen.dart';
import 'package:gourmet_pro_app/app/modules/dashboard/dashboard_screen.dart';
import 'package:gourmet_pro_app/app/modules/market_analysis/screens/discover_map_screen.dart';
import 'package:gourmet_pro_app/app/modules/profile/screens/profile_screen.dart';
import 'package:gourmet_pro_app/app/shared/theme/app_colors.dart';
import 'main_wrapper_controller.dart';

class MainWrapperScreen extends GetView<MainWrapperController> {
  const MainWrapperScreen({super.key});

  // List of the main screens that will be displayed in the body.
  final List<Widget> screens = const [
    DashboardScreen(),
    ChefCornerScreen(),
    DiscoverMapScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      // The body uses an Obx widget to reactively listen to changes
      // in the controller's selectedIndex.
      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
      ),
      // The bottom navigation bar also listens to changes to update
      // which tab is currently active.
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          backgroundColor: AppColors.bgSecondary,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'ركن الشيف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'اكتشف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'الدردشة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'ملفي',
            ),
          ],
        ),
      ),
    );
  }
}

