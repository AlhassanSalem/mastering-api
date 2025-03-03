import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mastering_api/cache/cache_helper.dart';
import 'package:mastering_api/core/api/api_consumer.dart';
import 'package:mastering_api/core/api/end_points.dart';
import 'package:mastering_api/core/errors/exception.dart';
import 'package:mastering_api/core/functions/upload_image_to_api.dart';
import 'package:mastering_api/cubit/user_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mastering_api/models/sign_in_model.dart';
import 'package:mastering_api/models/sign_up_model.dart';
import 'package:mastering_api/models/user_model.dart';

class UserCubit extends Cubit<UserState> {
  final ApiConsumer api;

  UserCubit(this.api) : super(UserInitial());

  //Sign in Form key
  GlobalKey<FormState> signInFormKey = GlobalKey();

  //Sign in email
  TextEditingController signInEmail = TextEditingController();

  //Sign in password
  TextEditingController signInPassword = TextEditingController();

  //Sign Up Form key
  GlobalKey<FormState> signUpFormKey = GlobalKey();

  //Profile Pic
  XFile? profilePic;

  //Sign up name
  TextEditingController signUpName = TextEditingController();

  //Sign up phone number
  TextEditingController signUpPhoneNumber = TextEditingController();

  //Sign up email
  TextEditingController signUpEmail = TextEditingController();

  //Sign up password
  TextEditingController signUpPassword = TextEditingController();

  //Sign up confirm password
  TextEditingController confirmPassword = TextEditingController();

  SignInModel? user;

  signIn() async {
    try {
      emit(SignInLoading());
      final response = await api.post(
        EndPoints.signIn,
        data: {
          ApiKeys.email: signInEmail.text,
          ApiKeys.password: signInPassword.text,
        },
      );
      user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user!.token);
      CacheHelper().saveData(key: ApiKeys.token, value: user!.token);
      CacheHelper().saveData(key: ApiKeys.id, value: decodedToken[ApiKeys.id]);
      emit(SignInSuccess());
    } on ServerException catch (e) {
      emit(SignInFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  uploadProfilePic(XFile image) {
    profilePic = image;
    emit(UploadProfilePic());
  }

  signUp() async {
    try {
      emit(SignUpLoading());
      final response =
          await api.post(EndPoints.signUp, isFormData: true, data: {
        ApiKeys.name: signUpName.text,
        ApiKeys.email: signUpEmail.text,
        ApiKeys.password: signUpPassword.text,
        ApiKeys.confirmPassword: confirmPassword.text,
        ApiKeys.phone: signUpPhoneNumber.text,
        ApiKeys.profilePic: uploadImageToApi(profilePic!),
        ApiKeys.location:
            '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}'
      });
      final signUpModel = SignUpModel.fromJson(response);
      emit(SignUpSuccess(message: signUpModel.message));
    } on ServerException catch (e) {
      emit(SignUpFailure(errMessage: e.errorModel.errorMessage));
    } catch (e){
      throw Exception(e.toString());
    }
  }

  getUserProfile() async {
    try {
      emit(GetUserLoading());
      final response = await api.get(
        EndPoints.getUserDataById(
          CacheHelper().getData(key: ApiKeys.id),
        ),
      );
      emit(GetUserSuccess(user: UserModel.fromJson(response)));
    } on ServerException catch (e) {
      emit(GetUserFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
