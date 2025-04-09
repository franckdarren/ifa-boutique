import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboardstats_model.dart';
import '../services/dashboard_service.dart';

final dashboardProvider =
    FutureProvider.family<DashboardStats, int>((ref, userId) async {
  final service = DashboardService();
  return await service.fetchStats(userId);
});
