class Task {
  int? id;
  final String title;
  double progress;
  int maxStars;
  String? imageUrl;
  int lvl;
  
  Task({
    this.id,
    required this.title,
    required this.progress,
    required this.maxStars,
    this.lvl = 0,
    this.imageUrl,
  });

  int get maxLevel => maxStars * 10;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      lvl: json['lvl'],
      progress: json['progress'],
      maxStars: json['maxStars'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lvl': lvl,
      'progress': progress,
      'maxStars': maxStars,
      'imageUrl': imageUrl,
    };
  }
}
