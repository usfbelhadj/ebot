import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_profile.dart';
import '../models/meal_plan.dart';
import '../models/training_program.dart';

class EbotNotifier extends StateNotifier<UserProfile> {
  EbotNotifier() : super(UserProfile());

  void updateWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void updateHeight(double height) {
    state = state.copyWith(height: height);
  }

  void updateGymFrequency(int frequency) {
    state = state.copyWith(gymFrequency: frequency);
  }

  void updateMealCount(int count) {
    state = state.copyWith(mealCount: count);
  }

  void updateBudget(double budget) {
    state = state.copyWith(budget: budget);
  }
}

final ebotProvider = StateNotifierProvider<EbotNotifier, UserProfile>(
  (ref) => EbotNotifier(),
);

// Dummy meal plan provider – in a real app, integrate AI logic here.
final mealPlanProvider = Provider<MealPlan>((ref) {
  final profile = ref.watch(ebotProvider);
  final description =
      'Meal Plan:\nWeight: ${profile.weight}, Height: ${profile.height}\nMeal Count: ${profile.mealCount}, Budget: ${profile.budget}';
  return MealPlan(description: description);
});

// Dummy training program provider – in a real app, integrate AI logic here.
final trainingProgramProvider = Provider<TrainingProgram>((ref) {
  final profile = ref.watch(ebotProvider);
  final description =
      'Training Program:\nGym Frequency: ${profile.gymFrequency}\nWeight: ${profile.weight}, Height: ${profile.height}';
  return TrainingProgram(description: description);
});
