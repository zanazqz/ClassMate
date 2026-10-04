enum TaskType { assignment, exam }

class Subject {
  final String id;
  final String name;
  final String teacher;
  final String room;
  final int color;

  const Subject({
    required this.id,
    required this.name,
    required this.teacher,
    required this.room,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'teacher': teacher,
        'room': room,
        'color': color,
      };

  factory Subject.fromJson(Map<String, dynamic> j) => Subject(
        id: j['id'],
        name: j['name'],
        teacher: j['teacher'],
        room: j['room'],
        color: j['color'] ?? 0xFF7C5CFF,
      );
}

class ClassSession {
  final String id;
  final String subjectId;
  final int weekday; // Dart: Mon=1 ... Sun=7
  final int startMinutes;
  final int endMinutes;
  final int reminderMinutes;
  final bool enabled;

  const ClassSession({
    required this.id,
    required this.subjectId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.reminderMinutes = 30,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'weekday': weekday,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
        'reminderMinutes': reminderMinutes,
        'enabled': enabled,
      };

  factory ClassSession.fromJson(Map<String, dynamic> j) => ClassSession(
        id: j['id'],
        subjectId: j['subjectId'],
        weekday: j['weekday'],
        startMinutes: j['startMinutes'],
        endMinutes: j['endMinutes'],
        reminderMinutes: j['reminderMinutes'] ?? 30,
        enabled: j['enabled'] ?? true,
      );
}

class TaskItem {
  final String id;
  final String title;
  final String subjectId;
  final TaskType type;
  final DateTime due;
  final bool completed;

  const TaskItem({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.type,
    required this.due,
    this.completed = false,
  });

  TaskItem copyWith({bool? completed}) => TaskItem(
        id: id,
        title: title,
        subjectId: subjectId,
        type: type,
        due: due,
        completed: completed ?? this.completed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subjectId': subjectId,
        'type': type.name,
        'due': due.toIso8601String(),
        'completed': completed,
      };

  factory TaskItem.fromJson(Map<String, dynamic> j) => TaskItem(
        id: j['id'],
        title: j['title'],
        subjectId: j['subjectId'] ?? '',
        type: TaskType.values.firstWhere(
          (e) => e.name == j['type'],
          orElse: () => TaskType.assignment,
        ),
        due: DateTime.parse(j['due']),
        completed: j['completed'] ?? false,
      );
}

class WeeklyGoal {
  final String title;
  final double progress;

  const WeeklyGoal({required this.title, required this.progress});
}
