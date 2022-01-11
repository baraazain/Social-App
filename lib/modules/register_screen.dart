import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_screen.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/component/constant.dart';
import 'package:social_app/shared/network/local/shared_preferance.dart';
import 'package:social_app/shared/state_mangment/register_cubit.dart';
import 'package:social_app/shared/state_mangment/register_state.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var emailControler = TextEditingController();
  var nameControler = TextEditingController();
  var phoneControler = TextEditingController();
  var passwordControler = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is RegisterErrorState){
            toast(color: Colors.red, message: state.error);
          }
          if(state is RegisterSuccessState){
            toast(color: Colors.green, message:'success register');
          }
          if(state is CreateUserSuccessState){
            CacheHelper.saveData(key: 'uid', value:state.uid);
            uid=state.uid;
            goToFinal(context, SocialScreen());
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'register to contact with your friends',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTextField(
                          validat: (String? value) {
                            if (value!.isEmpty) {
                              return 'name can\'t be empty';
                            }
                            return null;
                          },
                          controller: nameControler,
                          keyboardType: TextInputType.name,
                          label: "Name",
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTextField(
                          validat: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email can\'t be empty';
                            }
                            return null;
                          },
                          controller: emailControler,
                          keyboardType: TextInputType.emailAddress,
                          label: "Email Address",
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTextField(
                            validat: (String? value) {
                              if (value!.isEmpty) {
                                return 'password too short';
                              }
                              return null;
                            },
                            controller: passwordControler,
                            keyboardType: TextInputType.visiblePassword,
                            label: "Password",
                            prefixIcon: Icons.lock,
                            isPassword: cubit.isPassword,
                            suffixIcon: cubit.suffix,
                            suffixPressed: () {
                              cubit.changeShown();
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTextField(
                          validat: (String? value) {
                            if (value!.isEmpty) {
                              return 'phone can\'t be empty';
                            }
                            return null;
                          },
                          controller: phoneControler,
                          keyboardType: TextInputType.number,
                          label: "Phone Number",
                          prefixIcon: Icons.phone,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                    email: emailControler.text,
                                    name: nameControler.text,
                                    phone: phoneControler.text,
                                    password: passwordControler.text);
                              }
                            },
                            title: 'Register',
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
