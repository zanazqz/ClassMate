import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import 'add_sheets.dart';

class DashboardScreen extends StatefulWidget {
  final StorageService storage;
  final NotificationService notifications;
  final VoidCallback? onDataChanged;

  const DashboardScreen({
    super.key,
    required this.storage,
    required this.notifications,
    this.onDataChanged,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Subject> subjects = [];
  List<ClassSession> classes = [];
  List<TaskItem> tasks = [];
  int selectedDay = DateTime.now().weekday;
  Timer? timer;

  static const weekLabels = {
    6: 'ش',
    7: 'ی',
    1: 'د',
    2: 'س',
    3: 'چ',
    4: 'پ',
    5: 'ج',
  };

  static const fullWeekLabels = {
    6: 'شنبه',
    7: 'یکشنبه',
    1: 'دوشنبه',
    2: 'سه‌شنبه',
    3: 'چهارشنبه',
    4: 'پنجشنبه',
    5: 'جمعه',
  };

  @override
  void initState() {
    super.initState();
    load();
    timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    await widget.storage.seedIfEmpty();
    final s = await widget.storage.subjects();
    final c = await widget.storage.classes();
    final t = await widget.storage.tasks();
    if (!mounted) return;
    setState(() {
      subjects = s;
      classes = c;
      tasks = t;
    });
  }

  Subject? subjectFor(String id) {
    for (final s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  List<ClassSession> get selectedClasses => classes
      .where((c) => c.weekday == selectedDay && c.enabled)
      .toList()
    ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

  ClassSession? get nextClass {
    final now = DateTime.now();
    final candidates = <MapEntry<ClassSession, DateTime>>[];

    for (final c in classes.where((e) => e.enabled)) {
      var days = (c.weekday - now.weekday + 7) % 7;
      var date = DateTime(now.year, now.month, now.day + days);
      final start = DateTime(
        date.year,
        date.month,
        date.day,
        c.startMinutes ~/ 60,
        c.startMinutes % 60,
      );
      if (!start.isAfter(now)) {
        date = date.add(const Duration(days: 7));
        final nextStart = DateTime(
          date.year,
          date.month,
          date.day,
          c.startMinutes ~/ 60,
          c.startMinutes % 60,
        );
        candidates.add(MapEntry(c, nextStart));
      } else {
        candidates.add(MapEntry(c, start));
      }
    }

    candidates.sort((a, b) => a.value.compareTo(b.value));
    return candidates.isEmpty ? null : candidates.first.key;
  }

  DateTime? nextClassDate() {
    final c = nextClass;
    if (c == null) return null;
    final now = DateTime.now();
    var days = (c.weekday - now.weekday + 7) % 7;
    var date = DateTime(now.year, now.month, now.day + days);
    var start = DateTime(
      date.year,
      date.month,
      date.day,
      c.startMinutes ~/ 60,
      c.startMinutes % 60,
    );
    if (!start.isAfter(now)) {
      date = date.add(const Duration(days: 7));
      start = DateTime(
        date.year,
        date.month,
        date.day,
        c.startMinutes ~/ 60,
        c.startMinutes % 60,
      );
    }
    return start;
  }

  String time(int minutes) =>
      '${minutes ~/ 60}'.padLeft(2, '0') + ':' + '${minutes % 60}'.padLeft(2, '0');

  String relative(DateTime? date) {
    if (date == null) return '—';
    final d = date.difference(DateTime.now());
    if (d.inDays > 0) return '${d.inDays} روز دیگر';
    if (d.inHours > 0) return '${d.inHours} ساعت دیگر';
    if (d.inMinutes > 0) return '${d.inMinutes} دقیقه دیگر';
    return 'به‌زودی';
  }

  Future<void> addClass() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.bg,
      builder: (_) => AddClassSheet(
        subjects: subjects,
        onSave: (subject, session) async {
          subjects = [...subjects, subject];
          classes = [...classes, session];
          await widget.storage.saveSubjects(subjects);
          await widget.storage.saveClasses(classes);

          final reminderAt = session.startMinutes - session.reminderMinutes;
          var hour = reminderAt ~/ 60;
          var minute = reminderAt % 60;
          if (reminderAt < 0) {
            hour = 23;
            minute = 60 + reminderAt;
          }

          await widget.notifications.scheduleWeeklyClassReminder(
            id: session.id.hashCode.abs(),
            title: 'کلاس بعدی 🔔',
            body: '${subject.name} · ${subject.teacher} · کلاس ${subject.room}',
            weekday: session.weekday,
            hour: hour,
            minute: minute,
          );
          onDataChanged?.call();
          if (mounted) setState(() {});
        },
      ),
    );
  }

  Future<void> addTask() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.bg,
      builder: (_) => AddTaskSheet(
        subjects: subjects,
        onSave: (task) async {
          tasks = [...tasks, task];
          await widget.storage.saveTasks(tasks);
          widget.onDataChanged?.call();
          if (mounted) setState(() {});
        },
      ),
    );
  }

