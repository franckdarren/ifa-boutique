import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/form_field_definition.dart';
import '../services/article_service.dart';

// Le provider qui récupère le schéma en fonction du type d'article
final formSchemaProvider =
    FutureProvider.family<List<FormFieldDefinition>, String>(
        (ref, articleType) async {
  final articleService = ref.read(articleServiceProvider);
  return articleService.fetchFormSchema(articleType);
});

// Provider pour l'article service
final articleServiceProvider = Provider<ArticleService>((ref) {
  return ArticleService();
});
