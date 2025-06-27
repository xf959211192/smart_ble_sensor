# Flutter相关的ProGuard规则
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# 蓝牙相关
-keep class com.boskokg.flutter_blue_plus.** { *; }
-dontwarn com.boskokg.flutter_blue_plus.**

# 权限处理
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# SharedPreferences
-keep class androidx.preference.** { *; }

# 保留注解
-keepattributes *Annotation*

# 保留行号信息，方便调试
-keepattributes SourceFile,LineNumberTable

# 保留泛型信息
-keepattributes Signature

# 保留异常信息
-keepattributes Exceptions

# 优化配置
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify

# 不混淆native方法
-keepclasseswithmembernames class * {
    native <methods>;
}

# 保留枚举
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保留Serializable类
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
