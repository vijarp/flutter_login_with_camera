import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as img;

Future<bool> matchFaces(File storedImage, File liveImage) async {
  final FirebaseVisionImage storedVisionImage = FirebaseVisionImage.fromFile(storedImage);
  final FirebaseVisionImage liveVisionImage = FirebaseVisionImage.fromFile(liveImage);

  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableLandmarks: true,
    enableClassification: true,
  ));

  final List<Face> storedFaces = await faceDetector.processImage(storedVisionImage);
  final List<Face> liveFaces = await faceDetector.processImage(liveVisionImage);

  if (storedFaces.isNotEmpty && liveFaces.isNotEmpty) {
    final Face storedFace = storedFaces.first;
    final Face liveFace = liveFaces.first;

    // Simple comparison using bounding box sizes
    final double storedWidth = storedFace.boundingBox.width;
    final double storedHeight = storedFace.boundingBox.height;
    final double liveWidth = liveFace.boundingBox.width;
    final double liveHeight = liveFace.boundingBox.height;

    final double widthDifference = (storedWidth - liveWidth).abs();
    final double heightDifference = (storedHeight - liveHeight).abs();

    if (widthDifference < 10 && heightDifference < 10) {
      return true;
    }
  }
  return false;
}
