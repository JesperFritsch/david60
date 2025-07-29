import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/map_page.dart';
import 'pages/locations_page.dart';
import 'pages/notifications_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'viewmodels/map_viewmodel.dart';
import 'repositories/adventure_repository.dart';
import 'controllers/adventure_controller.dart';
import 'models/adventure.dart';
import 'repositories/notification_repository.dart';
import 'models/notification.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(AdventureNodeAdapter());
  Hive.registerAdapter(AdventureAdapter());
  Hive.registerAdapter(AppNotificationAdapter());

  final adventureRepository = HiveAdventureRepository();
  final notificationRepository = NotificationRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(
          create:
              (_) =>
                  AdventureController(repository: adventureRepository)
                    ..loadAdventure('mamma_test'),
        ),
        ChangeNotifierProvider(
          create:
              (_) => NotificationController(repository: notificationRepository),
        ),
      ],
      child: const AdventureApp(),
    ),
  );
}

class AdventureApp extends StatelessWidget {
  const AdventureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '60 års äventyr',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainNavigation(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('sv'), // or more if needed
      ],
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  static void setTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationState>();
    state?.setTab(index);
  }

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MapPage(),
    LocationsPage(),
    NotificationsPage(),
  ];

  void setTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    // Get the count of unlocked and not completed locations
    final adventureController = Provider.of<AdventureController>(context);
    final unlockedNotCompletedCount =
        adventureController.visibleNodes
            .where((node) => !node.completed)
            .length;
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: appLocalizations.map,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.list),
                if (unlockedNotCompletedCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$unlockedNotCompletedCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: appLocalizations.locations,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: appLocalizations.notifications,
          ),
        ],
      ),
    );
  }
}
