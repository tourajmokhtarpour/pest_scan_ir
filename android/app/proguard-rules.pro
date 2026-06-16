# TensorFlow Lite
-keep class org.tensorflow.** { *; }
-keep class com.pestscan.ir.** { *; }
-dontwarn org.tensorflow.**

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.**

# Image Picker
-keep class com.example.imagepicker.** { *; }

# Keep all classes with native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile