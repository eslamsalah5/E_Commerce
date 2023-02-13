import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main/cubit.dart';
import '../../../main/state.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/icon_broken.dart';
import '../../../shared/styles/mode/cubit.dart';
import '../edit/edit.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    bool value = false;

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is UserLoginSuccessStates) {}
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.deepPurpleAccent,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {},
                        child: const CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(
                                'https://i.pinimg.com/564x/10/e7/67/10e7677471b96d788dabdab7bd20083a.jpg'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                          onPressed: () {
                            navigateTo(context, EditScreen());
                          },
                          icon: const Icon(
                            IconBroken.Edit_Square,
                            size: 30,
                          )),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    navigateTo(context, EditScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: const [
                        Icon(
                          IconBroken.Profile,
                          color: Colors.deepPurple,
                          size: 35,
                        ),
                        Text(
                          'My Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.topSlide,
                      title: 'Do you want to change mode?',
                      btnOkOnPress: () {
                        ModeCubit.get(context).changeAppMode();
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.dark_mode_outlined,
                          color: Colors.deepPurple,
                          size: 35,
                        ),
                        const Text(
                          'Theme Mode',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Spacer(),
                        Switch(
                          value: value,
                          onChanged: (value) {
                            ModeCubit.get(context).changeAppMode();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Do you want to Logout?',
                      desc: "Please, Login soon 🤚",
                      btnOkOnPress: () {
                        logOut(context);
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: const [
                        Icon(
                          IconBroken.Logout,
                          color: Colors.deepPurple,
                          size: 35,
                        ),
                        Text(
                          'Log Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}