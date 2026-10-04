# ClassMate — Flutter MVP

نسخه 0.1 یک داشبورد RTL فارسی برای مدیریت زندگی تحصیلی است.

## شامل
- داشبورد یک‌صفحه‌ای
- کلاس بعدی + countdown
- برنامه کل هفته
- افزودن کلاس
- Reminder هفتگی کلاس
- Task / Exam
- ذخیره محلی
- Weekly momentum
- Analytics ساده
- تقویم شمسی در Header

## اجرا

این پکیج عمدتاً `lib/` و `pubspec.yaml` را آماده دارد.

```bash
flutter create .
flutter pub get
flutter run
```

> برای اجرای اعلان زمان‌بندی‌شده روی Android، بخش `android_setup.md` را انجام بده.

## نسخه‌های وابستگی
این MVP بر اساس نسخه‌های فعلی بررسی‌شده در pub.dev ساخته شده است:
- `flutter_local_notifications 22.3.1`
- `shared_preferences 2.5.5`
- `google_fonts 8.2.1`
- `timezone 0.11.1`
- `flutter_timezone 5.1.0`
- `shamsi_date 1.1.1`

برای MVP، داده‌ها عمداً local هستند؛ Backend و Login را وارد نکردیم تا سرعت توسعه حفظ شود.
