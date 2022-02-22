import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:yomikun/ocr/utilities/text_detector_painter.dart';
import 'package:yomikun/ocr/widgets/camera_view.dart';

final availableCamerasProvider =
    Provider<List<CameraDescription>>((_) => throw UnimplementedError());

/// Page that shows a camera (or select photo from gallery) and performs OCR
/// using Google ML Kit. This OCR result can then be sent to the name lookup.
class OcrPage extends StatefulWidget {
  static const String routeName = '/ocr';

  @override
  OcrPageState createState() => OcrPageState();
}

class OcrPageState extends State<OcrPage> {
  TextDetectorV2 textDetector = GoogleMlKit.vision.textDetectorV2();
  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraView(
        title: 'OCR',
        customPaint: customPaint,
        onImage: processImage,
      ),
    );
  }

  void processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(inputImage,
        script: TextRecognitionOptions.JAPANESE);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextDetectorPainter(
          recognisedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

class OcrResultPage extends StatelessWidget {
  final String imagePath;

  const OcrResultPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR result'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Result: $imagePath'),
            Expanded(child: Image.file(File(imagePath))),
          ],
        ),
      ),
    );
  }
}
