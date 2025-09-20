import 'dart:convert';

// دالة مساعدة لتحويل قائمة من JSON إلى قائمة من ProductModel
List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

// دالة مساعدة لتحويل ProductModel إلى JSON (مفيدة عند إرسال البيانات)
String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imageUrl; // يمكن أن تكون الصورة اختيارية (nullable)
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor لإنشاء نسخة من ProductModel من خلال JSON map
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    // تحويل السعر بأمان إلى double، حتى لو جاء كنص
    price: double.tryParse(json["price"].toString()) ?? 0.0,
    category: json["category"],
    imageUrl: json["imageUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  // دالة لتحويل الكائن إلى JSON map (مفيدة عند الإرسال للخادم)
  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "category": category,
    "imageUrl": imageUrl,
  };
}
