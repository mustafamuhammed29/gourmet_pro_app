import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/data/providers/api_provider.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
import 'package:gourmet_pro_app/app/shared/widgets/custom_snackbar.dart';
import 'package:latlong2/latlong.dart';

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final String imageUrl;
  final bool hasOffer;
  final LatLng coordinates;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.imageUrl,
    required this.coordinates,
    this.hasOffer = false,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'].toString(),
      name: json['name'] ?? 'مطعم',
      cuisine: json['cuisineType'] ?? 'غير محدد',
      rating: 4.5,
      imageUrl: json['logoUrl'] ?? 'https://placehold.co/100x100/333/FFF?text=Restaurant',
      coordinates: LatLng(
        json['latitude']?.toDouble() ?? 34.0522,
        json['longitude']?.toDouble() ?? -118.2437,
      ),
      hasOffer: false,
    );
  }
}

class MarketAnalysisController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final MapController mapController = MapController();

  final List<String> filters = const [
    'الكل',
    'الأعلى تقييماً',
    'عروض خاصة',
    'إيطالي',
    'آسيوي',
    'شامي',
    'أمريكي',
  ];

  final selectedFilterIndex = 0.obs;
  final RxList<Restaurant> restaurants = <Restaurant>[].obs;
  final RxList<Marker> markers = <Marker>[].obs;
  final isLoading = false.obs;

  // New computed property to easily get the name of the selected filter.
  String get selectedFilterName => filters[selectedFilterIndex.value];

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    // In a real app, you would refetch data here.
  }

  void goToRestaurantDetails(Restaurant restaurant) {
    Get.toNamed(Routes.restaurantDetails, arguments: restaurant);
  }

  void focusOnRestaurant(Restaurant restaurant) {
    mapController.move(restaurant.coordinates, 15.0);
  }

  /// ✨ تم تحديث الدالة لجلب المطاعم من الخادم
  Future<void> fetchRestaurants() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getAllRestaurants();

      if (response.isOk && response.body is List) {
        final List<dynamic> restaurantsJson = response.body;
        final restaurantsList = restaurantsJson
            .map((json) => Restaurant.fromJson(json))
            .toList();
        restaurants.assignAll(restaurantsList);
        _generateMarkers();
      } else {
        throw Exception('Failed to fetch restaurants');
      }
    } catch (e) {
      CustomSnackbar.showError('فشل في جلب بيانات المطاعم.');
    } finally {
      isLoading.value = false;
    }
  }

  void _generateMarkers() {
    final newMarkers = restaurants.map((restaurant) {
      return Marker(
        point: restaurant.coordinates,
        child: GestureDetector(
          onTap: () => goToRestaurantDetails(restaurant),
          child: const Icon(Icons.location_pin, color: Colors.redAccent, size: 40.0),
        ),
      );
    }).toList();
    markers.assignAll(newMarkers);
  }
}

