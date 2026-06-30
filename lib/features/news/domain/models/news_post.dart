class NewsPost {
  const NewsPost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.content,
    required this.imageUrls,
    required this.likesCount,
    required this.commentsCount,
    required this.category,
  });

  final String id;
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String content;
  final List<String> imageUrls;
  final int likesCount;
  final int commentsCount;
  final String category;
}
