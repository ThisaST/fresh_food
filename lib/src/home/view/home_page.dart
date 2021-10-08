import 'dart:async';
import 'dart:developer';

import 'package:agri_tech_app/src/farm/farm_repository.dart';
import 'package:agri_tech_app/src/farm/models/farm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agri_tech_app/src/app/app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final Repository repository = Repository<Farm>('farms');

    CollectionReference farms = FirebaseFirestore.instance.collection('farms');

    StreamSubscription<QuerySnapshot> _currentSubscription;

    debugPrint('movieTitle: $farms');

    late GoogleMapController mapController;

    final LatLng _center = const LatLng(45.521563, -122.677433);

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    // final  snapshots = loadAllRestaurants().map((snap) => Farm.fromSnapshot(snap));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      // body: GoogleMap(
      //   onMapCreated: _onMapCreated,
      //   initialCameraPosition: CameraPosition(
      //     target: _center,
      //     zoom: 11.0,
      //   ),
      // ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const LinearProgressIndicator();

            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              myLocationEnabled: true,
            );
          }),
      // body: Align(
      //   alignment: const Alignment(0, -1 / 3),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       Avatar(photo: user.photo),
      //       const SizedBox(height: 4),
      //       Text(user.email ?? '', style: textTheme.headline6),
      //       const SizedBox(height: 4),
      //       Text(user.name ?? '', style: textTheme.headline5),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final farm = Farm.fromSnapshot(snapshot);
    final boldStyle =
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    return Card(
        child: InkWell(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(farm.id ?? 'Test', style: boldStyle),
            ),
          ),
        ],
      ),
    ));
  }
}
