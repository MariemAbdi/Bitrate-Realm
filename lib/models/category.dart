class Category{
  final String id, title;

  const Category({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
    );
  }

  ///When you set the value in DropdownButtonFormField, it tries to match it with one of the items in the items list.
  ///The default equality operator checks object references, so even if the id and title match, it fails to find a match
  ///unless the objects are identical references. Overriding == and hashCode ensures that two Category objects with
  ///the same id and title are considered equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Category) return false;
    return id == other.id && title == other.title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}