import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/analytics_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  final notifications = NotificationService();
  await storage.seedIfEmpty();
  await notifications.init();

  runApp(ClassMateApp(storage: storage, notifications: notifications));
}

class ClassMateApp extends StatefulWidget {
  final StorageService storage;
  final NotificationService notifications;

  const ClassMateApp({
    super.key,
    required this.storage,
    required this.notifications,
  });

  @override
  State<ClassMateApp> createState() => _ClassMateAppState();
}

class _ClassMateAppState extends State<ClassMateApp> {
  int index = 0;

  Future<Map<String, dynamic>> data() async => {
        'subjects': await widget.storage.subjects(),
        'classes': await widget.storage.classes(),
        'tasks': await widget.storage.tasks(),
      };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClassMate',
      theme: AppTheme.dark(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<Map<String, dynamic>>(
          future: data(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final subjects = snapshot.data!['subjects'] as List;
            final classes = snapshot.data!['classes'] as List;
            final tasks = snapshot.data!['tasks'] as List;

            final pages = [
              DashboardScreen(
                storage: widget.storage,
                notifications: widget.notifications,
                onDataChanged: () => setState(() {}),
              ),
              ScheduleScreen(
                subjects: subjects.cast(),
                classes: classes.cast(),
              ),
              AnalyticsScreen(
                classes: classes.cast(),
                tasks: tasks.cast(),
              ),
            ];

            return Scaffold(
              body: pages[index],
              bottomNavigationBar: NavigationBar(
                selectedIndex: index,
                onDestinationSelected: (v) => setState(() => index = v),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'خانه',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month),
                    label: 'برنامه',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.insights_outlined),
                    selectedIcon: Icon(Icons.insights),
                    label: 'تحلیل',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
