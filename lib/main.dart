import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freeder_new/controllers/state_controller.dart';
import 'package:freeder_new/screens/texts_screen.dart';
import 'package:freeder_new/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize app logging
  setupLogging();
  final log = getLogger('main');
  log.info('Starting app');
  // var stcont = StateController();
  Get.putAsync<StateController>(() async {
    final c = StateController();
    await c.init();
    return c;
  },);
  // await UserPrefs().setPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Freeder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TextsScreen(),
    );
  }
}
