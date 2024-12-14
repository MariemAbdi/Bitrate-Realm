class UserModel{
  String email ,nickname, bio, password;
  List<String> followers, following;

  UserModel({required this.email, this.nickname = "", this.password = "", this.bio="Hello World!", this.followers= const[], this.following= const[]});

  Map<String,dynamic> toJson()=>{
    'email': email,
    'nickname': nickname,
    'bio': bio,
    'followers': followers,
    'following': following,
  };

  static UserModel fromJson(Map<String,dynamic> json){
    return UserModel(
      email: json['email'],
      nickname: json['nickname'],
      bio: json['bio'],
      followers: json['followers'].cast<String>(),
      following: json['following'].cast<String>(),
      );
  }
}