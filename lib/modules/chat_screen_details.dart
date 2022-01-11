import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';
import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class ChatScreenDetails extends StatelessWidget {
  SocialUser user;

  ChatScreenDetails(this.user, {Key? key}) : super(key: key);
  var textControler = TextEditingController();
  var listControler = ScrollController();

  @override
  Widget build(BuildContext context) {

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
          Timer(Duration(seconds: 1),()=>listControler.jumpTo(listControler.position.maxScrollExtent));
          },
          builder: (context, state) {
            /*if(AppCubit.get(context).messages.length>0)
              listControler.jumpTo(listControler.position.maxScrollExtent);*/

            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.image ?? ''),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(user.name ?? ''),
                  ],
                ),
              ),
              body: ConditionalBuilder(
               condition: AppCubit.get(context).messages.length>0,
                builder:(context)=> Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            controller: listControler,
                            itemBuilder: (context, index) {
                              if (user.uid ==
                                  AppCubit.get(context)
                                      .messages[index]
                                      .receiverId)
                                return senderChat(
                                    AppCubit.get(context).messages[index]);
                              else
                                return receiverChat(
                                    AppCubit.get(context).messages[index]);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: AppCubit.get(context).messages.length),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: textControler,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'write your message',
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  AppCubit.get(context).sendMessage(
                                      receiverId: user.uid!,
                                      text: textControler.text,
                                      date: DateTime.now().toString());
                                  textControler.clear();
                                },
                                icon: Icon(
                                  IconBroken.Send,
                                  color: defaultColor,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback:(cotext)=>Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );

  }


  Widget receiverChat(ChatModel message) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text('${message.text}'),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
      );

  Widget senderChat(ChatModel message) => Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text('${message.text}'),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(0),
            ),
          ),
        ),
      );
}

