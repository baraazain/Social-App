import 'dart:core';

class SocialUser {
  String? uid;
  String? email;
  String? phone;
  String? name;
  String? bio;
  String? image;
  String? cover;

  SocialUser({this.email, this.name, this.phone, this.uid,this.image,this.cover,this.bio});

  SocialUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'phone': phone, 'email': email,'bio':bio,'image':image,'cover':cover};
  }
}
