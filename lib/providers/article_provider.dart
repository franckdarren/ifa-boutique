import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/article_service.dart';
import '../models/article_model.dart';

final articleServiceProvider = Provider((ref) => ArticleService());

final articlesProvider = FutureProvider<List<ArticleModel>>((ref) async {
  final service = ref.read(articleServiceProvider);
  return await service.getArticles();
});