  Future<void> toggleTask(TaskItem task) async {
    final updated = task.copyWith(completed: !task.completed);
    tasks = tasks.map((e) => e.id == task.id ? updated : e).toList();
    await widget.storage.saveTasks(tasks);
    widget.onDataChanged?.call();
    if (mounted) setState(() {});
  }

  void showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('چه چیزی اضافه کنیم؟', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.school_outlined)),
                  title: const Text('کلاس'),
                  onTap: () {
                    Navigator.pop(context);
                    addClass();
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.task_alt)),
                  title: const Text('تکلیف / امتحان'),
                  onTap: () {
                    Navigator.pop(context);
                    addTask();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jalali = Jalali.fromDateTime(DateTime.now());
    final next = nextClass;
    final nextDate = nextClassDate();
    final todayTasks = tasks.where((t) => !t.completed).take(4).toList();
    final done = tasks.where((t) => t.completed).length;
    final progress = tasks.isEmpty ? 0.0 : done / tasks.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: showAddMenu,
          backgroundColor: AppTheme.primary,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 110),
              children: [
                _Header(jalali: jalali),
                const SizedBox(height: 18),
                if (next != null) _NextClassCard(
                  subject: subjectFor(next.subjectId)!,
                  session: next,
                  countdown: relative(nextDate),
                  time: time,
                ),
                const SizedBox(height: 22),
                _SectionTitle('این هفته', icon: Icons.calendar_month_outlined),
                const SizedBox(height: 10),
                _WeekStrip(
                  selected: selectedDay,
                  labels: weekLabels,
                  onSelect: (d) => setState(() => selectedDay = d),
                ),
                const SizedBox(height: 12),
                _DayTimeline(
                  label: fullWeekLabels[selectedDay]!,
                  classes: selectedClasses,
                  subjectFor: subjectFor,
                  time: time,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(child: _SectionTitle('کارهای باز', icon: Icons.check_circle_outline)),
                    TextButton(onPressed: addTask, child: const Text('افزودن')),
                  ],
                ),
                const SizedBox(height: 6),
                ...todayTasks.map((t) => _TaskTile(
                      task: t,
                      subject: subjectFor(t.subjectId),
                      onTap: () => toggleTask(t),
                    )),
                if (todayTasks.isEmpty)
                  _EmptyCard(text: 'همه‌چیز مرتب است. ✨'),
                const SizedBox(height: 22),
                _ProgressCard(progress: progress, done: done, total: tasks.length),
                const SizedBox(height: 14),
                _InsightCard(
                  text: progress >= .8
                      ? 'عالی پیش رفتی. فقط همین ریتم را حفظ کن.'
                      : 'امروز فقط یک کار مهم را کامل کن؛ حرکت کوچک هم پیشرفت است.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Jalali jalali;
  const _Header({required this.jalali});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سلام 👋',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 3),
                Text('داشبورد تحصیلی من', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 3),
                Text(
                  '${jalali.day} ${jalali.formatter.mN} ${jalali.year}',
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(.25), blurRadius: 20)],
            ),
            child: const Icon(Icons.school_rounded),
          ),
        ],
      );
}

