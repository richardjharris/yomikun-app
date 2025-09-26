import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/ocr/utilities/text_detector_painter.dart';
import 'package:yomikun/ocr/widgets/camera_view.dart';

/// Page that shows a camera (or select photo from gallery) and performs OCR
/// using Google ML Kit. This OCR result can then be sent to the name lookup.
class OcrPage extends StatefulWidget {
  static const String routeName = '/ocr';

  @override
  OcrPageState createState() => OcrPageState();
}

class OcrPageState extends State<OcrPage> {
  TextRecognizer textDetector =
      TextRecognizer(script: TextRecognitionScript.japanese);
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
      body: cameras.isEmpty
          ? noCameraBox(context)
          : CameraView(
              title: context.loc.ocrPageTitle,
              customPaint: customPaint,
              onImage: processImage,
            ),
    );
  }

  /// Widget displayed when no cameras have been detected.
  Widget noCameraBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.loc.ocrNoCameraDetected),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(context.loc.goBack),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = TextDetectorPainter(
        recognisedText,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
      );
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
