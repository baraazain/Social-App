import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/chats_screen.dart';
import 'package:social_app/modules/home_screen.dart';
import 'package:social_app/modules/post_screen.dart';
import 'package:social_app/modules/setting_screen.dart';
import 'package:social_app/modules/user_screen.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class SocialScreen extends StatelessWidget {
   SocialScreen({Key? key}) : super(key: key);
  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    PostScreen(),
    UserScreen(),
    SettingsScreen(),
  ];
  List<String> title = ['Home', 'Chat','Post', 'User', 'Setting'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is AddPostState){
          goTo(context, PostScreen());
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(title[cubit.currentIndex]),
            actions: [
              IconButton(onPressed: () {
                cubit.getAllUsers();
              }, icon: Icon(IconBroken.Notification)),
              IconButton(onPressed: () {}, icon: Icon(IconBroken.Search)),
            ],
          ),
          body: screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home),
                  label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat),
                  label: 'chat'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Edit),
                  label: 'post'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.User),
                  label: 'user'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting),
                  label:'settings'),
            ],
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeIndex(index);
            },
          ),
        );
      },
    );
  }
}
