class DashboardStats {
  final int articlesCount;

  DashboardStats({
    required this.articlesCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      articlesCount: json['articles_count'] ?? 0,
    );
  }
}
