import '../constants/about_us.dart';

class UserModel {
  String email, username, bio;
  String? pictureURL, coverURL;
  bool isLive;
  List<String> followers, following;

  UserModel({
    required this.email,
    required this.username,
    this.bio = kDefaultUserBio,
    this.followers = const [],
    this.following = const [],
    this.pictureURL,
    this.coverURL,
    this.isLive = false,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'email': email,
      'username': username,
      'bio': bio,
      'followers': followers,
      'following': following,
      'isLive': isLive,
    };

    // Only add pictureURL and coverURL if they are not null.
    // If they are null, these fields are excluded from the map.
    if (pictureURL != null) {
      data['pictureURL'] = pictureURL;
    }

    if (coverURL != null) {
      data['coverURL'] = coverURL;
    }

    return data;
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    // Use safe casting to handle potential null values.
    return UserModel(
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      bio: json['bio'] ?? kDefaultUserBio,
      pictureURL: json['pictureURL'] as String?,
      coverURL: json['coverURL'] as String?,
      isLive: json['isLive'] ?? false,
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }

  UserModel copyWith({
    String? email,
    String? username,
    String? bio,
    String? pictureURL,
    String? coverURL,
    bool? isLive,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      pictureURL: pictureURL ?? this.pictureURL,
      coverURL: coverURL ?? this.coverURL,
      isLive: isLive ?? this.isLive,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
