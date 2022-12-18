import 'dart:developer';

import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CaptchaMlService {
  final _modelFile = 'model.tflite';
  late Interpreter _interpreter;

  CaptchaMlService() {
    loadModel();
  }

  void loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelFile);
    log('Interpreter loaded successfully');
  }

  int rgbTo8Bit(int r, int b, int g) {
    return ((r * 6 / 256) * 36 + (g * 6 / 256) * 6 + (b * 6 / 256)).floor();
  }

  List convertToPMode(Image src) {
    List<int> img8 = [];

    for (var bit32 in src.data) {
      var b = getBlue(bit32);
      var r = getRed(bit32);
      var g = getGreen(bit32);
      var color = rgbTo8Bit(r, b, g);

      if (color <= 30) {
        img8.add(0);
      } else {
        img8.add(255);
      }
    }
    List reImg = img8.reshape([src.height, src.width]);
    return reImg;
  }

  List getDigitRegions(List img) {
    int start = 0;
    int end = 0;
    bool inletter = false;
    bool foundletter = false;
    List letterImageRegions = [];
    int maxheight = 0;
    int minheight = 999;
    for (var x = 0; x < img[0].length; x++) {
      for (var y = 0; y < img.length; y++) {
        if (img[y][x] != 255) {
          inletter = true;
          if (y < minheight) {
            minheight = y;
          } else if (y > maxheight) {
            maxheight = y;
          }
        }
      }
      if (foundletter == false && inletter == true) {
        foundletter = true;
        start = x;
      }
      if (foundletter == true && inletter == false) {
        foundletter = false;
        end = x;
        if (end - start >= 33) {
          var mid = ((end - start) / 4).floor();
          minheight = minheight - 1;
          maxheight = maxheight + 1;
          letterImageRegions
              .add([start - 1, minheight, mid + start, maxheight]);
          letterImageRegions
              .add([start + mid, minheight, 2 * mid + start + 3, maxheight]);
          letterImageRegions.add(
              [start + 2 * mid, minheight, 3 * mid + start + 3, maxheight]);
          letterImageRegions
              .add([3 * mid + start, minheight, end + 1, maxheight]);
        } else if (end - start >= 23) {
          minheight = minheight - 1;
          maxheight = maxheight + 1;
          var mid = ((end - start) / 3).floor();
          letterImageRegions
              .add([start - 1, minheight, mid + start, maxheight]);
          letterImageRegions
              .add([start + mid, minheight, 2 * mid + start + 3, maxheight]);
          letterImageRegions
              .add([start + 2 * mid, minheight, end + 1, maxheight]);
        } else if (end - start >= 13) {
          var mid = ((end - start) / 2).floor();
          letterImageRegions
              .add([start - 1, minheight - 1, mid + start, maxheight + 2]);
          letterImageRegions
              .add([mid + start, minheight - 1, end + 1, maxheight + 2]);
        } else {
          letterImageRegions
              .add([start - 2, minheight - 2, end + 2, maxheight + 2]);
        }
        maxheight = 0;
        minheight = 999;
      }

      inletter = false;
    }
    letterImageRegions.sort((a, b) => a[0].compareTo(b[0]));

    return letterImageRegions;
  }

  List getImageFromRegion(List srcImg, List digitRegion) {
    int x1 = digitRegion[0];
    int y1 = digitRegion[1];
    int x2 = digitRegion[2];
    int y2 = digitRegion[3];
    // print(digit);
    int width = x2 - x1;
    int height = y2 - y1;
    List ret = [];
    for (var i = y1; i < y2; i++) //along y axis
    {
      for (var j = x1; j < x2; j++) //along x axis
      {
        ret.add(srcImg[i][j]);
      }
    }
    ret = ret.reshape([height, width]);
    return ret;
  }

  List fitToSize(List img) //resizes img to 20 x 20 by adding white padding
  {
    List<List> ret = List.generate(
        20, (i) => List.generate(20, (i) => 255.0, growable: false),
        growable: false);
    int w = img[0].length;
    int h = img.length;
    int padh = ((20 - h) / 2).floor(); // 2.5
    int padw = ((20 - w) / 2).floor(); // 1.5
    for (int i = padh; i < h + padh; i++) {
      for (int j = padw; j < w + padw; j++) {
        ret[i][j] = img[i - padh][j - padw] * 1.0;
      }
    }
    return ret;
  }

  String? classify(List<int> input) {
    try {
      Image image = decodeImage(input)!;
      List cntImg = convertToPMode(image);
      List textReg = getDigitRegions(cntImg);
      if (textReg.length != 5) {
        return "CANNOT PROCESS CAPTCHA";
      }
      List<List> output = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ];
      String outCap = "";
      for (var i = 0; i < textReg.length; i++) {
        List digit = getImageFromRegion(cntImg, textReg[i]);

        List resizeDig = fitToSize(digit);
        _interpreter.run(resizeDig.reshape([1, 20, 20, 1]), output);

        outCap =
            outCap + output[0].indexWhere((element) => element == 1).toString();
      }
      return outCap;
    } catch (e) {
      log("ML error" + e.toString());
      return "CANNOT PROCESS CAPTCHA";
    }
  }
}
