# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Ignore missing Play Core classes referenced by Flutter Core
-dontwarn com.google.android.play.core.**

# Workmanager & Room Database (Fixes WorkDatabase_Impl crash)
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
-keep class androidx.room.** { *; }
-dontwarn androidx.room.**
-keep class * extends androidx.room.RoomDatabase { *; }

# Isar Database
-keep class io.isar.** { *; }
-keep class org.isar.** { *; }
-dontwarn io.isar.**
-dontwarn org.isar.**
