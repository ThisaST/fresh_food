import 'package:agri_tech_app/src/farm/models/vegetable.dart';
import 'package:agri_tech_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PlantingPage extends StatefulWidget {
  final List<Vegetable> vegetables;

  PlantingPage({Key? key, required this.vegetables}) : super(key: key);

  @override
  _PlantingPageState createState() => _PlantingPageState();
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class _PlantingPageState extends State<PlantingPage> {
  List<MultiSelectItem<Vegetable>> vegetables = [];
  List<Vegetable> selectedVegetables = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    debugPrint('AIO ${widget.vegetables.toString()}');
    vegetables = widget.vegetables
        .map((vegetable) =>
            MultiSelectItem<Vegetable>(vegetable, vegetable.name))
        .toList();
    selectedVegetables = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AIO ${widget.vegetables.toString()}');
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(children: <Widget>[
            Image.asset(
              "lib/src/assets/images/vegetables.jpg",
              height: 220,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 10),
              child: Text(
                "VEGETABLES",
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 120, horizontal: 10),
            //   child: Text(
            //     "Select Vegetables to Grow",
            //     style: TextStyle(
            //         fontSize: 20.0,
            //         color: Colors.white,
            //         fontWeight: FontWeight.w700),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ]),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: theme.primaryColorLight,
                border: Border(top: BorderSide(color: theme.primaryColor))),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Seasonal Vegetables",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: const Color(0xff091f44),
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          key: const Key(''),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            primary: theme.primaryColor,
                          ),
                          child: Text(
                            'Add all',
                            style: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    )),
                MultiSelectChipField<Vegetable>(
                  items: vegetables,
                  showHeader: false,
                  initialValue: [],
                  scroll: false,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border:
                        Border.all(color: theme.primaryColorLight, width: 1.8),
                  ),
                  selectedChipColor: Colors.blue.withOpacity(0.5),
                  selectedTextStyle: TextStyle(color: Colors.blue[800]),
                  onTap: (values) {
                    //_selectedAnimals4 = values;
                  },
                  itemBuilder: (item, state) {
                    // return your custom widget here
                    return InkWell(
                        onTap: () {
                          selectedVegetables.contains(item.value)
                              ? selectedVegetables.remove(item.value)
                              : selectedVegetables.add(item.value);
                          state.didChange(selectedVegetables);
                        },
                        child: Container(
                          width: 98,
                          height: 100,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item.value.image),
                                  fit: BoxFit.cover)),
                          // child: Card(
                          //   child: Padding(
                          //     padding: EdgeInsets.symmetric(
                          //         vertical: 4.0, horizontal: 4.0),
                          //     child: Column(
                          //       children: [
                          //         Text(item.value.name),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            key: const Key('start_planting'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              primary: theme.primaryColor,
            ),
            child: Text(
              'Start Planting ${selectedVegetables.length}/${vegetables.length}',
              style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      )),
    );
  }
}
