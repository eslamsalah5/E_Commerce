import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2/main/state.dart';
import 'package:shop2/models/Product_Detail_model.dart';
import 'package:shop2/models/categories_details_model.dart';
import '../models/cart/change_cart_model.dart';
import '../models/cart/get_cart_model.dart';
import '../models/cart/update_cart_model.dart';
import '../models/category_model.dart';
import '../models/favorite_model.dart';
import '../models/home_model.dart';
import '../models/login_model.dart';
import '../modules/shop_modules/Favorites/favorite.dart';
import '../modules/shop_modules/categories/category.dart';
import '../modules/shop_modules/home/product_home.dart';
import '../modules/shop_modules/setting/setting.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import '../shared/network/end_point.dart';
import '../shared/network/remote/dio_helper.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitialStates());

  static MainCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic> favorites = {};
  Map<dynamic, dynamic> cart = {};

  int currentIndex = 0;

  List<Widget> pages = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  void ChangeNavBar(int index) {
    currentIndex = index;
    emit(ChangeNavBarItem());
  }

  LoginModel? UserData;

  void getUserData() {
    emit(UserLoginLoadingStates());

    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      UserData = LoginModel.fromJson(value.data);
      emit(UserLoginSuccessStates(UserData!));
    }).catchError((error) {
      print(error.toString());
      emit(UserLoginErrorStates(error.toString()));
    });
  }

  void UpdateUserData({
    required String email,
    required String name,
    required String phone,
    String? image,
  }) {
    emit(UserUpdateLoadingStates());

    DioHelper.putData(
      url: update,
      token: token,
      data: {
        'email': email,
        'name': name,
        'phone': phone,
      },
    ).then((value) {
      UserData = LoginModel.fromJson(value.data);
      emit(UserUpdateSuccessStates(UserData!));
    }).catchError((error) {
      print(error.toString());
      emit(UserUpdateErrorStates(error.toString()));
    });
  }

  HomeModel? homeModel;

  void getHomeData() {
    emit(HomeLoadingStates());
    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //printFullText(homeModel.data.banners.toString());
      print(homeModel!.status);
      print(token);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      homeModel!.data!.products.forEach((element) {
        cart.addAll({
          element.id: element.inCart,
        });
      });
      emit(HomeSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorStates());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: categories,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(CategoriesSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(CategoriesErrorStates());
    });
  }

  CategoryDetailModel? categoryDetailModel;

  void getCategoryDetailsData(int categoryId) {
    emit(CategoryDetailsLoadingStates());
    DioHelper.getData(
        url: "categories/$categoryId",
        token: token,
        query: {'category_id': categoryId}).then((value) {
      categoryDetailModel = CategoryDetailModel.fromJson(value.data);
      emit(CategoryDetailsSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(CategoryDetailsErrorStates());
    });
  }


  ProductResponse? productResponse;
  Future getProductData(productId) async {
    productResponse ;
    emit(ProductLoadingStates());
    return await DioHelper.getData(url: 'products/$productId', token: token)
        .then((value) {
      productResponse = ProductResponse.fromJson(value.data);
      //print('Product Detail '+productsModel.status.toString());
      emit(ProductSuccessStates(productResponse!));
    }).catchError((error) {
      emit(ProductErrorStates());
      print(error.toString());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productID) {
    favorites[productID] = !favorites[productID];
    emit(ChangeFavoritesStates());

    DioHelper.postData(url: favorite, token: token, data: {
      'product_id': productID,
    }).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites[productID] = !favorites[productID];
      } else {
        getFavoritesData();
      }
      emit(ChangeFavoritesSuccessStates(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productID] = !favorites[productID];
      emit(ChangeFavoritesErrorStates());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavoritesData() {
    emit(FavoritesLoadingStates());
    DioHelper.getData(
      url: favorite,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(GetFavoritesSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetFavoritesErrorStates());
    });
  }

  ////////////////////cart////////////////////////

  ChangeCartModel? changeCartModel;

  void changeCart(int productID) {
    cart[productID] = !cart[productID];
    emit(ChangeCartStates());

    DioHelper.postData(url: carts, token: token, data: {
      'product_id': productID,
    }).then((value) {
      changeCartModel = ChangeCartModel.fromJson(value.data);
      print(value.data);

      if (changeCartModel!.status!) {
        getCartData();
        getHomeData();
      } else
        showToast(
          text: changeCartModel!.message!,
          state: ToastStates.success,
        );
      emit(ChangeCartSuccessStates(changeCartModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ChangeCartErrorStates());
    });
  }

  CartModel? cartModel;

  void getCartData() {
    emit(CartLoadingStates());
    DioHelper.getData(
      url: carts,
      token: token,
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);
      emit(GetCartSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetCartErrorStates());
    });
  }


  UpdateCartModel? updateCartModel;

  void updateCartData(int id , int quantity) {
    emit(UpdateCartLoadingStates());
    DioHelper.putData(
      url: 'carts/$id',
      token: token,
        data: {
          'quantity': '$quantity'
        }
    ).then((value) {
      updateCartModel = UpdateCartModel.fromJson(value.data);
      if (updateCartModel!.status!) {
        getCartData();
      } else
        showToast(
          text: updateCartModel!.message!,
          state: ToastStates.success,
        );
      emit(UpdateCartSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateCartErrorStates());
    });
  }

  //////////////other//////////////////


  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void ShowPassword() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShowPasswordStates());
  }
}
