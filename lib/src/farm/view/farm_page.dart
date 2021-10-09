import 'package:agri_tech_app/src/common/repository/firebase_repository.dart';
import 'package:agri_tech_app/src/farm/models/farm.dart';
import 'package:agri_tech_app/src/farm/models/vegetable.dart';
import 'package:agri_tech_app/src/planting/planting_page.dart';
import 'package:agri_tech_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

class FarmPage extends StatefulWidget {
  final Farm farm;

  FarmPage({required this.farm});

  @override
  _FarmPageState createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  // final Farm farm;

  // FarmPage({required this.farm});
  List<Vegetable> vegetables = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;

    List<DocumentSnapshot> vegetableSnapshots;
    final Repository repository = Repository<Vegetable>('vegetables');

    debugPrint('Data $vegetables');
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: repository.getStream(),
            builder: (context, snapshot) {
              loading = true;
              if (!snapshot.hasData) return const LinearProgressIndicator();
              vegetableSnapshots = snapshot.data?.docs ?? [];
              final allVegetables = vegetableSnapshots
                  .map((e) => Vegetable.fromSnapshot(e))
                  .toList();

              vegetables = allVegetables;
              loading = false;
              debugPrint('vegetables $vegetables');

              if (loading) {
                return SpinKitRotatingCircle(
                  color: theme.primaryColor,
                  size: 50.0,
                );
              }

              return FooterView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget.farm.image),
                                  fit: BoxFit.cover)),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: Container(
                              alignment: Alignment(0.0, 2.5),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.farm.image),
                                radius: 60.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Text(
                          widget.farm.name,
                          style: TextStyle(
                              fontSize: 35.0,
                              color: const Color(0xff091f44),
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Thisara Pramuditha',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black45,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: theme.dividerColor,
                          thickness: 1.2,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Text(
                                    'About Farm',
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        color: const Color(0xff091f44),
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    widget.farm.description,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black45,
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      IconButton(
                                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(FontAwesomeIcons.carrot),
                                          color: theme.primaryColor,
                                          onPressed: () {
                                            print("Pressed");
                                          }),
                                      Text(
                                        "9",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      IconButton(
                                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon:
                                              FaIcon(FontAwesomeIcons.calendar),
                                          color: theme.primaryColor,
                                          onPressed: () {
                                            print("Pressed");
                                          }),
                                      Text(
                                        "4",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      IconButton(
                                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                          icon: FaIcon(FontAwesomeIcons.user),
                                          color: theme.primaryColor,
                                          onPressed: () {
                                            print("Pressed");
                                          }),
                                      Text(
                                        "15",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: theme.dividerColor,
                          thickness: 1.2,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Vegetables',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: const Color(0xff091f44),
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                        if (vegetables.length > 0)
                          GridView.count(
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            children: vegetables
                                .map((vegetable) =>
                                    _buildListItem(context, vegetable))
                                .toList(),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
                footer: Footer(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rs. ${widget.farm.price.toString()} per month"),
                          ElevatedButton(
                            key: const Key('loginForm_continue_raisedButton'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              primary: theme.primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return PlantingPage(
                                    vegetables: vegetables,
                                  );
                                }),
                              );
                            },
                            child: const Text('Select Farm'),
                          )
                        ],
                      )),
                ),
                flex: 2,
              );
            }));
  }

  Widget _buildListItem(BuildContext context, Vegetable vegetable) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(vegetable.image), fit: BoxFit.cover)),
      ),
    );
  }
}
