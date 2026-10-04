import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AddClassSheet extends StatefulWidget {
  final List<Subject> subjects;
  final Future<void> Function(Subject subject, ClassSession session) onSave;

  const AddClassSheet({
    super.key,
    required this.subjects,
    required this.onSave,
  });

  @override
  State<AddClassSheet> createState() => _AddClassSheetState();
}

class _AddClassSheetState extends State<AddClassSheet> {
  final name = TextEditingController();
  final teacher = TextEditingController();
  final room = TextEditingController();
  int weekday = 6;
  TimeOfDay start = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay end = const TimeOfDay(hour: 16, minute: 0);
  int reminder = 30;

  int mins(TimeOfDay t) => t.hour * 60 + t.minute;

  Future<void> pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? start : end,
      builder: (c, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        start = picked;
      } else {
        end = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SheetHandle(),
              Text('افزودن کلاس', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              TextField(controller: name, decoration: const InputDecoration(labelText: 'نام درس')),
              const SizedBox(height: 12),
              TextField(controller: teacher, decoration: const InputDecoration(labelText: 'استاد')),
              const SizedBox(height: 12),
              TextField(controller: room, decoration: const InputDecoration(labelText: 'شماره کلاس')),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: weekday,
                decoration: const InputDecoration(labelText: 'روز'),
                items: const [
                  DropdownMenuItem(value: 6, child: Text('شنبه')),
                  DropdownMenuItem(value: 7, child: Text('یکشنبه')),
                  DropdownMenuItem(value: 1, child: Text('دوشنبه')),
                  DropdownMenuItem(value: 2, child: Text('سه‌شنبه')),
                  DropdownMenuItem(value: 3, child: Text('چهارشنبه')),
                  DropdownMenuItem(value: 4, child: Text('پنجشنبه')),
                  DropdownMenuItem(value: 5, child: Text('جمعه')),
                ],
                onChanged: (v) => setState(() => weekday = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => pickTime(true),
                      icon: const Icon(Icons.schedule),
                      label: Text('شروع ${start.format(context)}'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => pickTime(false),
                      icon: const Icon(Icons.schedule_outlined),
                      label: Text('پایان ${end.format(context)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: reminder,
                decoration: const InputDecoration(labelText: 'یادآوری'),
                items: const [
                  DropdownMenuItem(value: 10, child: Text('۱۰ دقیقه قبل')),
                  DropdownMenuItem(value: 30, child: Text('۳۰ دقیقه قبل')),
                  DropdownMenuItem(value: 60, child: Text('۱ ساعت قبل')),
                ],
                onChanged: (v) => setState(() => reminder = v!),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  if (name.text.trim().isEmpty) return;
                  final subject = Subject(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    name: name.text.trim(),
                    teacher: teacher.text.trim().isEmpty ? '—' : teacher.text.trim(),
                    room: room.text.trim().isEmpty ? '—' : room.text.trim(),
                    color: AppTheme.primary.value,
                  );
                  final session = ClassSession(
                    id: '${subject.id}_class',
                    subjectId: subject.id,
                    weekday: weekday,
                    startMinutes: mins(start),
                    endMinutes: mins(end),
                    reminderMinutes: reminder,
                  );
                  await widget.onSave(subject, session);
                  if (mounted) Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('ذخیره کلاس'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTaskSheet extends StatefulWidget {
  final List<Subject> subjects;
  final Future<void> Function(TaskItem task) onSave;

  const AddTaskSheet({super.key, required this.subjects, required this.onSave});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final title = TextEditingController();
  TaskType type = TaskType.assignment;
  String subjectId = '';
  DateTime due = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    if (widget.subjects.isNotEmpty) subjectId = widget.subjects.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SheetHandle(),
              Text('افزودن کار', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              SegmentedButton<TaskType>(
                segments: const [
                  ButtonSegment(value: TaskType.assignment, label: Text('تکلیف')),
                  ButtonSegment(value: TaskType.exam, label: Text('امتحان')),
                ],
                selected: {type},
                onSelectionChanged: (v) => setState(() => type = v.first),
              ),
              const SizedBox(height: 14),
              TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان')),
              const SizedBox(height: 12),
              if (widget.subjects.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: subjectId,
                  decoration: const InputDecoration(labelText: 'درس'),
                  items: widget.subjects
                      .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                      .toList(),
                  onChanged: (v) => setState(() => subjectId = v ?? subjectId),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDate: due,
                  );
                  if (d != null) setState(() => due = d);
                },
                icon: const Icon(Icons.event),
                label: Text('مهلت: ${due.day}/${due.month}/${due.year}'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  if (title.text.trim().isEmpty) return;
                  await widget.onSave(
                    TaskItem(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      title: title.text.trim(),
                      subjectId: subjectId,
                      type: type,
                      due: due,
                    ),
                  );
                  if (mounted) Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('ذخیره'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 42,
          height: 4,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
}
