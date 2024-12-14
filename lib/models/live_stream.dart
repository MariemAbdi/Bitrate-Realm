import 'dart:typed_data';

class LiveStream {
  String id, title, description, user, channelId, language, videoLink, category, thumbnailLink;
  int views, duration;
  DateTime creationDate;
  Uint8List? thumbnail, video;
  List<String> tags, likes;

  LiveStream(
      { this.id = "",
        required this.title,
        required this.description,
        required this.language,
        required this.tags,
        this.user = "",
        this.views = 0,
        DateTime? creationDate,
        this.channelId = '',
        this.duration = 0,
        this.thumbnail,
        this.thumbnailLink = "",
        this.video,
        this.videoLink = '',
        this.likes = const [],
        required this.category
      })
      : creationDate = creationDate ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'user': user,
        'language': language,
        'tags': tags,
        'views': views,
        'date': creationDate,
        'channelId': channelId,
        'duration': duration,
        'thumbnail': thumbnailLink,
        'videoUrl': videoLink,
        'likes': likes,
        'category': category
      };

  static LiveStream fromJson(Map<String, dynamic> json) {
    return LiveStream(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      user: json['user'] ?? '',
      language: json['language'] ?? '',
      tags: json['tags']?.cast<String>() ?? [],
      views: json['views']?.toInt() ?? 0,
      creationDate: json['date']?.toDate() ?? DateTime.now(),
      channelId: json['channelId'] ?? '',
      duration: json['duration']?.toInt() ?? 0,
      thumbnailLink: json['thumbnail'] ?? '',
      videoLink: json['videoUrl'] ?? '',
      likes: json['likes']?.cast<String>() ?? [],
      category: json['category'],
    );
  }

  LiveStream copyWith({
    String? id,
    String? title,
    String? description,
    String? user,
    String? channelId,
    String? language,
    String? videoLink,
    String? category,
    int? views,
    int? duration,
    DateTime? creationDate,
    String? thumbnailLink,
    List<String>? tags,
    List<String>? likes,
  }) {
    return LiveStream(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      user: user ?? this.user,
      channelId: channelId ?? this.channelId,
      language: language ?? this.language,
      videoLink: videoLink ?? this.videoLink,
      category: category ?? this.category,
      views: views ?? this.views,
      duration: duration ?? this.duration,
      creationDate: creationDate ?? this.creationDate,
      thumbnailLink: thumbnailLink ?? this.thumbnailLink,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
    );
  }
}
