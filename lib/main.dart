
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2/modules/shop_modules/categories/categories%20details/categories_details_screen.dart';
import 'package:shop2/shared/components/constants.dart';
import 'package:shop2/shared/components/widgets/bloc_observe.dart';
import 'package:shop2/shared/network/local/cache_helper.dart';
import 'package:shop2/shared/network/remote/dio_helper.dart';
import 'package:shop2/shared/styles/mode/cubit.dart';
import 'package:shop2/shared/styles/mode/state.dart';
import 'package:shop2/shared/styles/themes.dart';
import 'layout/home_screen.dart';
import 'main/cubit.dart';
import 'modules/shop_modules/login/login_screen.dart';
import 'modules/shop_modules/on_boarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  token = CacheHelper.getData(key: 'token');

  if(onBoarding != null)
  {
    if(token != null) {
      widget = HomeScreen();
    } else {
      widget = LoginScreen();
    }
  }else
  {
    widget = OnBoardingScreen();
  }

  runApp(Myapp(
    startWidget: widget,
    isDark: isDark,
  ));
}

class Myapp extends StatelessWidget {
  final  bool? isDark;
  final Widget startWidget;

  Myapp({Key? key, required this.startWidget, this.isDark}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MainCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavoritesData()
              ..getUserData()),
        BlocProvider(
          create: (context) => ModeCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
      ],
      child: BlocConsumer<ModeCubit, ModeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ModeCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: startWidget
          );
        },
      ),
    );
  }
}