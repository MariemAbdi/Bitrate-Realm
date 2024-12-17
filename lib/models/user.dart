class UserModel{
  String email, username, bio, password;
  String? pictureURL, coverURL;
  List<String> followers, following;

  UserModel({required this.email, this.username = "", this.password = "", this.bio="Hello World!", this.followers= const[], this.following= const[], this.pictureURL, this.coverURL});

  Map<String,dynamic> toJson()=>{
    'email': email,
    'username': username,
    'bio': bio,
    'followers': followers,
    'following': following,
    'pictureURL': pictureURL,
    'coverURL': coverURL
  };

  static UserModel fromJson(Map<String,dynamic> json){
    return UserModel(
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      bio: json['bio'] ?? "",
      pictureURL: json['pictureURL'] ?? "",
      coverURL: json['coverURL'] ?? "",
      followers: json['followers'].cast<String>() ?? [],
      following: json['following'].cast<String>() ?? [],
      );
  }




}