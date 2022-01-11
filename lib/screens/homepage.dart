import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spnc/screens/saveimage.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;
  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CameraController _cameraController;
  late final Future _initializeControllerFuture;
  bool _flash = false;

  @override
  void initState() {
    _cameraController = CameraController(widget.camera, ResolutionPreset.max);
    _setFlashMode(_flash);
    _initializeControllerFuture = _cameraController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("SPNC"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _flash = !_flash;
                  });
                  _setFlashMode(_flash);
                },
                icon: Icon(
                  _flash ? Icons.flash_on : Icons.flash_off,
                ))
          ]),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? CameraPreview(_cameraController)
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _cameraController.takePicture();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SaveImageScreen(file: File(image.path))));
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                content: Text(
                    "Something went wrong")));
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _setFlashMode(bool mode) {
    mode
        ? _cameraController.setFlashMode(FlashMode.always)
        : _cameraController.setFlashMode(FlashMode.off);
  }
}
