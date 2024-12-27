import 'dart:typed_data';

class LiveStream {
  //channelId is the id
  String? channelId, thumbnailLink, streamer, videoLink;
  String title, description, category;
  int views, duration;
  bool isLive;
  DateTime creationDate;
  Uint8List? thumbnail, video;
  List<String> tags, likes;

  LiveStream(
      {
        required this.title,
        required this.description,
        required this.category,
        this.streamer,
        this.views = 0,
        DateTime? creationDate,
        this.channelId,
        this.duration = 0,
        this.thumbnail,
        this.thumbnailLink,
        this.video,
        this.videoLink,
        this.tags = const[],
        this.likes = const[],
        this.isLive = false
      }) : creationDate = creationDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final data = {
      'channelId': channelId,
      'title': title,
      'description': description,
      'streamer': streamer,
      'tags': tags,
      'views': views,
      'date': creationDate,
      'duration': duration,
      'thumbnail': thumbnailLink,
      'category': category,
      'likes': likes,
      'isLive': isLive,
    };

    // Add videoLink only if it's not null
    if (videoLink != null) {
      data['videoLink'] = videoLink;
    }

    return data;
  }


  static LiveStream fromJson(Map<String, dynamic> json) {
    return LiveStream(
      channelId: json['channelId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      streamer: json['streamer'] ?? '',
      tags: json['tags']?.cast<String>() ?? [],
      views: json['views']?.toInt() ?? 0,
      creationDate: json['date']?.toDate() ?? DateTime.now(),
      duration: json['duration']?.toInt() ?? 0,
      thumbnailLink: json['thumbnail'],
      videoLink: json['videoLink'] ,
      likes: json['likes']?.cast<String>() ?? [],
      category: json['category'],
      isLive: json['isLive'],
    );
  }

  LiveStream copyWith({
    String? channelId,
    String? title,
    String? description,
    String? streamer,
    String? videoLink,
    String? category,
    int? views,
    int? duration,
    DateTime? creationDate,
    String? thumbnailLink,
    List<String>? tags,
    List<String>? likes,
    bool? isLive,
  }) {
    return LiveStream(
      title: title ?? this.title,
      description: description ?? this.description,
      streamer: streamer ?? this.streamer,
      channelId: channelId ?? this.channelId,
      videoLink: videoLink ?? this.videoLink,
      category: category ?? this.category,
      views: views ?? this.views,
      duration: duration ?? this.duration,
      creationDate: creationDate ?? this.creationDate,
      thumbnailLink: thumbnailLink ?? this.thumbnailLink,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      isLive: isLive ?? this.isLive,
    );
  }
}
