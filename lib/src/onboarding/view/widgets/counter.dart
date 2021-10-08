import 'package:agri_tech_app/src/onboarding/cubit/onboarding_cubit.dart';
import 'package:agri_tech_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class Counter extends StatelessWidget {
  const Counter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return NumberInputPrefabbed.roundedButtons(
          decIconColor: Colors.white,
          incIconColor: Colors.white,
          controller: TextEditingController(),
          incDecBgColor: theme.primaryColor,
          onIncrement: (num newlyIncrementedValue) {
            context
                .read<OnboardingCubit>()
                .familyMemberCountChange(newlyIncrementedValue);
            print('Newly incremented value is $newlyIncrementedValue');
          },
          onDecrement: (num newlyDecrementedValue) {
            context
                .read<OnboardingCubit>()
                .familyMemberCountChange(newlyDecrementedValue);
            print('Newly decremented value is $newlyDecrementedValue');
          },
          onChanged: (num newlyDecrementedValue) {
            context
                .read<OnboardingCubit>()
                .familyMemberCountChange(newlyDecrementedValue);
            print('Newly decremented value is $newlyDecrementedValue');
          },
          buttonArrangement: ButtonArrangement.incRightDecLeft,
        );
      },
    );
  }
}
