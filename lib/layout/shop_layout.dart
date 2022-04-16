import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/shop_cubit.dart';
import 'package:shop/layout/cubit/shop_states.dart';
import 'package:shop/modules/login/cubit/login_states.dart';
import 'package:shop/modules/search/search_screen.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is LoginLoadingState){
          ShopCubit.get(context).currentIndex = 0;
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Shwal',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                },
                icon: const Icon(Icons.search_outlined, color: Colors.black,),
              ),
            ],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.black87,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(cubit.currentIndex == 0
                      ? Icons.home
                      : Icons.home_outlined),
                  label: 'Products'),
              BottomNavigationBarItem(
                  icon: Icon(cubit.currentIndex == 1
                      ? Icons.apps
                      : Icons.apps_outlined),
                  label: 'Categories'),
              BottomNavigationBarItem(
                  icon: Icon(cubit.currentIndex == 2
                      ? Icons.favorite
                      : Icons.favorite_outline),
                  label: 'Favorites'),
              BottomNavigationBarItem(
                  icon: Icon(cubit.currentIndex == 3
                      ? Icons.settings
                      : Icons.settings_outlined),
                  label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}
