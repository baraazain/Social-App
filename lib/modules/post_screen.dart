import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class PostScreen extends StatelessWidget {
  PostScreen({Key? key}) : super(key: key);
  var textControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('post'),
          leading: IconButton(
            icon: Icon(IconBroken.Arrow___Left_2),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 5,
          actions: [
            TextButton(onPressed: () {
              if(AppCubit.get(context).postImage!=null){
                AppCubit.get(context).uploadPostImage(text:textControler.text, date:DateTime.now().toString());
              }
              else{
                AppCubit.get(context).createPost(text:textControler.text, date:DateTime.now().toString());
              }

                   Navigator.pop(context);


            }, child: Text('post')),
          ],
        ),
        body: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            SocialUser? user = cubit.userModel;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user!.image ?? ''),
                        radius: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(user.name??''),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: textControler,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'write what in your mind...',
                          border: InputBorder.none),
                    ),
                  ),
                  if(cubit.postImage!=null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          image: DecorationImage(
                              image: FileImage(cubit.postImage ?? File('')),
                              fit: BoxFit.cover),
                        ),
                      ),
                      CircleAvatar(
                        radius: 15,
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 15,
                          ),

                          iconSize: 10,
                          onPressed: () {
                            cubit.cancelPostImage();
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: (
                                ) {
                              cubit.getPostImage();
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(IconBroken.Image),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('insert photo'),
                                ])),
                      ),
                      Expanded(
                          child: TextButton(
                              onPressed: () {}, child: Text('#Hashtags')))
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
