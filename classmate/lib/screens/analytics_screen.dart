import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<ClassSession> classes;
  final List<TaskItem> tasks;

  const AnalyticsScreen({super.key, required this.classes, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final done = tasks.where((t) => t.completed).length;
    final ratio = tasks.isEmpty ? 0.0 : done / tasks.length;
    final attendance = classes.isEmpty ? 0 : 87;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تحلیل و پیشرفت')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text('این هفته', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              children: [
                _Metric('کلاس‌ها', '${classes.length}', Icons.school_outlined, AppTheme.accent),
                _Metric('کارها', '$done/${tasks.length}', Icons.task_alt, AppTheme.success),
                _Metric('حضور', '$attendance%', Icons.person_pin_outlined, AppTheme.warning),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Momentum', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: ratio,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ratio >= .8
                        ? 'ریتمت خیلی خوبه؛ ادامه بده.'
                        : 'یک کار کوچک را همین امروز کامل کن.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF152542), Color(0xFF0D1729)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Text('🔥', style: TextStyle(fontSize: 30)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '۴ روز پشت‌سرهم فعال بودی.\nثبات از انگیزه مهم‌تره.',
                      style: TextStyle(height: 1.6, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _Metric(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsetsDirectional.only(end: 7),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      );
}
