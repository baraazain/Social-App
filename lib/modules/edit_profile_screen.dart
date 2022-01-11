import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/state_mangment/app_cubit.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        SocialUser? user = cubit.userModel;
        var profileImage = cubit.profileImage;
        File? coverImage = cubit.coverImage;
        nameController.text = user!.name!;
        bioController.text = user.bio!;
        phoneController.text = user.phone!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile'),
            leading: IconButton(
              icon: Icon(IconBroken.Arrow___Left_2),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 5,
            actions: [
              TextButton(
                child: Text('Update'),
                onPressed: ()async {
                  if (formKey.currentState!.validate()) {
                    if (cubit.coverImage != null) {
                     await cubit.uploadCoverImage();

                    }
                    if (cubit.profileImage != null) {
                    await  cubit.uploadProfileImage();
                    }

                    cubit.updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 210,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                      image: coverImage == null
                                          ? NetworkImage(user.cover ?? '')
                                          : FileImage(coverImage)
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              CircleAvatar(
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(
                                    IconBroken.Camera,
                                    color: Colors.white,
                                  ),
                                  iconSize: 20,
                                  onPressed: () {
                                    cubit.getCoverImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                          alignment: Alignment.topCenter,
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 45,
                              child: CircleAvatar(
                                backgroundImage: profileImage == null
                                    ? NetworkImage(user.image ?? '')
                                    : FileImage(profileImage) as ImageProvider,
                                radius: 40,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              child: IconButton(
                                icon: Icon(
                                  IconBroken.Camera,
                                  color: Colors.white,
                                ),
                                iconSize: 20,
                                onPressed: () {
                                  cubit.getProfileImage();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        defaultTextField(
                          validat: (String? value) {
                            if (value!.isEmpty) return 'name can\'t bee empty';
                            return null;
                          },
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          label: 'name',
                          prefixIcon: IconBroken.User,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultTextField(
                          validat: (String? value) {
                            if (value!.isEmpty) return 'bio can\'t bee empty';
                            return null;
                          },
                          controller: bioController,
                          keyboardType: TextInputType.text,
                          label: 'bio',
                          prefixIcon: IconBroken.Info_Circle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultTextField(
                          validat: (String? value) {
                            if (value!.isEmpty) return 'phone can\'t bee empty';
                            return null;
                          },
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          label: 'phone',
                          prefixIcon: IconBroken.Call,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
