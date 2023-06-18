import 'dart:developer';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';

String? longitude;
String? latitude;
String? altitude;
List<UserModel> FriendsList = [];

class MyFriends {
  static addToFriends(UserModel targetUser) {
    // FriendsList.clear();
    FriendsList.add(targetUser);
    // log(FriendsList.length.toString());
  }
}

class MyLocation {
  static storeCurrentPosition(String documentId) async {
    log("location is fetching");
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
      Position _yourcurrentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      //
      log("Current latitude: " + _yourcurrentPosition.latitude.toString());
      log("Current longitude: " + _yourcurrentPosition.longitude.toString());
      log("Current altitude: " + _yourcurrentPosition.altitude.toString());
      //
      latitude = _yourcurrentPosition.latitude.toStringAsFixed(6);
      longitude = _yourcurrentPosition.longitude.toStringAsFixed(6);
      altitude = _yourcurrentPosition.altitude.toStringAsFixed(6);
    }
    //
    //

    await FirebaseFirestore.instance
        .collection("users")
        .doc(documentId)
        .update({
      "location": {
        "latitude": latitude,
        "longitude": longitude,
      }
    }).then((value) => log("Location updated Successfully"));

    //
  }
}
