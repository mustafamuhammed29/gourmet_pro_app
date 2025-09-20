import 'dart:convert';

// دالة مساعدة لتحويل JSON إلى كائن UserModel
UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  final String id;
  final String email;
  final String role;
  // يمكننا إضافة نموذج للمطعم لاحقاً إذا احتجنا تفاصيله
  // final RestaurantModel restaurant;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor لإنشاء نسخة من UserModel من خلال JSON map
  // هذا النموذج سيفيدنا إذا قمنا بإنشاء مسار API يجلب بيانات المستخدم الكاملة
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    email: json["email"],
    role: json["role"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );
}
