import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/modules/login/cubit/login_states.dart';
import 'package:shop/shared/network/end_points.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  var suffix = Icons.visibility_outlined;
  bool visible = true;

  void changeVisiblePassword() {
    visible = !visible;

    if (visible == false) {
      suffix = Icons.visibility_off_outlined;
    } else {
      suffix = Icons.visibility_outlined;
    }
    emit(LoginChangeVisiblePasswordState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());

    print('Loading...');

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      print('Loading...');
      loginModel = LoginModel.fromJson(value.data);
      print(value.data);
      print(loginModel!.status);
      print(loginModel!.message);
      print(loginModel!.data?.token);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }
}
