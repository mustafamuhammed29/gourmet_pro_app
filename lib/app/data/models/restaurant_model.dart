class RestaurantModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final String phone;
  final String cuisineType;
  // Add other fields from your backend entity as needed

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.phone,
    required this.cuisineType,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      cuisineType: json['cuisineType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'phone': phone,
      'cuisineType': cuisineType,
    };
  }
}
