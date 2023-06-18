import 'dart:developer';
// import 'dart:html';
import 'dart:io';

import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Constants/map.dart';
import 'package:chating_app/Models/UIHelper.dart';
// import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
// import 'package:chating_app/ShowImage.dart';
// import 'package:chating_app/models/ChatRoomModel.dart';
// import 'package:chating_app/models/FirebaseHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'PhotoViewPage.dart';

class MyLocationPage extends StatefulWidget {
  final UserModel userModel;
  final User FirebaseUser;
  const MyLocationPage({
    Key? key,
    required this.userModel,
    required this.FirebaseUser,
  }) : super(key: key);

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  double ___opacityValue = 0;
  File? imageFile;
  String longitude = "00.00000";
  String latitude = "00.0000";
  String altitude = "00.0000";
  // final lat = 0;
  // final long = 0;
  //

  Future<Position> getCurrentPosition() async {
    // Position currentPosition;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      //
      print("Permission Denied");
      //
      // LocationPermission asked = await Geolocator.requestPermission();
      return Future.error("Permission denied");
      //
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      //
      log("latitude:" + currentPosition.latitude.toString());
      log("longitude:" + currentPosition.longitude.toString());
      log("altitude:" + currentPosition.altitude.toString());
      //
      latitude = currentPosition.latitude.toStringAsFixed(6);
      longitude = currentPosition.longitude.toStringAsFixed(6);
      altitude = currentPosition.altitude.toStringAsFixed(6);
      // // double x = double.parse(latitude);
      // final lat = double.parse(latitude);
      // final long = double.parse(longitude);
      ___opacityValue = 1;
      //
      setState(() {});
      return currentPosition;
    }

    //
  }

  @override
  void initState() {
    super.initState();
    log("Inside My ProfilePage");
    MyLocation.storeCurrentPosition(widget.userModel.uid!);
    _addMarker();
  }

  // List<UserModel>? FriendsList = [];

  //
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 10,
    ));
    //
