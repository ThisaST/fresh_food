import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

import 'package:agri_tech_app/src/farm/farm_repository.dart';
import 'package:agri_tech_app/src/farm/models/farm.dart';
import 'package:agri_tech_app/src/farm/view/farm_page.dart';
import 'package:agri_tech_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agri_tech_app/src/app/app.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: HomePage());
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Marker> _markers = {};

  List<Farm> availableFarms = [];
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  initState() {
    super.initState();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    debugPrint('$result');
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    final data = (await rootBundle.load(imagePath)).buffer.asUint8List();

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(data, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.green;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.green.withAlpha(200);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    // textPainter.text = TextSpan(
    //   text: '',
    //   style: TextStyle(fontSize: 20.0, color: Colors.white),
    // );

    // textPainter.layout();
    // textPainter.paint(
    //     canvas,
    //     Offset(size.width - tagWidth / 2 - textPainter.width / 2,
    //         tagWidth / 2 - textPainter.height / 2));

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImageFromPath(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final Repository repository = Repository<Farm>('farms');

    CollectionReference farms = FirebaseFirestore.instance.collection('farms');

    StreamSubscription<QuerySnapshot> _currentSubscription;

    List<DocumentSnapshot> farmSnapshots;

    late GoogleMapController mapController;
    Location _location = Location();

    final LatLng _center = const LatLng(6.9271, 79.8612);

    void _onMapCreated(GoogleMapController controller) async {
      mapController = controller;
      final icon = await getMarkerIcon(
          "lib/src/assets/images/barn.png", Size(150.0, 150.0));
      mapController.setMapStyle('''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#523735"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c9b2a6"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#489608"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcd2be"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#ae9e90"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#93817c"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a5b076"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#447530"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fdfcf8"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f8c967"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e9bc62"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e98d58"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#db8555"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#806b63"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8f7d77"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b9d3c2"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#92998d"
      }
    ]
  }
]''');
      setState(() {
        _markers.clear();

        for (final farm in availableFarms) {
          final marker = Marker(
              markerId: MarkerId(farm.name),
              icon: icon,
              position: LatLng(farm.latitude, farm.longitude),
              infoWindow: InfoWindow(
                title: farm.name,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return FarmPage(farm: farm);
                  }),
                );
              });
          _markers[farm.name] = marker;
        }
      });
      // _location.onLocationChanged.listen((l) {
      //   mapController.animateCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
      //     ),
      //   );
      // });
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

            farmSnapshots = snapshot.data?.docs ?? [];
            final farms =
                farmSnapshots.map((e) => Farm.fromSnapshot(e)).toList();

            availableFarms = farms;

            switch (_connectionStatus) {
              case ConnectivityResult.none:
                return SpinKitRotatingCircle(
                  color: theme.primaryColor,
                  size: 50.0,
                );
              case ConnectivityResult.wifi:
              case ConnectivityResult.mobile:
              default:
                return Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                      myLocationEnabled: true,
                      markers: _markers.values.toSet(),
                    ),
                    Positioned(
                        child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 600.0),
                        height: 100,
                        child: ListView(
                          children: [
                            Container(
                              width: 160.0,
                              color: Colors.red,
                            ),
                            Container(
                              width: 160.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ))
                  ],
                );
            }
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
