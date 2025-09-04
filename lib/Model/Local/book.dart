class Book{
  final int? id;
  final String title;
  final String author;
  final String genre;
  final int totalPage;
  final int? progress;
  final String readingStatus;
  final String addedAt;
  final String imageUrl;

  Book( {
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.totalPage,
    this.progress = 0,
    required this.readingStatus,
    required this.addedAt,
    required this.imageUrl,
  });
}