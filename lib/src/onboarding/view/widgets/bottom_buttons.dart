import 'package:agri_tech_app/src/common/repository/firebase_repository.dart';
import 'package:agri_tech_app/src/main_page/main_page.dart';
import 'package:agri_tech_app/src/onboarding/cubit/onboarding_cubit.dart';
import 'package:agri_tech_app/src/onboarding/models/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomButtons extends StatelessWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const BottomButtons(
      {Key? key,
      required this.currentIndex,
      required this.dataLength,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;
    final Repository repository = Repository<UserPreference>('userPreferences');
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: currentIndex == dataLength - 1
              ? [
                  Expanded(
                    child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          maxHeight: 70.0,
                        ),
                        child: FlatButton(
                            onPressed: () {
                              var firebaseUser =
                                  FirebaseAuth.instance.currentUser;
                              print(firebaseUser);
                              firestoreInstance
                                  .collection("userPreferences")
                                  .doc(firebaseUser!.uid)
                                  .set({
                                "familyMembersCount": state.familyMembersCount,
                                "selectedDiet": state.diet,
                              }).then((_) {
                                print("success!");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return MainPage();
                                  }),
                                );
                              });
                            },
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.1,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap, // add this
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide.none),
                            child: Container(
                                child: Text(
                              "Get Started",
                              style: Theme.of(context).textTheme.button,
                            )))),
                  )
                ]
              : [
                  TextButton(
                    onPressed: () {
                      controller.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      "Back",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        child: Text(
                          "Next",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
        );
      },
    );
  }
}
