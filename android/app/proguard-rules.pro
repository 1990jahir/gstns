# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.plugins.** { *; }

# JSON Serializable & Models
-keepattributes *Annotation*,Signature,Exception
-keep class com.gsts.new_code.** { *; }

# Play Core (optional Flutter deferred components)
-dontwarn com.google.android.play.core.**

