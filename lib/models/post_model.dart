import 'dart:core';

class PostModel {
  String? uid;
  String? name;
  String? image;
  String? postImage;
  String? text;
  String? date;

  PostModel({
    this.text,
    this.name,
    this.date,
    this.uid,
    this.image,
    this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    text = json['text'];
    postImage = json['postImage'];
    name = json['name'];
    image = json['image'];
    date = json['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'date': date,
      'postImage': postImage,
      'text': text,
      'image': image,
    };
  }
}
