import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agri_tech_app/src/app/app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FarmPage extends StatelessWidget {
  const FarmPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: FarmPage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: const Icon(Icons.exit_to_app),
              onPressed: () =>
                  context.read<AppBloc>().add(AppLogoutRequested()),
            )
          ],
        ),
        body: Center(
          child: Container(
            height: 120.0,
            width: 120.0,
            color: Colors.blue[50],
            child: const Align(
              alignment: Alignment.topRight,
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
        ));
  }
}
