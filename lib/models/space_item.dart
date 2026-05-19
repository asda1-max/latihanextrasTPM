class SpaceItem {
  const SpaceItem({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final DateTime publishedAt;

  factory SpaceItem.fromJson(Map<String, dynamic> json) {
    return SpaceItem(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?)?.trim() ?? '-',
      url: (json['url'] as String?)?.trim() ?? '',
      imageUrl: (json['image_url'] as String?)?.trim() ?? '',
      newsSite: (json['news_site'] as String?)?.trim() ?? '-',
      summary: (json['summary'] as String?)?.trim() ?? '-',
      publishedAt: DateTime.tryParse((json['published_at'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}
