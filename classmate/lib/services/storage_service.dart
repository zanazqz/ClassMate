import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const _subjectsKey = 'subjects_v1';
  static const _classesKey = 'classes_v1';
  static const _tasksKey = 'tasks_v1';

  Future<List<Subject>> subjects() async {
    final raw = await _prefs.getString(_subjectsKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => Subject.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<ClassSession>> classes() async {
    final raw = await _prefs.getString(_classesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => ClassSession.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<TaskItem>> tasks() async {
    final raw = await _prefs.getString(_tasksKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => TaskItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveSubjects(List<Subject> items) async {
    await _prefs.setString(
      _subjectsKey,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> saveClasses(List<ClassSession> items) async {
    await _prefs.setString(
      _classesKey,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> saveTasks(List<TaskItem> items) async {
    await _prefs.setString(
      _tasksKey,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> seedIfEmpty() async {
    if ((await subjects()).isNotEmpty) return;

    final seededSubjects = [
      const Subject(
        id: 'mobile',
        name: 'برنامه‌نویسی موبایل',
        teacher: 'شهرام مرادی',
        room: '204',
        color: 0xFF8B5CF6,
      ),
      const Subject(
        id: 'database',
        name: 'پایگاه داده',
        teacher: 'هوشنگ حاجی میرزایی',
        room: '302',
        color: 0xFF16C79A,
      ),
      const Subject(
        id: 'security',
        name: 'امنیت شبکه',
        teacher: 'فرهاد زمانی',
        room: '101',
        color: 0xFF2FA7FF,
      ),
    ];

    final seededClasses = [
      const ClassSession(
        id: 'c1',
        subjectId: 'mobile',
        weekday: 6,
        startMinutes: 14 * 60,
        endMinutes: 16 * 60,
      ),
      const ClassSession(
        id: 'c2',
        subjectId: 'database',
        weekday: 7,
        startMinutes: 8 * 60,
        endMinutes: 10 * 60,
      ),
      const ClassSession(
        id: 'c3',
        subjectId: 'security',
        weekday: 1,
        startMinutes: 13 * 60,
        endMinutes: 15 * 60,
      ),
    ];

    final now = DateTime.now();
    final seededTasks = [
      TaskItem(
        id: 't1',
        title: 'مرور جلسه قبل',
        subjectId: 'mobile',
        type: TaskType.assignment,
        due: now.add(const Duration(days: 1)),
      ),
      TaskItem(
        id: 't2',
        title: 'تحویل پروژه موبایل',
        subjectId: 'mobile',
        type: TaskType.assignment,
        due: now.add(const Duration(days: 2)),
      ),
      TaskItem(
        id: 't3',
        title: 'آزمون فصل ۴',
        subjectId: 'database',
        type: TaskType.exam,
        due: now.add(const Duration(days: 5)),
      ),
    ];

    await saveSubjects(seededSubjects);
    await saveClasses(seededClasses);
    await saveTasks(seededTasks);
  }
}
