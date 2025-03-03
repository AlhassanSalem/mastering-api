import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastering_api/cubit/user_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mastering_api/models/sign_in_model.dart';
import 'package:mastering_api/repo/user_repo.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial());

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
    final response = await userRepository.signIn(
        email: signInEmail.text, password: signInPassword.text);

    response.fold((errMessage)=> emit(SignInFailure(errMessage: errMessage)), (signInModel) => emit(SignInSuccess()));
  }

  uploadProfilePic(XFile image) {
    profilePic = image;
    emit(UploadProfilePic());
  }

  signUp() async {
    emit(SignInLoading());
    final response = await userRepository.signUp(
      name: signUpName.text,
      email: signUpEmail.text,
      password: signUpPassword.text,
      phone: signUpPhoneNumber.text,
      confirmPassword: confirmPassword.text,
      profilePic: profilePic!,
    );
    response.fold(
      (errMassage) => emit(SignUpFailure(errMessage: errMassage)),
      (signUpModel) => emit(SignUpSuccess(message: signUpModel.message)),
    );
  }

  getUserProfile() async {
    emit(GetUserLoading());
    final response = await userRepository.getUserProfile();
    response.fold(
      (errMassage) => emit(GetUserFailure(errMessage: errMassage)),
      (userModel) => emit(GetUserSuccess(user: userModel)),
    );
  }
}
