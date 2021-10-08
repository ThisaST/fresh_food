part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState(
      {this.familyMembersCount = 0, this.diet = 'No Specific'});

  final num familyMembersCount;
  final String diet;

  @override
  List<Object> get props => [familyMembersCount, diet];

  OnboardingState copyWith({num? familyMembersCount, String? diet}) {
    return OnboardingState(
      familyMembersCount: familyMembersCount ?? this.familyMembersCount,
      diet: diet ?? this.diet,
    );
  }
}
