import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/modules/edit_profile_screen.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/network/local/shared_preferance.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';
import 'package:social_app/shared/style/icon_broken.dart';

import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
        },
        builder: (context,state){
          SocialUser? user=AppCubit.get(context).userModel;
          return ConditionalBuilder(
              condition: user!=null,
              builder:(context)=>buildProfile(user, context) ,
              fallback:(context)=> Center(child: CircularProgressIndicator()));

        },
    );
  }
  Widget buildProfile(SocialUser? user,context)=>SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 190,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                          image: NetworkImage(user!.cover ??''),
                          fit: BoxFit.cover),
                    ),
                  ),
                  alignment: Alignment.topCenter,
                ),
                CircleAvatar(
                  backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                  radius: 45,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('${user.image}'),
                      radius: 40,
                  ),
                ),
              ],
            ),
          ),
          Text(user.name??'',style: Theme.of(context).textTheme.bodyText1,),
          Text(user.bio??'',style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('154',style: Theme.of(context).textTheme.bodyText1,),
                    Text('post',style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('100',style: Theme.of(context).textTheme.bodyText1,),
                    Text('photo',style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('800',style: Theme.of(context).textTheme.bodyText1,),
                    Text('followers',style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('10k',style: Theme.of(context).textTheme.bodyText1,),
                    Text('following',style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),),
                  ],

                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            width: 150,
            child: OutlinedButton(onPressed: (){
              AppCubit.get(context).resetVariable();
              goTo(context,EditProfileScreen());
            },
                child:Row(
              children: [
                Text('Edit Profile'),
                Spacer(),
                Icon(IconBroken.Edit),
              ],

            ) ,),
          ),
          SizedBox(height: 10,),

          Container(
            width:150,
            child: OutlinedButton(onPressed: (){
              logOut(context, LoginScreen());
              CacheHelper.removeData(key: 'uid');
            }, child:Row(
              children: [
                Text('LogOut'),
                Spacer(),
                Icon(IconBroken.Logout),
              ],
            ) ),
          ),

        ],
      ),
    ),
  );
}
