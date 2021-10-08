import 'package:agri_tech_app/src/onboarding/cubit/onboarding_cubit.dart';
import 'package:agri_tech_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'counter.dart';
import 'multi_select.dart';

class ExplanationData {
  final String title;
  final String description;
  final String localImageSrc;
  final Color backgroundColor;
  final bool showCounter;

  ExplanationData(
      {required this.title,
      required this.description,
      required this.localImageSrc,
      required this.backgroundColor,
      this.showCounter = false});
}

class Diet {
  final int id;
  final String name;

  Diet({
    required this.id,
    required this.name,
  });
}

class ExplanationPage extends StatelessWidget {
  final ExplanationData data;

  ExplanationPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.primaryColorLight,
          body: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 24, bottom: 16),
                  child: SvgPicture.asset(data.localImageSrc,
                      height: MediaQuery.of(context).size.height * 0.33,
                      alignment: Alignment.center)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
                          data.description,
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              ),
              if (data.showCounter) Container(child: Counter()),
              // MyHomePage(title: 'Flutter Multi Select')
            ],
          ),
        );
      },
    );
  }
}
