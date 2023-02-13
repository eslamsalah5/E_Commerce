import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2/modules/shop_modules/search/state.dart';
import '../../../models/search_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_point.dart';
import '../../../shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  var searchController = TextEditingController();
  void getSearch({String? text}) {
    emit(SearchLoadingStates());
    DioHelper.postData(url: search, token: token, data: {
      'text': text,
    }).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(SearchErrorStates());
    });
  }

  void clearSearchData() {
    searchController.clear();
    searchModel ;
  }
}