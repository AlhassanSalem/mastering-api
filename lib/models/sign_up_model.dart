import 'package:mastering_api/core/api/end_points.dart';

class SignUpModel{
  final String message;
  SignUpModel({required this.message});

  factory SignUpModel.fromJson(Map<String, dynamic> jsonData){
    return SignUpModel(message: jsonData[ApiKeys.message]);
  }
}