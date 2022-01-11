import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_screen.dart';
import 'package:social_app/modules/login_screen.dart';
import 'package:social_app/shared/component/constant.dart';
import 'package:social_app/shared/network/local/shared_preferance.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/bloc_observer.dart';
import 'package:social_app/shared/style/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer=MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
 
          return BlocProvider(
            create: (BuildContext context)=>AppCubit()..getUser()..getPosts()..getAllUsers(),
            child: MaterialApp(
              home:getStart(),
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme:darkTheme,
              themeMode:ThemeMode.light,
            ),
          );
        }
        Widget getStart(){
      uid=CacheHelper.getData(key: 'uid');
      if(uid==null)
        return LoginScreen();
      else
        return SocialScreen();
        }

      
}

