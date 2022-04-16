import 'package:shop/models/change_favorites_model.dart';

abstract class ShopStates {}

class InitialState extends ShopStates {}

class ChangeNavBottomState extends ShopStates {}

class GetDataLoadingState extends ShopStates {}

class GetDataSuccessState extends ShopStates {}

class GetDataErrorState extends ShopStates {}

class GetCategoriesSuccessState extends ShopStates {}

class GetCategoriesErrorState extends ShopStates {}

class GetFavoritesLoadingState extends ShopStates {}

class GetFavoritesSuccessState extends ShopStates {}

class GetFavoritesErrorState extends ShopStates {}

class ChangeFavoritesSuccessState extends ShopStates {
  final ChangeFavoritesModel model;

  ChangeFavoritesSuccessState(this.model);
}

class ChangeFavoritesErrorState extends ShopStates {}

class ChangeFavoritesState extends ShopStates {}

class GetUserDataLoadingState extends ShopStates {}

class GetUserDataSuccessState extends ShopStates {}

class GetUserDataErrorState extends ShopStates {}

class LogoutSuccessState extends ShopStates {}

class LogoutErrorState extends ShopStates {}