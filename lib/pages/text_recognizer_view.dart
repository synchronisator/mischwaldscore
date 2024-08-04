import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mischwaldscore/pages/add_dialog.dart';
import 'package:mischwaldscore/pages/cameraview.dart';
import 'package:mischwaldscore/pages/card.dart';
import 'package:mischwaldscore/pages/cards.dart';
import 'package:mischwaldscore/pages/textrecognizerpainter.dart';
import 'package:mischwaldscore/provider/gameprovider.dart';
import 'package:mischwaldscore/provider/player.dart';
import 'package:provider/provider.dart';

class TextRecognizerView extends StatefulWidget {
  final Player player;

  const TextRecognizerView(this.player, {super.key});

  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  final _cameraLensDirection = CameraLensDirection.back;

  TreeDecision decision = TreeDecision();
  bool scanning = false;
  String timetext = "3";
  Duration timeTextDuration = Duration.zero;
  double timeTextScale = 0;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          decision = TreeDecision();
          scanning = true;
          timetext = "3";
          timeTextDuration = Duration.zero;
          timeTextScale = 10;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 10));
          timeTextDuration = const Duration(milliseconds: 900);
          timeTextScale = 0;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 990));


          timetext = "2";
          timeTextDuration = Duration.zero;
          timeTextScale = 10;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 10));
          timeTextDuration = const Duration(milliseconds: 900);
          timeTextScale = 0;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 990));


          timetext = "1";
          timeTextDuration = Duration.zero;
          timeTextScale = 10;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 10));
          timeTextDuration = const Duration(milliseconds: 900);
          timeTextScale = 0;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 990))


          //TODO Animation
          // await Future.delayed(const Duration(seconds: 3))
              .then((value) {
            scanning = false;
            return showDialog<Widget>(
              context: context,
              builder: (_) {
                return AddTreeDialog(decision);
              },
            );
          })
              .then((value) => setState(() {}));
        },
        child: const Icon(Icons.camera_alt),
      ),
      body: Stack(children: [
        CameraView(
          customPaint: _customPaint,
          onImage: _processImage,
          onCameraFeedReady: () => setState(() {}),
        ),
        if(scanning)
        AnimatedScale(
          duration: timeTextDuration,
          scale: timeTextScale,
          child: Center(
            child: Text(timetext),
          ),
        ),
        Positioned(
          top: 40,
          left: 8,
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: FloatingActionButton(
              heroTag: Object(),
              onPressed: () {
                context.read<GameProvider>().notify(); //Hack
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
              ),
            ),
          ),
        ),
    ],
    ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!scanning) return;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {});
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    List<KorrekturBlock> korrekturBlock = recognizedText.blocks
        .map((e) => KorrekturBlock(e.text, e.boundingBox, e.cornerPoints))
        .toList();
    korrekturBlock.removeWhere((element) {
      //Korrektur der Blöcke
      if (element.text == "Hufeisen-" || element.text == "Hufeisen-\nnase") {
        element.text = Cards.Hufeisennase.longname;
      }
      if (element.text == "Braunes" ||
          element.text == "Braunes\nLangohr" ||
          element.text == "Langohr") {
        element.text = Cards.Braunes_Langohr.longname;
      }
      if (element.text == "Sieben-" || element.text == "Sieben-\nschläfer") {
        element.text = Cards.Siebenschlaefer.longname;
      }
      if (element.text == "Mops-" || element.text == "Mops-\nfledermaus") {
        element.text = Cards.Mopsfledermaus.longname;
      }
      if (element.text == "Bechstein-" ||
          element.text == "Bechstein-\nfledermaus") {
        element.text = Cards.Bechsteinfledermaus.longname;
      }
      if (element.text == "murmeltier" ||
          element.text == "Alpen-\nmurmeltier") {
        element.text = Cards.Alpenmurmeltier.longname;
      }
      if (element.text == "Europ. Lärche") {
        element.text = Cards.Europaeische_Laerche.longname;
      }

      return !CardsExtension.asMap().keys.contains(element.text);
    });

    decision.add(korrekturBlock);

    List<TextBlock> bereichsbloecke = [];
    if (decision.mid.isNotEmpty) {
      var mitte =
          korrekturBlock.where((element) => element.text == decision.mid.first);
      if (mitte.isNotEmpty) {
        KorrekturBlock k = mitte.first;
        bereichsbloecke.add(TextBlock(
            text: k.text,
            lines: [],
            boundingBox: k.rect,
            recognizedLanguages: [],
            cornerPoints: k.cornerPoints));

        int h = (k.rect.bottom - k.rect.top).toInt();

        double l = k.rect.topLeft.dx - 10;
        double t = k.rect.topLeft.dy - 40;
        double r = k.rect.topLeft.dx + 40;
        double b = k.rect.topLeft.dy + 20;

        Rect rec = Rect.fromLTRB(l, t, r, b);
        List<Point<int>> cp = [
          Point(k.cornerPoints[0].x - 22 * h, k.cornerPoints[0].y + 4 * h),
          Point(k.cornerPoints[1].x - 22 * h, k.cornerPoints[1].y - 10 * h),
          Point(k.cornerPoints[2].x + 5 * h, k.cornerPoints[2].y - 10 * h),
          Point(k.cornerPoints[3].x + 5 * h, k.cornerPoints[3].y + 4 * h),
        ];
        bereichsbloecke.add(TextBlock(
            text: "Mitte",
            lines: [],
            boundingBox: rec,
            recognizedLanguages: [],
            cornerPoints: cp));
      }
    }

    RecognizedText rt = RecognizedText(text: "text", blocks: bereichsbloecke);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = TextRecognizerPainter(
        rt,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

class KorrekturBlock {
  String text;
  Rect rect;
  List<Point<int>> cornerPoints;

  KorrekturBlock(this.text, this.rect, this.cornerPoints);
}
