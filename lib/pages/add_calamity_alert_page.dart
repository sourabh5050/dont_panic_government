import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_panic_government/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';

final _firestore = Firestore.instance;

class AddCalamityList extends StatefulWidget {
  @override
  _AddCalamityListState createState() => _AddCalamityListState();
}

class _AddCalamityListState extends State<AddCalamityList> {
  GoogleMapController _controller;
  Position currentPosition = Position(latitude: 12.9716, longitude: 77.5946);
  bool showSpinner = false;
  int _pickType = 0;
  String news = 'This is a calamity.';
  Uuid uuid = Uuid();
  dropDown() {
    return DropdownButton(
      hint: new Text('Select'),
      value: _pickType,
      items: <DropdownMenuItem>[
        new DropdownMenuItem(
          child: new Text('Nothing'),
          value: 0,
        ),
        new DropdownMenuItem(
          child: new Text('Cyclone'),
          value: 1,
        ),
        new DropdownMenuItem(
          child: new Text('Drought'),
          value: 2,
        ),
        new DropdownMenuItem(
          child: new Text('Earthquake'),
          value: 3,
        ),
        new DropdownMenuItem(
          child: new Text('Tsunami'),
          value: 4,
        ),
        new DropdownMenuItem(
          child: new Text('Epidemic'),
          value: 5,
        ),
        new DropdownMenuItem(
          child: new Text('Wildfire'),
          value: 6,
        ),
        new DropdownMenuItem(
          child: new Text('Flood'),
          value: 7,
        ),
        new DropdownMenuItem(
          child: new Text('Nuclear Disaster'),
          value: 8,
        ),
      ],
      onChanged: (value) => setState(() {
        _pickType = value;
      }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showSpinner = true;
      getCurrentLocation();
    });
    setState(() {
      showSpinner = false;
    });
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  void getCurrentLocation() async {
    Position position;
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position.longitude == null || position.latitude == null) {
      position = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    }
    setState(() {
      currentPosition = position;
    });
    moveCameraToPosition(currentPosition);
  }

  void moveCameraToPosition(Position position) {
    _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
        ),
      ),
    );
  }

  void _updatePosition(CameraPosition _position) {
    Position newPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    print(newPosition.latitude.toString() +
        ',' +
        newPosition.longitude.toString());
    setState(() {
      currentPosition = newPosition;
    });
    moveCameraToPosition(currentPosition);
  }

  getLocationFromAddress(Placemark address) {
    setState(() {
      currentPosition = address.position;
    });
  }

  void getCustomLocation() async {
    Prediction pred = await PlacesAutocomplete.show(
      context: context,
      strictbounds: currentPosition == null ? false : true,
      apiKey: "AIzaSyBe2JYm0NdPeRQlyOxk9HmRymw4WOSwkuM",
      mode: Mode.fullscreen,
      language: "en",
      location: Location(currentPosition.latitude, currentPosition.longitude),
      radius: currentPosition == null ? null : 10000000,
      components: [Component(Component.country, "in")],
    );
    if (pred != null) {
      List<Placemark> plcmrk =
          await Geolocator().placemarkFromAddress(pred.description.toString());
      getLocationFromAddress(plcmrk[0]);
      moveCameraToPosition(currentPosition);
    }
  }

  Widget _getMap() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        compassEnabled: true,
        onMapCreated: (controller) {
          mapCreated(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(12.9716, 77.5946),
          zoom: 15,
        ),
        onCameraMove: ((_position) => _updatePosition(_position)),
        markers: Set.of(<Marker>[
          Marker(
            markerId: MarkerId('currentPos'),
            position:
                LatLng(currentPosition.latitude, currentPosition.longitude),
          ),
        ]),
      ),
    );
  }

  Widget _getMainNewsText() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          alignment: Alignment.center,
          child: TextFormField(
            scrollPadding: EdgeInsets.all(0),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              hintText: 'Major Update',
            ),
            onChanged: (value) {
              setState(() {
                news = value;
              });
            },
          ),
        ),
      ],
    );
  }

  void addCalamityToDb() {
    final new_id = uuid.v1().split('-').join();
    _firestore.collection('calamities').document(new_id).setData({
      'id': new_id,
      'geoLocation':
          GeoPoint(currentPosition.latitude, currentPosition.longitude),
      'calamity code': _pickType,
      'major update': news,
      'timestamp': DateTime.now(),
      'updates': [],
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: mainColor,
          title: Text('Add Calamity'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: <Widget>[
              ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: _getMap(),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.35,
                minChildSize: 0.35,
                maxChildSize: 0.50,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FloatingActionButton(
                                onPressed: () {
                                  getCurrentLocation();
                                },
                                backgroundColor: mainColor,
                                child: Icon(
                                  Icons.my_location,
                                  color: Colors.black,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          //
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: mainColor,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              '(' +
                                                  num.parse(currentPosition
                                                          .latitude
                                                          .toStringAsFixed(4))
                                                      .toString() +
                                                  ',' +
                                                  num.parse(currentPosition
                                                          .longitude
                                                          .toStringAsFixed(4))
                                                      .toString() +
                                                  ')',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          40),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          getCustomLocation();
                                        },
                                        iconSize:
                                            MediaQuery.of(context).size.height /
                                                40,
                                        icon: Icon(
                                          Icons.edit,
                                          color: mainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          'Calamity:',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      dropDown(),
                                    ],
                                  ),
                                ),
                                _getMainNewsText(),
                                RaisedButton(
                                  color: mainColor,
                                  onPressed: () {
                                    addCalamityToDb();
                                  },
                                  child: Text('Submit'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
