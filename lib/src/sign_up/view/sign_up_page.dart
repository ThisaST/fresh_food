import 'package:agri_tech_app/src/common/widgets/bezier_widget.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agri_tech_app/src/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
        body: Stack(
          children: [
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: BlocProvider<SignUpCubit>(
                create: (_) =>
                    SignUpCubit(context.read<AuthenticationRepository>()),
                child: const SignUpForm(),
              ),
            ),
          ],
        ));
  }
}