//
    //
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
        checkValues();
      });
    } else {
      //
    }
  }

  void checkValues() {
    if (imageFile == null) {
      UIHelper.showAlertDialog(context, "Incomplete Data",
          "Please fill all the fields and upload a profile picture");
    } else {
      log("Uploading data..");
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask? uploadTask;
    UIHelper.showLoadingDialog(context, "Uploading image..");
    try {
      uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);
    } on FirebaseException catch (error) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error Ocurred", error.message.toString());
    }
    if (uploadTask != null) {
      TaskSnapshot snapshot = await uploadTask;

      String? imageUrl = await snapshot.ref.getDownloadURL();

      widget.userModel.profilepic = imageUrl;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .set(widget.userModel.toMap())
          .then((value) {
        log("Data uploaded!");
        Navigator.pop(context);
      });
    } else {}
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.dark
                    ? Colors.black
                    : Colors.blue[200],
            title: Text("Change Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PhotoView(
                          userModel: widget.userModel,
                        );
                      },
                    ));
                  },
                  leading: Icon(Icons.image),
                  title: Text("View profile picture"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // ChatRoomProvider myProvider =
    //     Provider.of<ChatRoomProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          elevation: 10,
          shadowColor: Color.fromARGB(255, 91, 35, 15),
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: -7,
                      offset: Offset(5, 5),
                      blurRadius: 20,
                    )
                  ],
                )),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.blue[200],
          title: Text(
            "My Location",
            style: MeroStyle.getStyle(26),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) => _googleMapController = controller,
              initialCameraPosition: CameraPosition(
                  target: LatLng(27.682001, 85.319553), zoom: 20),
              mapType: _currentMapType,
              markers: _markers,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 172, 48, 6),
                  onPressed: _changeMapType,
                  child: Icon(Icons.map, size: 30),
                  tooltip: "Change Map Type",
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 10),
                child: Container(
                  // constraints: BoxConstraints(maxWidth: 100),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 2, 37, 66).withOpacity(1),
                        spreadRadius: -7,
                        offset: Offset(4, 6),
                        blurRadius: 15,
                      ),
                      // BoxShadow(
                      //   color: Colors.white.withOpacity(1),
                      //   spreadRadius: 2,
                      //   offset: Offset(-4, -8),
                      //   blurRadius: 8,
                      // )
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    label: Text(
                      "Your Location",
                      style: MeroStyle.getStyle(20),
                    ),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () async {
                      Position position = await getCurrentPosition();
                      _googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 30)));
                      setState(() {});
                      var marker = Marker(
                        markerId: MarkerId("defaultLocation"),
                        position: LatLng(position.latitude, position.longitude),
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: InfoWindow(
                          title: widget.userModel.fullname,
                          snippet: "You are here right now",
                        ),
                      );
                      _markers
                        ..clear()
                        ..add(marker);
                      setState(() {});
                      // _markers.clear();
                      log(FriendsList.length.toString());
                      for (var index = 0; index < FriendsList.length; index++) {
                        UserModel? targetUser = FriendsList.elementAt(index);
                        double lat = double.parse(
                            targetUser.location!.values.elementAt(0));
                        double long = double.parse(
                            targetUser.location!.values.elementAt(1));
                        log(targetUser.fullname.toString() +
                            " : " +
                            lat.toString() +
                            "  " +
                            long.toString());
                        var newmarker = Marker(
                          markerId: MarkerId("${targetUser.uid}"),
                          position: LatLng(lat, long),
                          icon: BitmapDescriptor.defaultMarker,
                          infoWindow: InfoWindow(
                            title: targetUser.fullname,
                            // snippet: "",
                          ),
                        );
                        _markers.add(newmarker);
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      // BoxShadow(
                      //   color:
                      //       Color.fromARGB(255, 143, 190, 228).withOpacity(1),
                      //   spreadRadius: -7,
                      //   offset: Offset(4, 6),
                      //   blurRadius: 15,
                      // ),
                      BoxShadow(
                        color: Color.fromARGB(255, 9, 9, 9).withOpacity(1),
                        spreadRadius: -7,
                        offset: Offset(-4, 8),
                        blurRadius: 30,
                      )
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    backgroundColor: Color.fromARGB(255, 27, 106, 210),
                    onPressed: _moveToPulchowkCampus,
                    label: Text(
                      "GO TO IOE",
                      style: MeroStyle.getStyle(18),
                    ),
                    // tooltip: "Change Map Type",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final GoogleMapController _googleMapController;
  Future<void> _moveToPulchowkCampus() async {
    const pulchowkPosition = LatLng(27.682001, 85.319553);
    _googleMapController
        .animateCamera(CameraUpdate.newLatLng(pulchowkPosition));
    setState(() {});
    const marker = Marker(
      markerId: MarkerId("PulchowkCampus"),
      position: pulchowkPosition,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(
        title: "Lalitpur, Patan",
        snippet: "Pulchowk Campus",
      ),
    );
    _markers
      ..clear()
      ..add(marker);
  }

  // Future<void> _moveToDefaultLocation() async {
  //   const _defaultLocation = LatLng(27.685301, 83.271650);
  // }

  void _addMarker() {
    // setState(() {});
    _markers
      ..clear()
      ..add(
        Marker(
          markerId: MarkerId("defaultLocation"),
          position: _defaultLocation.target,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: "Lalitpur, Patan",
            snippet: "Pulchowk Campus",
          ),
        ),
      );
    setState(() {});
  }

  MapType _currentMapType = MapType.normal;
  //
  final Set<Marker> _markers = {};
  // double num = 0;
  // static double lat = 27.685301;
  // static double long = 83.271650;

  CameraPosition _defaultLocation =
      CameraPosition(target: LatLng(27.682001, 85.319553), zoom: 20);

  _changeMapType() {
    setState(() {});
    _currentMapType =
        _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
  }
}
