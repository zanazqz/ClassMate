import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ScheduleScreen extends StatelessWidget {
  final List<Subject> subjects;
  final List<ClassSession> classes;

  const ScheduleScreen({super.key, required this.subjects, required this.classes});

  Subject? find(String id) {
    for (final s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  String time(int m) => '${m ~/ 60}'.padLeft(2, '0') + ':' + '${m % 60}'.padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    const order = [6, 7, 1, 2, 3, 4, 5];
    const labels = {
      6: 'شنبه',
      7: 'یکشنبه',
      1: 'دوشنبه',
      2: 'سه‌شنبه',
      3: 'چهارشنبه',
      4: 'پنجشنبه',
      5: 'جمعه',
    };

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('برنامه هفتگی')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: order.map((day) {
            final items = classes.where((c) => c.weekday == day).toList()
              ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(labels[day]!, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    const Text('—', style: TextStyle(color: Colors.white24))
                  else
                    ...items.map((c) {
                      final s = find(c.subjectId);
                      if (s == null) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Color(s.color).withOpacity(.5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Color(s.color),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text('${time(c.startMinutes)} — ${time(c.endMinutes)}'),
                                  Text('${s.teacher} · کلاس ${s.room}', style: const TextStyle(color: Colors.white54)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
