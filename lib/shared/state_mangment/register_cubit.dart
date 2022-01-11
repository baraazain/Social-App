import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/shared/state_mangment/register_state.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  IconData suffix = Icons.visibility;

  void changeShown() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(RegisterShownState());
  }

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(email: email, uid: value.user!.uid, phone: phone, name: name);
      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String email,
    required String uid,
    required String phone,
    required String name,
    String image = 'https://stylesatlife.com/wp-content/uploads/2019/12/african-girl-names.jpg.webp',
    String cover = 'https://ec.europa.eu/social/BlobServlet?mode=displayPicture&photoId=12077',
    String bio = 'write your bio',
  }) {
    SocialUser user = SocialUser(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
        image: image,
        bio: bio,
        cover: cover);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toMap())
        .then((value) {
      emit(CreateUserSuccessState(uid));
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
}
