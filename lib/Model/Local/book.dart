class Book{
  final String id;
  final String title;
  final String author;
  final String genre;
  final int totalPage;
  final int? progress;
  final String readingStatus;
  final int addedAt;
  final String imageUrl;
  final String userId;

  Book( {
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.totalPage,
    this.progress = 0,
    required this.readingStatus,
    required this.addedAt,
    required this.imageUrl,
    required this.userId
  });
}