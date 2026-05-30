import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}


val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(localPropertiesFile.reader(Charsets.UTF_8))
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"


android {
    namespace = "com.fasttopupagent.woosat"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.fasttopupagent.woosat"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
    }



    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
