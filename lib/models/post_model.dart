class Post {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String date;
  final String link;
  final int? featuredMediaId;
  final String? featuredImageUrl;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.date,
    required this.link,
    this.featuredMediaId,
    this.featuredImageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String? imageUrl;

    if (json['_embedded'] != null &&
        json['_embedded']['wp:featuredmedia'] != null &&
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      imageUrl = json['_embedded']['wp:featuredmedia'][0]['source_url'];
    }

    return Post(
      id: json['id'],
      title: json['title']['rendered'] ?? '',
      content: json['content']['rendered'] ?? '',
      excerpt: json['excerpt']['rendered'] ?? '',
      date: json['date'] ?? '',
      link: json['link'] ?? '',
      featuredMediaId: json['featured_media'],
      featuredImageUrl: imageUrl,
    );
  }
}
