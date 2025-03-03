import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mastering_api/cache/cache_helper.dart';
import 'package:mastering_api/core/api/api_consumer.dart';
import 'package:mastering_api/core/api/end_points.dart';
import 'package:mastering_api/core/errors/exception.dart';
import 'package:mastering_api/core/functions/upload_image_to_api.dart';
import 'package:mastering_api/models/sign_in_model.dart';
import 'package:mastering_api/models/sign_up_model.dart';
import 'package:mastering_api/models/user_model.dart';

class UserRepository {
  final ApiConsumer api;

  UserRepository({required this.api});

  Future<Either<String, SignInModel>> signIn(
      {required String email, required String password}) async {
    try {
      final response = await api.post(
        EndPoints.signIn,
        data: {
          ApiKeys.email: email,
          ApiKeys.password: password,
        },
      );
      final user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user.token);
      CacheHelper().saveData(key: ApiKeys.token, value: user.token);
      CacheHelper().saveData(key: ApiKeys.id, value: decodedToken[ApiKeys.id]);
      return right(user);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, SignUpModel>>signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String confirmPassword,
    required XFile profilePic,
  }) async {
    try {
      final response =
          await api.post(EndPoints.signUp, isFormData: true, data: {
        ApiKeys.name: name,
        ApiKeys.email: email,
        ApiKeys.password: password,
        ApiKeys.confirmPassword: confirmPassword,
        ApiKeys.phone: phone,
        ApiKeys.profilePic: uploadImageToApi(profilePic!),
        ApiKeys.location:
            '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}'
      });
      final signUpModel = SignUpModel.fromJson(response);
      return Right(signUpModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }


  Future<Either<String, UserModel>> getUserProfile() async {
    try {
      final response = await api.get(
        EndPoints.getUserDataById(
          CacheHelper().getData(key: ApiKeys.id),
        ),
      );
      final user = UserModel.fromJson(response);
      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }
}
