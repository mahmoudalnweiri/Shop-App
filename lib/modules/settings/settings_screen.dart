import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/shop_cubit.dart';
import 'package:shop/layout/cubit/shop_states.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/shared/network/local/cache_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is LogoutSuccessState){
          CacheHelper.removeData(key: 'token').then((value){
            if(value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }
          });
        }
      },
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ShopCubit.get(context).userLogout();
                },
                child: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.w900),),
              ),
            ),
          ),
        );
      },
    );
  }
}
