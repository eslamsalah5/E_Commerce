import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2/modules/shop_modules/register/register/state.dart';

import '../../../../models/login_model.dart';
import '../../../../shared/network/end_point.dart';
import '../../../../shared/network/remote/dio_helper.dart';
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;
  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? image,
  }) {
    emit(RegisterLoadingState());

    DioHelper.postData(
      url: register,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'image': image,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(RegisterSuccessState(loginModel!));
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePassword() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordRegisterState());
  }
}