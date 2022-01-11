import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/modules/chat_screen_details.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.users.length > 0 ,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    buildUserList(cubit.users[index],context),
                separatorBuilder: (context, index) => sperator(),
                itemCount: cubit.users.length),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildUserList(SocialUser user,context) => InkWell(
    onTap: (){
      AppCubit.get(context).getMessages(receiverId: user.uid!);
      goTo(context, ChatScreenDetails(user));
    },
    child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.image ?? ''),
              radius: 20,
            ),
            SizedBox(
              width: 50,
            ),
            Text(user.name ?? '',
              style:TextStyle(
                  fontSize: 24
              ),
            ),
          ],
        ),
  );
}
