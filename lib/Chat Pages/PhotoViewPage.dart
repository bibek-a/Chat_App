import 'package:chating_app/models/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PhotoView extends StatefulWidget {
  final UserModel userModel;
  const PhotoView({Key? key, required this.userModel}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.blue[200],
            image: DecorationImage(
              image: NetworkImage(widget.userModel.profilepic!),
            )),
      ),
    );
  }
}
