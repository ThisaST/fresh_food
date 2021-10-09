import 'package:agri_tech_app/src/main_page/main_page.dart';
import 'package:agri_tech_app/src/onboarding/view/onboarding_page.dart';
import 'package:flutter/widgets.dart';
import 'package:agri_tech_app/src/app/app.dart';
import 'package:agri_tech_app/src/login/login.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [OnboardingPage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
