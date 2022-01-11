import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        SocialUser? userModel = cubit.userModel;

        return ConditionalBuilder(
          condition: cubit.posts.length > 0 && userModel != null,
          builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 10,
                        margin: EdgeInsets.all(5),
                        child: Image(
                          image: NetworkImage('${userModel!.cover}'),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'communication with friends',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => postItem(
                          context, cubit.posts[index], userModel, index),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                      itemCount: cubit.posts.length),
                ],
              )),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget postItem(context, PostModel post, SocialUser user, int index) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10,
        margin: EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('${user.image}'),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${user.name}'),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ],
                      ),
                      Text(
                        '${post.date}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              sperator(),
              SizedBox(
                height: 10,
              ),
              Text(
                '${post.text}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 14, height: 1.3),
              ),

              if (post.postImage != '')
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Image(
                    image: NetworkImage('${post.postImage}'),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              IconBroken.Heart,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${AppCubit.get(context).postLikeNumber[index]}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              IconBroken.Chat,
                              size: 18,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '325 comments',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sperator(),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 35,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${user.image}'),
                      radius: 15,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'write comment',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 14),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            child: IconButton(
                              onPressed: () {
                               AppCubit.get(context).liked(AppCubit.get(context).postsId[index], user.uid!);
                               /*  if(value)
                                 AppCubit.get(context).deleteLike(AppCubit.get(context).postsId[index]);
                                 else
                                   AppCubit.get(context).setLike(AppCubit.get(context).postsId[index]);*/
                               //});

                              },
                              icon: Icon(
                                IconBroken.Heart,
                                size: 18,
                                color: true ? Colors.red : Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
