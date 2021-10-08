import 'package:agri_tech_app/src/common/widgets/bezier_widget.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agri_tech_app/src/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        // appBar: AppBar(title: const Text('Login')),
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
          child: BlocProvider(
              create: (_) =>
                  LoginCubit(context.read<AuthenticationRepository>()),
              child: const LoginForm()),
        ),
      ],
    ));
  }
}
