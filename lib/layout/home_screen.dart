import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2/modules/shop_modules/cart/cart_screen.dart';
import '../main/cubit.dart';
import '../main/state.dart';
import '../modules/shop_modules/search/view.dart';
import '../shared/components/components.dart';
import '../shared/styles/icon_broken.dart';
import '../shared/styles/mode/cubit.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("E_Commerce"),
              actions: [
                IconButton(
                  icon: Icon(
                    IconBroken.Search,
                    color: Colors.deepPurpleAccent,
                  ),
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                ),
                IconButton(
                  onPressed: () {
                    ModeCubit.get(context).changeAppMode();
                  },
                  icon: Icon(Icons.dark_mode_outlined),
                )
              ],
            ),
            body: cubit.pages[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepPurpleAccent,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Icon(
                Icons.add_shopping_cart,
              ),
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              elevation: 50.0,
              onTap: (index) {
                cubit.ChangeNavBar(index);
              },
              activeIndex: cubit.currentIndex,

              icons: [
                IconBroken.Home,
                IconBroken.Category,
                IconBroken.Heart,
                IconBroken.Setting,
              ],
              activeColor: Colors.deepPurpleAccent,
              splashColor: Colors.red,
              inactiveColor: Colors.black,
              iconSize: 30.0,
              //backgroundColor: Colors.grey[200],
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.smoothEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
            ),
          ),
        );
      },
    );
  }
}