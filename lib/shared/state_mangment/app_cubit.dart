import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/social_user.dart';
import 'package:social_app/shared/component/constant.dart';
import 'package:social_app/shared/state_mangment/app_state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  SocialUser? userModel;
  ImagePicker Picker = ImagePicker();

  void getUser() {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      userModel = SocialUser.fromJson(value.data() ?? {});
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> postLikeNumber = [];
  List<String> postLikeIDUser = [];

  void getPosts() {
    posts = [];
    postsId = [];
    postLikeNumber = [];
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('like').get().then((value) {
          postLikeNumber.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(GetPostsSuccessState());
    }).catchError((error) {
      emit(GetPostsErrorState());
    });
  }
  bool likedValue=false;
  void liked(String postId ,String userId) {
     getIdUserLikePost(postId).then((value) {
      print(postLikeIDUser.length);
    });




    }


  Future<void> getIdUserLikePost(String idPost) async{
    postLikeIDUser=[];
     FirebaseFirestore.instance
        .collection('posts')
        .doc(idPost)
        .collection('like')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            postLikeIDUser.add(element.id);
           // print(postLikeIDUser.length);
          });
    })
        .catchError((error) {});
  }


  int currentIndex = 0;

  void changeIndex(index) {
    if (index == 2) {
      emit(AddPostState());
    } else {
      currentIndex = index;
      emit(ChangeNavIndexState());
    }
  }

  void cancelPostImage() {
    postImage = null;
    emit(CancelPostImageState());
  }

  void resetVariable() {
    profileImage = null;
    coverImage = null;
    profileImageUrl = null;
    coverImageUrl = null;
    emit(ResetState());
  }

  File? profileImage;

  Future<void> getProfileImage() async {
    var pickerImage = await Picker.getImage(source: ImageSource.gallery);
    if (pickerImage != null) {
      profileImage = File(pickerImage.path);
      emit(GetImageProfileGallerySuccessState());
    } else {
      emit(GetImageProfileGalleryErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    var pickerImage = await Picker.getImage(source: ImageSource.gallery);
    if (pickerImage != null) {
      coverImage = File(pickerImage.path);
      emit(GetImageCoverGallerySuccessState());
    } else {
      emit(GetImageCoverGalleryErrorState());
    }
  }

  String? profileImageUrl;

  Future<void> uploadProfileImage() {
    return firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        emit(UploadImageProfileSuccessState());
      }).catchError((error) {
        emit(UploadImageProfileErrorState());
      });
    }).catchError((error) {
      emit(UploadImageProfileErrorState());
    });
  }

  String? coverImageUrl;

  Future<void> uploadCoverImage() {
    return firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        emit(UploadImageCoverSuccessState());
      }).catchError((error) {
        emit(UploadImageCoverErrorState());
      });
    }).catchError((error) {
      emit(UploadImageCoverErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
  }) {
    SocialUser user = SocialUser(
        uid: userModel!.uid,
        name: name,
        phone: phone,
        email: userModel!.email,
        image: profileImageUrl ?? userModel!.image,
        bio: bio,
        cover: coverImageUrl ?? userModel!.cover);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(user.toMap())
        .then((value) {
      getUser();
      emit(UpdateUserSuccessState());
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    var pickerImage = await Picker.getImage(source: ImageSource.gallery);
    if (pickerImage != null) {
      postImage = File(pickerImage.path);
      emit(GetPostImageSuccessState());
    } else {
      emit(GetPostImageErrorState());
    }
  }

  String? postImageUrl;

  void uploadPostImage({
    required String text,
    required String date,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        postImageUrl = value;
        emit(UploadImagePostSuccessState());
        createPost(text: text, date: date);
      }).catchError((error) {
        emit(UploadImagePostErrorState());
      });
    }).catchError((error) {
      emit(UploadImagePostErrorState());
    });
  }

  void createPost({
    required String text,
    required String date,
  }) {
    PostModel postModel = PostModel(
        uid: userModel!.uid,
        name: userModel!.name,
        image: userModel!.image,
        date: date,
        text: text,
        postImage: postImageUrl ?? '');

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      getPosts();
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void setLike(String postUid) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('like')
        .doc(userModel!.uid)
        .set({'like': true}).then((value) {
      emit(SetLikePostsSuccessState());
    }).catchError((error) {
      emit(SetLikePostsErrorState());
    });
  }

  void deleteLike(String postUid) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('like')
        .doc(userModel!.uid)
        .delete()
        .then((value) {
      emit(DeleteLikePostsSuccessState());
    }).catchError((error) {
      emit(DeleteLikePostsErrorState());
    });
  }

  List<SocialUser> users = [];

  void getAllUsers() {
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uid'] != userModel!.uid)
          users.add(SocialUser.fromJson(element.data()));
      });
      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllUsersErrorState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String text,
    required String date,
  }) {
    ChatModel chat = ChatModel(
        date: date,
        text: text,
        receiverId: receiverId,
        senderId: userModel!.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(chat.toMap())
        .then((value) {
      emit(SendChatSuccessState());
    }).catchError((error) {
      emit(SendChatErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uid)
        .collection('messages')
        .add(chat.toMap())
        .then((value) {
      emit(SendChatSuccessState());
    }).catchError((error) {
      emit(SendChatErrorState());
    });
  }

  List<ChatModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(ChatModel.fromJson(element.data()));
      });

      emit(GetMessagesSuccessState());
    });
  }
}
