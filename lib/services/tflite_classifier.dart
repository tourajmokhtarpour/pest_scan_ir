import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../utils/constants.dart';

class TFLiteClassifier {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      final options = InterpreterOptions()..threads = 4;
      
      _interpreter = await Interpreter.fromAsset(
        AppConstants.modelFile,
        options: options,
      );
      
      _isModelLoaded = true;
      print('✅ مدل با موفقیت بارگذاری شد');
      
      // چاپ شکل ورودی و خروجی
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      print('📥 شکل ورودی: $inputShape');
      print('📤 شکل خروجی: $outputShape');
      
    } catch (e) {
      print('❌ خطا در بارگذاری مدل: $e');
      _isModelLoaded = false;
    }
  }

  Future<Map<String, dynamic>?> classifyImage(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      await loadModel();
    }

    if (!_isModelLoaded || _interpreter == null) {
      return null;
    }

    try {
      // پردازش تصویر
      final input = await _processImage(imageFile);
      
      // دریافت شکل‌ها
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);
      
      final inputShape = inputTensor.shape;
      final outputShape = outputTensor.shape;
      
      print('🔍 شکل ورودی مدل: $inputShape');
      print('🔍 شکل خروجی مدل: $outputShape');
      
      // آماده‌سازی خروجی
      final outputSize = outputShape.reduce((a, b) => a * b);
      var outputBuffer = List.filled(outputSize, 0.0);
      
      // اجرای مدل
      _interpreter!.run(input, [outputBuffer]);
      
      // یافتن کلاس با بیشترین احتمال
      double maxProbability = 0;
      int predictedClass = 0;
      
      for (int i = 0; i < outputSize; i++) {
        if (outputBuffer[i] > maxProbability) {
          maxProbability = outputBuffer[i];
          predictedClass = i;
        }
      }
      
      print('🎯 کلاس پیش‌بینی شده: $predictedClass');
      print('📊 اطمینان: ${maxProbability.toStringAsFixed(4)}');
      
      return {
        'classId': predictedClass,
        'confidence': maxProbability,
        'probabilities': outputBuffer,
      };
    } catch (e) {
      print('❌ خطا در طبقه‌بندی: $e');
      return null;
    }
  }

  Future<List<List<List<List<double>>>>> _processImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('تصویر نامعتبر است');
    }
    
    // تغییر اندازه به 224x224
    final resized = img.copyResize(
      image,
      width: AppConstants.imageWidth,
      height: AppConstants.imageHeight,
    );
    
    // ایجاد تنسور ورودی [1, 224, 224, 3]
    final input = List.generate(
      1,
      (_) => List.generate(
        AppConstants.imageHeight,
        (y) => List.generate(
          AppConstants.imageWidth,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              (img.getRed(pixel) - 127.5) / 127.5,
              (img.getGreen(pixel) - 127.5) / 127.5,
              (img.getBlue(pixel) - 127.5) / 127.5,
            ];
          },
        ),
      ),
    );
    
    return input;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
  }
}