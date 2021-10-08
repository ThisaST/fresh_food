import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void familyMemberCountChange(num value) {
    final familyMembersCount = value;
    emit(state.copyWith(familyMembersCount: familyMembersCount));
  }

  void dietChange(String value) {
    final diet = value;
    emit(state.copyWith(diet: diet));
  }

  // Future<void> updateUserPreferences() async {
  //   try {
  //     await _authenticationRepository.logInWithGoogle();
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } catch (_) {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }
}
