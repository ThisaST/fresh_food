import 'package:agri_tech_app/theme.dart';
import 'package:flutter/material.dart';

import 'widgets/bottom_buttons.dart';
import 'widgets/explanation.dart';

final List<ExplanationData> data = [
  ExplanationData(
      description: "",
      title: "How many in your Family?",
      localImageSrc: "lib/src/assets/svg/one.svg",
      backgroundColor: theme.primaryColorLight,
      showCounter: true),
  ExplanationData(
      description: "",
      title: "Do you have a specific diet?",
      localImageSrc: "lib/src/assets/svg/foods.svg",
      backgroundColor: theme.primaryColorLight,
      showCounter: false),
  ExplanationData(
      description: "",
      title: "Done",
      localImageSrc: "lib/src/assets/svg/done.svg",
      backgroundColor: theme.primaryColorLight,
      showCounter: false),
];

class OnboardingPage extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: OnboardingPage());
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState
    extends State<OnboardingPage> /*with ChangeNotifier*/ {
  final _controller = PageController();

  int _currentIndex = 0;

  // OpenPainter _painter = OpenPainter(3, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: data[_currentIndex].backgroundColor,
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(16),
          color: data[_currentIndex].backgroundColor,
          alignment: Alignment.center,
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: PageView(
                              scrollDirection: Axis.horizontal,
                              controller: _controller,
                              onPageChanged: (value) {
                                // _painter.changeIndex(value);
                                setState(() {
                                  _currentIndex = value;
                                });
                                // notifyListeners();
                              },
                              children: data
                                  .map((e) => ExplanationPage(data: e))
                                  .toList())),
                      flex: 4),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(data.length,
                                    (index) => createCircle(index: index)),
                              )),
                          BottomButtons(
                            currentIndex: _currentIndex,
                            dataLength: data.length,
                            controller: _controller,
                          )
                        ],
                      ))
                ],
              ),
            )
          ]),
        )));
  }

  createCircle({required int index}) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 100),
        margin: EdgeInsets.only(right: 4),
        height: 5,
        width: _currentIndex == index ? 15 : 5,
        decoration: BoxDecoration(
            color: theme.primaryColor, borderRadius: BorderRadius.circular(3)));
  }
}
