class UserProfile {
  final double? weight;
  final double? height;
  final int? gymFrequency;
  final int? mealCount;
  final double? budget;

  UserProfile({
    this.weight,
    this.height,
    this.gymFrequency,
    this.mealCount,
    this.budget,
  });

  UserProfile copyWith({
    double? weight,
    double? height,
    int? gymFrequency,
    int? mealCount,
    double? budget,
  }) {
    return UserProfile(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gymFrequency: gymFrequency ?? this.gymFrequency,
      mealCount: mealCount ?? this.mealCount,
      budget: budget ?? this.budget,
    );
  }
}
