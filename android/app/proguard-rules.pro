# =============================================================================
# Habla AAC — ProGuard / R8 Rules
# Applied to release builds via build.gradle proguardFiles()
# =============================================================================

# ---------------------------------------------------------------------------
# Flutter
# ---------------------------------------------------------------------------

# Flutter keeps its own rules via the Flutter Gradle plugin, but we add
# explicit guards here for clarity and forward-compatibility.

-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.app.** { *; }

# Dart VM / snapshot support
-keep class com.google.android.** { *; }

# Preserve Flutter generated plugin registrant
-keep class com.habla.aac.GeneratedPluginRegistrant { *; }

# ---------------------------------------------------------------------------
# Kotlin / Coroutines
# ---------------------------------------------------------------------------

-keepclassmembers class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# Kotlin serialisation metadata
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keepattributes InnerClasses,EnclosingMethod

# Kotlin Metadata (required for reflection-based libraries)
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

# ---------------------------------------------------------------------------
# Drift (SQLite ORM)
# ---------------------------------------------------------------------------

# Drift generates Dart code, but the sqlite3 native library is loaded via JNI.
# Keep the JNI bridge classes.
-keep class com.simolus.drift.** { *; }
-keep class org.sqlite.** { *; }

# sqlite3_flutter_libs (native .so loader)
-keep class com.simolus.sqlite3.** { *; }
-dontwarn com.simolus.**

# Keep all classes accessed via reflection in generated Drift code
-keepclassmembers class * extends com.google.protobuf.GeneratedMessageLite { *; }

# ---------------------------------------------------------------------------
# flutter_tts
# ---------------------------------------------------------------------------

-keep class com.tundralabs.fluttertts.** { *; }
-dontwarn com.tundralabs.fluttertts.**

# Android TTS engine classes
-keep class android.speech.tts.** { *; }

# ---------------------------------------------------------------------------
# in_app_update (Google Play Core)
# ---------------------------------------------------------------------------

-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }
-dontwarn com.google.android.play.core.**

# Flutter plugin wrapper for in_app_update
-keep class dev.fluttercommunity.plus.inappupdate.** { *; }
-dontwarn dev.fluttercommunity.plus.inappupdate.**

# ---------------------------------------------------------------------------
# Dio / OkHttp (network)
# ---------------------------------------------------------------------------

-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }

# ---------------------------------------------------------------------------
# Gson / JSON (used by some Flutter plugins internally)
# ---------------------------------------------------------------------------

-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# ---------------------------------------------------------------------------
# image_picker / file_picker / share_plus
# ---------------------------------------------------------------------------

-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-dontwarn com.mr.flutter.plugin.filepicker.**
-keep class dev.fluttercommunity.plus.share.** { *; }
-dontwarn dev.fluttercommunity.plus.share.**

# ---------------------------------------------------------------------------
# cached_network_image / Glide (image caching)
# ---------------------------------------------------------------------------

-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class * extends com.bumptech.glide.module.AppGlideModule {
    <init>(...);
}
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
    **[] $VALUES;
    public *;
}
-dontwarn com.bumptech.glide.**

# ---------------------------------------------------------------------------
# General Android / AndroidX
# ---------------------------------------------------------------------------

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable implementations
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ---------------------------------------------------------------------------
# Suppress warnings for optional / unused dependencies
# ---------------------------------------------------------------------------

-dontwarn javax.annotation.**
-dontwarn sun.misc.**
-dontwarn java.lang.invoke.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
