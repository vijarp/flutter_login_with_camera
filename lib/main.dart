import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'camera_capture_screen.dart';
import 'face_recognition.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late File _storedImage;

  @override
  void initState() {
    super.initState();
    _loadStoredImage();
  }

  void _loadStoredImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    setState(() {
      _storedImage = File('$path/a1.jpg');
    });
  }

  void _captureAndMatchFace() async {
    final liveImage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraCaptureScreen()),
    );

    if (liveImage != null) {
      final isMatch = await matchFaces(_storedImage, liveImage);
      if (isMatch) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Face Match Successful!')));
        // Proceed to next screen or login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Face Match Failed!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _storedImage != null
                ? Image.file(_storedImage, height: 200)
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureAndMatchFace,
              child: Text('Login with Face ID'),
            ),
          ],
        ),
      ),
    );
  }
}
