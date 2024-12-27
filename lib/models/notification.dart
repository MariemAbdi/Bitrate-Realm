class NotificationModel{
  String id, title, description, topic;
  DateTime dateTime;
  bool isDeleted, isSeen;
  
  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    this.isDeleted = false,
    this.isSeen = false,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'topic': topic,
      'dateTime': dateTime.toIso8601String(),
      'isDeleted': isDeleted,
      'isSeen': isSeen,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      topic: json['topic'],
      dateTime: DateTime.parse(json['dateTime']),
      isDeleted: json['isDeleted'],
      isSeen: json['isSeen'],
    );
  }
}