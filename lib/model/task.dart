class Task {
  String title;
  int lvl = 0;
  double progress;
  int maxStars;
  String? imageUrl;

  Task(this.title, this.progress, this.maxStars, {this.imageUrl});

  int get maxLevel => maxStars * 10;
}