class _NextClassCard extends StatelessWidget {
  final Subject subject;
  final ClassSession session;
  final String countdown;
  final String Function(int) time;

  const _NextClassCard({
    required this.subject,
    required this.session,
    required this.countdown,
    required this.time,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(subject.color).withOpacity(.28),
              AppTheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(subject.color).withOpacity(.65)),
          boxShadow: [
            BoxShadow(color: Color(subject.color).withOpacity(.12), blurRadius: 30, spreadRadius: -5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications_active_outlined, color: Color(subject.color)),
                const SizedBox(width: 8),
                Text('کلاس بعدی', style: TextStyle(color: Color(subject.color), fontWeight: FontWeight.w800)),
                const Spacer(),
                Text(countdown, style: const TextStyle(color: Colors.white60)),
              ],
            ),
            const SizedBox(height: 14),
            Text(subject.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '${time(session.startMinutes)} — ${time(session.endMinutes)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text('${subject.teacher}  ·  کلاس ${subject.room}', style: const TextStyle(color: Colors.white70)),
          ],
        ),
      );
}

class _WeekStrip extends StatelessWidget {
  final int selected;
  final Map<int, String> labels;
  final ValueChanged<int> onSelect;

  const _WeekStrip({required this.selected, required this.labels, required this.onSelect});

  @override
  Widget build(BuildContext context) => Row(
        children: [6, 7, 1, 2, 3, 4, 5].map((d) {
          final active = d == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? AppTheme.primary : AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: active ? AppTheme.primary : Colors.white10),
                ),
                child: Column(
                  children: [
                    Text(labels[d]!, style: TextStyle(fontWeight: FontWeight.w800, color: active ? Colors.white : Colors.white60)),
                    const SizedBox(height: 4),
                    if (d == DateTime.now().weekday)
                      Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
}

class _DayTimeline extends StatelessWidget {
  final String label;
  final List<ClassSession> classes;
  final Subject? Function(String) subjectFor;
  final String Function(int) time;

  const _DayTimeline({
    required this.label,
    required this.classes,
    required this.subjectFor,
    required this.time,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (classes.isEmpty) _EmptyCard(text: 'کلاسی برای این روز ثبت نشده.'),
          ...classes.map((c) {
            final s = subjectFor(c.subjectId);
            if (s == null) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border(right: BorderSide(color: Color(s.color), width: 3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Color(s.color).withOpacity(.14),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(Icons.menu_book_outlined, color: Color(s.color)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('${time(c.startMinutes)} — ${time(c.endMinutes)}  ·  ${s.teacher}'),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left, color: Colors.white30),
                ],
              ),
            );
          }),
        ],
      );
}

class _TaskTile extends StatelessWidget {
  final TaskItem task;
  final Subject? subject;
  final VoidCallback onTap;

  const _TaskTile({required this.task, required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Checkbox(
            value: task.completed,
            onChanged: (_) => onTap(),
          ),
          title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subject?.name ?? 'عمومی'),
          trailing: Text(
            '${task.due.day}/${task.due.month}',
            style: TextStyle(color: task.due.difference(DateTime.now()).inDays <= 1 ? AppTheme.warning : Colors.white54),
          ),
        ),
      );
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final int done;
  final int total;

  const _ProgressCard({required this.progress, required this.done, required this.total});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insights_outlined, color: AppTheme.accent),
                const SizedBox(width: 8),
                const Text('Momentum این هفته', style: TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress,
                backgroundColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 10),
            Text('$done از $total کار انجام شده', style: const TextStyle(color: Colors.white60)),
          ],
        ),
      );
}

class _InsightCard extends StatelessWidget {
  final String text;
  const _InsightCard({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF111E37), Color(0xFF0B1527)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const Text('💡', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(height: 1.6))),
          ],
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final IconData icon;
  const _SectionTitle(this.text, {required this.icon});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.accent),
          const SizedBox(width: 7),
          Text(text, style: Theme.of(context).textTheme.titleMedium),
        ],
      );
}

class _EmptyCard extends StatelessWidget {
  final String text;
  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white54)),
      );
}
