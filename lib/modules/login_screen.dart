import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_screen.dart';
import 'package:social_app/modules/register_screen.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/component/constant.dart';
import 'package:social_app/shared/network/local/shared_preferance.dart';
import 'package:social_app/shared/state_mangment/login_cubit.dart';
import 'package:social_app/shared/state_mangment/login_state.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailControler = TextEditingController();
  var passwordControler = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is LoginErrorState){
            toast(color: Colors.red, message: state.error);
          }
          if(state is LoginSuccessState){
            toast(color: Colors.green, message:'success login');
            CacheHelper.saveData(key: 'uid', value:state.uid);
            uid=state.uid;
            goToFinal(context, SocialScreen());
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
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
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'login to contact with your friends',
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
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                    email: emailControler.text,
                                    password: passwordControler.text);
                              }
                            },
                            title: 'login',
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('if you don\'t have account'),
                            TextButton(
                                onPressed: () {
                                  goTo(context, RegisterScreen());
                                },
                                child: const Text('Register Now')),
                          ],
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
