import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';

// A simple local model to represent restaurant data for the list view.
// In a real app, this would be in the /data/models folder and generated from JSON.
class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final String imageUrl;
  final bool hasOffer;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.imageUrl,
    this.hasOffer = false,
  });
}

class MarketAnalysisController extends GetxController {
  // --- STATE VARIABLES ---

  // List of filters for the UI
  final List<String> filters = const [
    'الكل',
    'الأعلى تقييماً',
    'عروض خاصة',
    'إيطالي',
    'آسيوي',
  ];

  // Reactive variable to track the currently selected filter index
  final selectedFilterIndex = 0.obs;

  // Reactive list to hold restaurant data
  final RxList<Restaurant> restaurants = <Restaurant>[].obs;

  // Loading state
  final isLoading = false.obs;

  // --- LIFECYCLE METHODS ---

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants(); // Fetch initial data when the controller is initialized
  }

  // --- PUBLIC METHODS ---

  /// Changes the selected filter and, in a real app, would refetch data.
  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    // In a real-world scenario, you would call an API here:
    // fetchRestaurants(filter: filters[index]);
  }

  /// Navigates to the restaurant details screen.
  void goToRestaurantDetails(Restaurant restaurant) {
    // We can pass the restaurant object as an argument to the next screen
    Get.toNamed(Routes.restaurantDetails, arguments: restaurant);
  }

  /// Fetches restaurant data. Currently uses dummy data.
  void fetchRestaurants({String? filter}) async {
    try {
      isLoading.value = true;
      // Simulate a network delay
      await Future.delayed(const Duration(seconds: 1));

      // Dummy data that matches the UI design
      final List<Restaurant> dummyRestaurants = [
        Restaurant(
          id: '1',
          name: 'لا تراتوريا',
          cuisine: 'إيطالي',
          rating: 4.8,
          imageUrl: 'https://placehold.co/100x100/111/FFF?text=La+Trattoria',
          hasOffer: true,
        ),
        Restaurant(
          id: '2',
          name: 'سوشي زين',
          cuisine: 'ياباني',
          rating: 4.6,
          imageUrl: 'https://placehold.co/100x100/222/FFF?text=Sushi+Zen',
        ),
        Restaurant(
          id: '3',
          name: 'البيت الشامي',
          cuisine: 'شامي',
          rating: 4.9,
          imageUrl: 'https://placehold.co/100x100/333/FFF?text=Shami',
          hasOffer: false,
        ),
        Restaurant(
          id: '4',
          name: 'برجر فاكتوري',
          cuisine: 'أمريكي',
          rating: 4.5,
          imageUrl: 'https://placehold.co/100x100/444/FFF?text=Burger',
          hasOffer: true,
        ),
      ];
      restaurants.assignAll(dummyRestaurants);
    } finally {
      isLoading.value = false;
    }
  }
}
