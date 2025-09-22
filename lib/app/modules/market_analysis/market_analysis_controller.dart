import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:gourmet_pro_app/app/routes/app_routes.dart';
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
}

class MarketAnalysisController extends GetxController {
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

  Future<void> fetchRestaurants() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    final List<Restaurant> dummyRestaurants = [
      Restaurant(id: '1', name: 'لا تراتوريا', cuisine: 'إيطالي', rating: 4.8, imageUrl: 'https://placehold.co/100x100/111/FFF?text=La+Trattoria', hasOffer: true, coordinates: LatLng(34.0522, -118.2437)),
      Restaurant(id: '2', name: 'سوشي زين', cuisine: 'ياباني', rating: 4.6, imageUrl: 'https://placehold.co/100x100/222/FFF?text=Sushi+Zen', coordinates: LatLng(34.0550, -118.2450)),
      Restaurant(id: '3', name: 'البيت الشامي', cuisine: 'شامي', rating: 4.9, imageUrl: 'https://placehold.co/100x100/333/FFF?text=Shami', hasOffer: false, coordinates: LatLng(34.0500, -118.2480)),
      Restaurant(id: '4', name: 'برجر فاكتوري', cuisine: 'أمريكي', rating: 4.5, imageUrl: 'https://placehold.co/100x100/444/FFF?text=Burger', hasOffer: true, coordinates: LatLng(34.0580, -118.2500)),
    ];
    restaurants.assignAll(dummyRestaurants);
    _generateMarkers();
    isLoading.value = false;
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

