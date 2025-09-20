import 'package:get/get.dart';

class MainWrapperController extends GetxController {
  // A reactive variable to hold the index of the currently selected tab.
  // We use .obs to make it observable by the UI.
  // It starts at 0, which corresponds to the Dashboard screen.
  var selectedIndex = 0.obs;

  /// Changes the current page by updating the selected index.
  /// The UI, which is listening to [selectedIndex], will automatically update.
  ///
  /// [index] is the new index to switch to.
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}

