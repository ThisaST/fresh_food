import 'package:agri_tech_app/src/main_page/main_page.dart';
import 'package:flutter/widgets.dart';
import 'package:agri_tech_app/src/app/app.dart';
import 'package:agri_tech_app/src/home/home.dart';
import 'package:agri_tech_app/src/login/login.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [MainPage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
