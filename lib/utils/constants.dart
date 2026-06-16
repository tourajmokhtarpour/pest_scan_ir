import 'package:flutter/material.dart';

class AppConstants {
  // رنگ‌ها
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFF8BC34A);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color errorColor = Color(0xFFCF6679);
  
  // متن‌ها
  static const String appName = 'تشخیص آفات';
  static const String appVersion = 'QUARANTINE SHIELD v3.1';
  static const String modelFile = 'assets/models/best_saved_model.tflite';
  
  // تنظیمات مدل
  static const double confidenceThreshold = 0.5;
  static const int imageWidth = 224;
  static const int imageHeight = 224;
  static const int numClasses = 40;
  
  // لیست کلاس‌های آفات
  static const List<String> pestClasses = [
    'Adoxophyes orana',
    'Amrasca biguttula',
    'Anastrepha ludens',
    'Anastrepha suspensa',
    'Anoplophora chinensis',
    'Anoplophora glabripennis',
    'Bactrocera cucurbitae',
    'Bactrocera dorsalis',
    'Bactrocera papayae',
    'Bactrocera tryoni',
    'Blitopertha orientalis',
    'Cacoecimorpha pronubana',
    'Ceratitis cosyra',
    'Cicadulina mbila',
    'Conotrachelus nenuphar',
    'Cosmopolites sordidus',
    'Cryptoblabes gnidiella',
    'Dendroctonus micans',
    'Diatraea saccharalis',
    'Earias fabia',
    'Epiphyas postvittana',
    'Epitrix tuberis',
    'Eudocima fullonia',
    'Gilpinia hercyniae',
    'Gonipterus scutellatus',
    'Helicoverpa zea',
    'Liriomyza huidobrensis',
    'Lymantria monacha',
    'Monochamus alternatus',
    'Monochamus urussovi',
    'Perkinsiella saccharicida',
    'Pissodes castaneus',
    'Popillia japonica',
    'Prays oleae',
    'Pristiphora abietina',
    'Spodoptera eridania',
    'Spodoptera frugiperda',
    'Sternochetus mangiferae',
    'Thaumetopoea pityocampa',
    'Viteus vitifoliae',
  ];
}