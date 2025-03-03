import 'package:mastering_api/core/api/end_points.dart';

class UserModel {
  final String profilePic;
  final String name;
  final String email;
  final String phone;
  final Map<String, dynamic> address;

  UserModel({
    required this.profilePic,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      profilePic: jsonData['user'][ApiKeys.profilePic],
      name: jsonData['user'][ApiKeys.name],
      email: jsonData['user'][ApiKeys.email],
      phone: jsonData['user'][ApiKeys.phone],
      address: jsonData['user'][ApiKeys.location],
    );
  }
}
