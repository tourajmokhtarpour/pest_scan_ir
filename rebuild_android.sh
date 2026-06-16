#!/bin/bash
set -e

echo "🔥 شروع ساخت مجدد پوشه android..."

# 1. حذف پوشه android قدیمی
echo "🗑️ حذف android/ قدیمی..."
rm -rf android/

# 2. بازسازی با flutter create
echo "🔄 بازسازی با flutter create..."
flutter create --platforms=android --org com.pestscan --project-name pest_scan_ir .

# 3. نصب وابستگی‌ها
echo "📦 نصب وابستگی‌ها..."
flutter pub get

# 4. بازنویسی gradle-wrapper.properties (Gradle 8.11.1)
echo "⚙️ تنظیم Gradle 8.11.1..."
cat > android/gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.11.1-all.zip
networkTimeout=10000
validateDistributionUrl=true
EOF

# 5. بازنویسی settings.gradle (AGP 8.9.1)
echo "⚙️ تنظیم AGP 8.9.1..."
cat > android/settings.gradle << 'EOF'
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.9.1" apply false
    id "org.jetbrains.kotlin.android" version "2.0.21" apply false
}

include ":app"
EOF

# 6. بازنویسی build.gradle (سطح پروژه)
echo "⚙️ تنظیم build.gradle (پروژه)..."
cat > android/build.gradle << 'EOF'
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"

subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
EOF

# 7. بازنویسی app/build.gradle (با minSdk=26)
echo "⚙️ تنظیم app/build.gradle با minSdk=26..."
cat > android/app/build.gradle << 'EOF'
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace "com.pestscan.ir"
    compileSdk 35
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.pestscan.ir"
        minSdk 26
        targetSdk 35
        versionCode 1
        versionName "3.1.0"
        
        ndk {
            abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
            minifyEnabled false
            shrinkResources false
        }
    }

    aaptOptions {
        noCompress 'tflite'
    }

    packagingOptions {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:2.0.21"
    implementation "androidx.core:core-ktx:1.15.0"
    implementation "androidx.appcompat:appcompat:1.7.0"
}
EOF

# 8. بازنویسی gradle.properties
echo "⚙️ تنظیم gradle.properties..."
cat > android/gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true
android.nonTransitiveRClass=true
android.nonFinalResIds=false
EOF

# 9. بازنویسی AndroidManifest.xml (با مجوزها)
echo "🔐 تنظیم AndroidManifest.xml با مجوزها..."
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- مجوزهای اینترنت -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- مجوزهای دوربین -->
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <!-- مجوزهای حافظه -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="32"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    
    <!-- ویژگی‌های سخت‌افزاری -->
    <uses-feature android:name="android.hardware.camera" android:required="false"/>
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>

    <application
        android:label="Pest Scan IR"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:enableOnBackInvokedCallback="true"
        android:requestLegacyExternalStorage="true">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <!-- Flutter v2 Embedding -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>

    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>
EOF

# 10. بازنویسی MainActivity.kt
echo "📱 تنظیم MainActivity.kt..."
mkdir -p android/app/src/main/kotlin/com/pestscan/ir
cat > android/app/src/main/kotlin/com/pestscan/ir/MainActivity.kt << 'EOF'
package com.pestscan.ir

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
EOF

# 11. بازنویسی styles.xml
echo "🎨 تنظیم styles.xml..."
mkdir -p android/app/src/main/res/values
cat > android/app/src/main/res/values/styles.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@android:color/white</item>
    </style>
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@android:color/white</item>
    </style>
</resources>
EOF

# 12. ساخت proguard-rules.pro
echo "🛡️ ساخت proguard-rules.pro..."
cat > android/app/proguard-rules.pro << 'EOF'
-keep class org.tensorflow.** { *; }
-keep class com.pestscan.ir.** { *; }
-dontwarn org.tensorflow.**
EOF

# 13. بررسی نهایی
echo ""
echo "========================================="
echo "✅ ✅ ✅ بررسی نهایی ✅ ✅ ✅"
echo "========================================="
echo ""
echo "📱 Embedding Version:"
grep "flutterEmbedding" android/app/src/main/AndroidManifest.xml
echo ""
echo "📱 MainActivity:"
cat android/app/src/main/kotlin/com/pestscan/ir/MainActivity.kt
echo ""
echo "📱 Gradle Version:"
cat android/gradle/wrapper/gradle-wrapper.properties | grep distributionUrl
echo ""
echo "📱 minSdk:"
grep "minSdk" android/app/build.gradle
echo ""
echo "📱 AGP Version:"
cat android/settings.gradle | grep "com.android.application"
echo ""
echo "========================================="
echo "🎉 تمام! پوشه android با موفقیت ساخته شد"
echo "========================================="
echo ""
echo "حالا این دستورات را اجرا کنید:"
echo "1. git add android/"
echo "2. git commit -m \"Rebuild android with v2 embedding\""
echo "3. git push origin main"
echo ""
echo "سپس در CodeMagic build جدید شروع کنید."