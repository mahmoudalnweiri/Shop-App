import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/shop_cubit.dart';
import 'package:shop/layout/shop_layout.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop/modules/search/cubit/search_cubit.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';
import 'package:shop/shared/observer/my_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  DioHelper.init();

  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  var token = CacheHelper.getData(key: 'token');
  Widget widget;

  print(token);

  if (onBoarding == true) {
    widget = LoginScreen();
    if (CacheHelper.getData(key: 'token') != null) {
      widget = const ShopLayout();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      runApp(MyApp(onBoarding, widget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool onBoarding;
  final Widget startScreen;

  const MyApp(this.onBoarding, this.startScreen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavorites()
              ..getUserData()),
        BlocProvider(create: (context) => SearchCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'SF-Pro',
        ),
        home: startScreen,
      ),
    );
  }
}
