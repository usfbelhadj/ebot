import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ebot/main.dart'; // adjust import as needed to point to your main.dart

void main() {
  group('Ebot App Navigation & Input Tests', () {
    testWidgets(
      'Navigates from WelcomeScreen to ProfileInputScreen and then to MealPlanScreen',
      (WidgetTester tester) async {
        // Wrap the app with ProviderScope to include our Riverpod providers
        await tester.pumpWidget(const ProviderScope(child: EbotApp()));

        // Verify that WelcomeScreen is displayed.
        expect(find.text('Welcome to Ebot!'), findsOneWidget);

        // Tap the "Get Started" button.
        final getStartedButton = find.text('Get Started');
        expect(getStartedButton, findsOneWidget);
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle();

        // Verify that the ProfileInputScreen is now displayed.
        expect(find.text('Enter your profile details:'), findsOneWidget);

        // Enter valid values in each input field.
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.decoration?.labelText == 'Weight (kg)',
          ),
          '70',
        );
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.decoration?.labelText == 'Height (cm)',
          ),
          '180',
        );
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.decoration?.labelText == 'Gym Frequency (days per week)',
          ),
          '4',
        );
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.decoration?.labelText == 'Meal Count per Day',
          ),
          '3',
        );
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.decoration?.labelText == 'Budget (\$)',
          ),
          '50',
        );

        // Tap the "Save & Generate Plans" button.
        final saveButton = find.text('Save & Generate Plans');
        expect(saveButton, findsOneWidget);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Verify that the MealPlanScreen is shown with generated meal plan info.
        expect(find.textContaining('Meal Plan:'), findsOneWidget);
      },
    );

    testWidgets('Shows error when profile inputs are incomplete or invalid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: EbotApp()));

      // Navigate to ProfileInputScreen.
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      expect(find.text('Enter your profile details:'), findsOneWidget);

      // Intentionally enter invalid (empty) data for a required field.
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Weight (kg)',
        ),
        '',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Height (cm)',
        ),
        '180',
      );
      // Leave other fields empty.

      // Tap the "Save & Generate Plans" button.
      await tester.tap(find.text('Save & Generate Plans'));
      await tester.pump();

      // Expect to see a SnackBar with the error message.
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.textContaining('Please fill in all fields with valid numbers'),
        findsOneWidget,
      );
    });

    testWidgets('Navigates from MealPlanScreen to TrainingProgramScreen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: EbotApp()));

      // Follow the full path: WelcomeScreen -> ProfileInputScreen -> MealPlanScreen.
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Provide valid input values.
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Weight (kg)',
        ),
        '70',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Height (cm)',
        ),
        '180',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Gym Frequency (days per week)',
        ),
        '4',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Meal Count per Day',
        ),
        '3',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Budget (\$)',
        ),
        '50',
      );

      await tester.tap(find.text('Save & Generate Plans'));
      await tester.pumpAndSettle();

      // Verify MealPlanScreen is displayed.
      expect(find.textContaining('Meal Plan:'), findsOneWidget);

      // In the MealPlanScreen, tap on the training program icon.
      final trainingIcon = find.byIcon(Icons.fitness_center);
      expect(trainingIcon, findsOneWidget);
      await tester.tap(trainingIcon);
      await tester.pumpAndSettle();

      // Verify that the TrainingProgramScreen is now displayed.
      expect(find.text('Training Program'), findsOneWidget);
    });
  });
}
