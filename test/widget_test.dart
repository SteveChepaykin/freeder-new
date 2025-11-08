import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freeder_new/controllers/state_controller.dart';
import 'package:freeder_new/models/saved_text_model.dart';
import 'package:freeder_new/screens/reader_screen.dart';
import 'package:freeder_new/screens/settings_screen.dart';
import 'package:get/get.dart';

void main() {
  group('State Management Tests', () {
    late StateController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      controller = StateController();
      await controller.init();
    });

    test('Initial values are set correctly', () {
      expect(controller.textSize, 40); // Default text size
      expect(controller.speed, 200); // Default speed
    });

    test('Speed can be set and retrieved', () async {
      await controller.setSpeed(300);
      expect(controller.getSpeed(), 300);
    });

    test('Text size can be set and retrieved', () async {
      await controller.setSize(50);
      expect(controller.getSize(), 50);
    });

    test('Speed map provides correct reading delays', () {
      // Test for short words
      expect(controller.speedsMap[200]?['short'], 250);
      // Test for medium words
      expect(controller.speedsMap[200]?['medium'], 300);
      // Test for long words
      expect(controller.speedsMap[200]?['long'], 400);
    });
  });

  group('SavedText Model Tests', () {
    test('SavedText creation and JSON conversion', () {
      final now = DateTime.now();
      final text = SavedText(
        id: 1,
        title: 'Test Title',
        wholetext: 'Test Content',
        lastindex: 0,
        timecreated: now,
      );

      final json = text.toJson();
      
      expect(json[SavedTextFields.id], 1);
      expect(json[SavedTextFields.wholetext], 'Test Content');
      expect(json[SavedTextFields.lastindex], 0);
      expect(json[SavedTextFields.timecreated], now.toIso8601String());
    });

    test('SavedText JSON deserialization', () {
      final now = DateTime.now();
      final json = {
        SavedTextFields.id: 1,
        SavedTextFields.title: now.toIso8601String(),
        SavedTextFields.wholetext: 'Test Content',
        SavedTextFields.lastindex: 0,
        SavedTextFields.timecreated: now.toIso8601String(),
      };

      final text = SavedText.fromJson(json);
      
      expect(text.id, 1);
      expect(text.wholetext, 'Test Content');
      expect(text.lastindex, 0);
      expect(text.timecreated.toIso8601String(), now.toIso8601String());
    });

    test('SavedText copy with modifications', () {
      final now = DateTime.now();
      final text = SavedText(
        id: 1,
        title: 'Test Title',
        wholetext: 'Test Content',
        lastindex: 0,
        timecreated: now,
      );

      final copied = text.copy(
        title: 'New Title',
        lastindex: 5,
      );

      expect(copied.id, text.id);
      expect(copied.title, 'New Title');
      expect(copied.lastindex, 5);
      expect(copied.wholetext, text.wholetext);
      expect(copied.timecreated, text.timecreated);
    });
  });

  group('Widget Tests', () {
    late StateController controller;

    setUp(() async {
      Get.testMode = true;
      SharedPreferences.setMockInitialValues({});
      controller = StateController();
      await controller.init();
      Get.put(controller);
      
      // Set a larger window size for testing
      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.window.physicalSizeTestValue = const Size(1080, 1920);
      binding.window.devicePixelRatioTestValue = 1.0;
    });

    testWidgets('Settings screen initializes correctly', (WidgetTester tester) async {
      // Build material app with settings screen
      await tester.pumpWidget(
        GetMaterialApp(
          home: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify that settings controls are present
      expect(find.text('размер текста:'), findsOneWidget);
      expect(find.text('скорость чтения (слов/мин):'), findsOneWidget);
      
      // Verify text size limits are shown
      expect(find.text('25 < '), findsOneWidget);
      expect(find.text(' > 75 '), findsOneWidget);
      
      // Verify that speed buttons are present
      expect(find.widgetWithText(ElevatedButton, '100'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '200'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '300'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '400'), findsOneWidget);
    });

    // testWidgets('Settings can be changed', (WidgetTester tester) async {
    //   // Build material app with settings screen
    //   await tester.pumpWidget(
    //     GetMaterialApp(
    //       home: const SettingsScreen(),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   // Change text size
    //   await tester.enterText(find.byType(TextField), '50');
    //   await tester.pumpAndSettle();
      
    //   // Verify text size was updated
    //   expect(find.widgetWithText(TextField, '50'), findsOneWidget);
      
    //   // Change speed by clicking speed button
    //   await tester.tap(find.widgetWithText(ElevatedButton, '300'));
    //   await tester.pumpAndSettle();

    //   // Click the save button
    //   await tester.tap(find.byIcon(Icons.save));
    //   await tester.pumpAndSettle();

    //   // Wait for SharedPreferences to update
    //   await Future.delayed(const Duration(milliseconds: 100));
      
    //   // Reset the controller to force a read from SharedPreferences
    //   controller = StateController();
    //   await controller.init();
      
    //   // Verify settings were saved
    //   expect(controller.getSize(), 50);
    //   expect(controller.getSpeed(), 300);
    // });
  });
}
