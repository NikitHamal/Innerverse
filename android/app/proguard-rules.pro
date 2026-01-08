# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelables
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# Drift/SQLite
-keep class drift.** { *; }
-keep class org.sqlite.** { *; }

# Local Auth
-keep class androidx.biometric.** { *; }

# Just Audio
-keep class com.google.android.exoplayer.** { *; }
-keep class com.google.android.exoplayer2.** { *; }

# Secure Storage
-keep class io.flutter.plugins.flutter_secure_storage.** { *; }
