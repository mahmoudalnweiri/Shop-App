import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/shop_states.dart';
import 'package:shop/models/categories_model.dart';
import 'package:shop/models/change_favorites_model.dart';
import 'package:shop/models/favorites_model.dart';
import 'package:shop/models/home_model.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/modules/categories/categories_screen.dart';
import 'package:shop/modules/favorites/favorites_screen.dart';
import 'package:shop/modules/products/products_screen.dart';
import 'package:shop/modules/settings/settings_screen.dart';
import 'package:shop/shared/network/end_points.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(InitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeNavBottomState());
  }

  List screens = const [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(GetDataLoadingState());

    DioHelper.getData(
      url: HOME,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print('${homeModel!.status}');
      for (var element in homeModel!.data!.products) {
        favorites.addAll({element.id!: element.inFavorites!});
      }
      emit(GetDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetDataErrorState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      categoriesModel = CategoriesModel.formJson(value.data);
      emit(GetCategoriesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoriesErrorState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ChangeFavoritesSuccessState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      print(error.toString());
      emit(ChangeFavoritesErrorState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(GetFavoritesLoadingState());

    DioHelper.getData(
      url: FAVORITES,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(GetFavoritesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetFavoritesErrorState());
    });
  }

  LoginModel? userModel;

  void getUserData() {
    emit(GetUserDataLoadingState());

    DioHelper.getData(
      url: PROFILE,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState());
    });
  }

  void userLogout() {
    DioHelper.postData(
      url: LOGOUT,
      token: CacheHelper.getData(key: 'token'),
      data: {
        'fcm_token': CacheHelper.getData(key: 'token'),
      },
    ).then((value) {
      print(value.data);
      emit(LogoutSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LogoutErrorState());
    });
  }
}
