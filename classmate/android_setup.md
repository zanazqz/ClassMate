# Android notification setup

`flutter_local_notifications` 22.x به Android جدیدتر و core library desugaring نیاز دارد. مستندات فعلی package حداقل compileSdk 35 را ذکر می‌کند و برای زمان‌بندی از Java 17/desugaring استفاده می‌شود.

## 1) android/app/build.gradle.kts

در `android {}`:

```kotlin
compileSdk = 36

defaultConfig {
    minSdk = 24
}

compileOptions {
    isCoreLibraryDesugaringEnabled = true
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

kotlinOptions {
    jvmTarget = JavaVersion.VERSION_17.toString()
}
```

و داخل `dependencies`:

```kotlin
coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
```

اگر پروژه Flutter جدیدت همین تنظیمات را دارد، دوباره اضافه نکن.

## 2) android/app/src/main/AndroidManifest.xml

داخل `<manifest>`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

برای شروع از `inexactAllowWhileIdle` استفاده شده تا MVP به exact-alarm permission وابسته نباشد.

## 3) تست

بعد از تغییرات:

```bash
flutter clean
flutter pub get
flutter run
```

روی Android 13+ اجازه اعلان را Allow کن.

منبع تنظیمات اعلان: مستندات رسمی `flutter_local_notifications` در pub.dev.
