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
    final user = jsonData['user'];
    return UserModel(
      profilePic: user[ApiKeys.profilePic],
      name: user[ApiKeys.name],
      email: user[ApiKeys.email],
      phone: user[ApiKeys.phone],
      address: user[ApiKeys.location],
    );
  }
}
