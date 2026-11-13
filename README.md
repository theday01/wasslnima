# 🚗 منصة وصّلني (Wasslni Morocco) — النقل المغربي الحر بنموذج التفاوض 🇲🇦

[![Wasslni Mobile APK & CI/CD Pipeline](https://github.com/theday01/wasslnima/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/theday01/wasslnima/actions/workflows/ci-cd.yml)
[![GitHub Release](https://img.shields.io/github/v/release/theday01/wasslnima?style=flat-square&color=0B3D2E)](https://github.com/theday01/wasslnima/releases/tag/v1.0.0)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-gold?style=flat-square)](https://github.com/theday01/wasslnima)

منصة نقل ذكي مغربية متكاملة وعالمية الجودة مبنية بنموذج التفاوض الحر على الأسعار (مستوحاة من تجربة inDrive)، مصممة بهوية مغربية فاخرة (**الأخضر الزمردي `#0B3D2E`** و**الذهبي الملكي `#C9A24B`**) مع دعم **الوضع النهاري (Day Mode)** كوضع افتراضي رسمي، وخرائط تفاعلية حية سلسة، وحزمة متكاملة من الشاشات المخصصة وحذف كامل للبيانات التجريبية للاستخدام الواقعي الفوري.

---

## 📥 روابط التحميل المباشرة لملفات التطبيق (APKs)

| التطبيق | الحجم | رابط التحميل المباشر من GitHub Releases | الملف المحلي بالحاسوب |
| :--- | :---: | :---: | :---: |
| 🧑‍💼 **تطبيق الراكب (Wasslni Rider)** | **21.2 MB** | [📥 تحميل `wasslni-rider.apk`](https://github.com/theday01/wasslnima/releases/download/v1.0.0/wasslni-rider.apk) | [`release-apks/wasslni-rider.apk`](file:///d:/scripts/19-%20like_IN-Driver/release-apks/wasslni-rider.apk) |
| 🚖 **تطبيق السائق (Wasslni Captain)** | **20.2 MB** | [📥 تحميل `wasslni-driver.apk`](https://github.com/theday01/wasslnima/releases/download/v1.0.0/wasslni-driver.apk) | [`release-apks/wasslni-driver.apk`](file:///d:/scripts/19-%20like_IN-Driver/release-apks/wasslni-driver.apk) |

> 💡 **صفحة الإصدارات الكاملة**: [https://github.com/theday01/wasslnima/releases/tag/v1.0.0](https://github.com/theday01/wasslnima/releases/tag/v1.0.0)

---

## ✨ أبرز المزايا والمواصفات المطبقة حديثاً

1. ☀️ **الوضع النهاري (Day Mode) كوضع افتراضي رسمي**:
   - واجهات ناصعة ونقية بالخلفيات البيضاء المريحة للعين، مع تباين عالي الجودة متوافق مع معايير WCAG AAA.
   - تحديث شامل لكافة الشاشات: شاشات البداية، تسجيل الدخول برقم الهاتف ورمز التحقق، طلب الرحلة، رادار العروض الحية، والرحلة النشطة.

2. 🗺️ **محرك الخرائط والمسارات المتقدم (MapLibre + OpenFreeMap Vector + Self-Hosted OSRM/Photon)**:
   - **OpenFreeMap Vector Tiles**: استبدال بلاطات السيرفرات التجارية ببلاطات فيكتور حديثة وقانونية 100% مع حفظ حقوق الملكية (`© OpenFreeMap • © OpenMapTiles • © OpenStreetMap`).
   - **تصميم خريطة بهوية وصّلني**: الوضع النهاري الافتراضي بألوان الأخضر الزمردي `#0B3D2E` والذهبي الملكي `#C9A24B`.
   - **طبقة MapProvider مجردة في الـ Backend**: واجهة موحدة لـ (search, reverse, route, matrix, eta) تدعم 3 مزودين قابلين للتبديل الفوري عبر الإعدادات:
     1. `self-hosted` (الافتراضي للإنتاج): OSRM للمسارات + Photon للبحث الجغرافي ببيانات المغرب فقط.
     2. `openrouteservice`: بمفتاح API خارجي مع دعم مسارات السيارات والدراجات.
     3. `mapbox`: مزود احتياطي (Fallback).
   - **أولوية المعالم الاستراتيجية في PostGIS**: جدول `places` مفهرس مكانياً (GIST) يضم كافة المطارات، محطات قطار البراق، المراكز التجارية، الجامعات والمستشفيات للبحث الفوري (< 15ms).
   - **كاش متعدد المستويات في Redis**: تخزين مؤقت للبحث (24 ساعة) والمسارات الشائعة (ساعتان) مع تقنية Debounce للبحث (350ms).
   - **حساب السعر والمسافة من الباك إند فقط**: حساب صارم لمرة واحدة عند إنشاء الطلب وتتبع السائقين عبر مقابس WebSocket وRedis GEO دون أي استدعاء خارجي للخرائط.
   - **التنقل الصوتي للسائق (Voice Navigation Deep Link)**: زر مباشر في تطبيق السائق يفتح الملاحة خطوة بخطوة في **Waze** أو **Google Maps**.
   - **بنية تحتية مكتملة في Docker**: خدمات OSRM وPhoton مع سكربت `scripts/setup-morocco-osm.sh` وسكربت التحديث الشهري التلقائي `scripts/update-osm-monthly.sh`.

3. 🎨 **أيقونات تطبيقات رسمية مخصصة (Custom Launcher Icons)**:
   - تم توليد ودمج حزم الأيقونات عالية الدقة لكافة كثافات شاشات أندرويد (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`).
   - تظهر الأيقونة فور التثبيت على الهاتف بشعار "وصّلني" والتاكسي الذهبي بدلاً من أيقونات Flutter الافتراضية.

4. 📑 **شاشات مخصصة ومستقلة لجميع عناصر القائمة الجانبية**:
   - 🕒 **سجل الرحلات**: واجهة نظيفة جاهزة لتسجيل رحلات المستخدم الحقيقية.
   - 💳 **طرق الدفع المغربية**: دعم الكاش نقداً، بطاقات CMI البنكية، وفاكاش وكاش بلوس، والتحويل البنكي (RIB) للكباتن.
   - 🛡️ **مركز الأمان والسلامة**: زر طوارئ SOS فوري للشرطة (19)، التتبع المباشر بالـ GPS، وتوافق تام مع قانون 09-08 واللجنة الوطنية CNDP.
   - 💬 **مركز المساعدة والدعم 24/7**: تواصل فوري مباشر عبر الواتساب، ورقم النجدة المباشر، والأسئلة الشائعة.
   - ⚙️ **الإعدادات والتخصيص**: تخصيص الإشعارات والصوت، واختيار اللغة (الدارجة المغربية، العربية، الفرنسية، الأمازيغية).

5. 🧹 **نظافة البيانات 100% (Clean Real State)**:
   - حذف كافة البيانات التجريبية والمزيفة لتبدأ المحافظ وسجلات الرحلات نقية وجاهزة للمستخدم والسائق الفعليين.

---

## 🧭 روابط سريعة للمعاينة والتجربة المحلية

| المكون / البيئة | الرابط / المسار | الوصف |
| :--- | :--- | :--- |
| 📱 **النموذج التفاعلي الفاخر (PWA)** | **[http://localhost:5000](http://localhost:5000)** | تجربة شاشات الراكب والسائق التفاعلية مع الخريطة الحية |
| 📊 **لوحة تحكم الإدارة (Admin Dashboard)** | **[http://localhost:5001](http://localhost:5001)** | متابعة الأسطول والتحقق من وثائق السائقين وإحصائيات العمليات |
| 📸 **تقرير فحص وإصلاح الخرائط المصور** | [`map-verification-report.md`](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/map-verification-report.md) | تقرير فحص الخرائط مع لقطات الشاشة الحية (Screenshots) |
| 📖 **مواصفات واجهات البرمجة (OpenAPI)** | [`docs/api-spec.yaml`](file:///d:/scripts/19-%20like_IN-Driver/docs/api-spec.yaml) | توثيق كامل لـ REST API ومقابس WebSocket الحية |
| 🗄️ **مخطط قاعدة البيانات (SQL Schema)** | [`database/schema.sql`](file:///d:/scripts/19-%20like_IN-Driver/database/schema.sql) | سكربت PostgreSQL 16 + PostGIS لـ 34 جدولاً |

---

## 📁 هيكل المستودع البرمجي (Monorepo Architecture)

```
wasslnima/
├── apps/
│   ├── api/                     # محرك الباك إند (NestJS + TypeScript + WebSocket)
│   ├── rider-app/               # تطبيق الراكب الرسمي (Flutter)
│   ├── driver-app/              # تطبيق كابتن وصّلني الرسمي (Flutter)
│   └── admin-web/               # لوحة تحكم الإدارة (React Web Dashboard)
├── packages/
│   ├── flutter-ui/              # حزمة المكونات والشاشات المشتركة ومحرك الخرائط
│   └── design-tokens/           # رموز نظام التصميم الفخم (JSON, CSS, Dart)
├── assets/
│   └── icons/                   # حزم الأيقونات عالية الدقة لتطبيقي الراكب والسائق
├── database/
│   ├── schema.sql               # كود قاعدة البيانات الشامل (Postgres + PostGIS)
│   └── seeds/
│       └── 01_initial_seed.sql  # بذور البيانات للمدن والتعريفات وحساب المشرف
├── infrastructure/
│   ├── docker/
│   │   ├── docker-compose.yml   # تشغيل Postgres و Redis و API
│   │   └── Dockerfile.api       # بناء حاوية الإنتاج للباك إند
│   └── nginx/
│       └── wasslni.conf         # ملف إعدادات خادم Nginx مع حماية SSL
├── .github/
│   └── workflows/
│       └── ci-cd.yml            # خط الأنابيب المؤتمت لبناء ملفات APK والنشر في Releases
├── prototypes/
│   ├── index.html               # النموذج التفاعلي عالي الدقة
│   ├── wasslni-rider.apk        # نسخة الـ APK الحالية للراكب
│   └── wasslni-driver.apk       # نسخة الـ APK الحالية للسائق
├── release-apks/                # مجلد تجميع ملفات الـ APK الجاهزة للتثبيت
└── docs/
    └── api-spec.yaml            # مواصفات OpenAPI الرسمية
```

---

## 🚀 كيفية تشغيل المشروع وتثبيت التطبيقات

### 1. تثبيت التطبيقات على هواتف أندرويد
1. حمّل ملف `wasslni-rider.apk` أو `wasslni-driver.apk` من [صفحة الإصدارات](https://github.com/theday01/wasslnima/releases/tag/v1.0.0).
2. افتح الملف على هاتفك ووافق على التثبيت من المصادر الموثوقة.
3. ستظهر أيقونة التطبيق الرسمية مباشرة في قائمة تطبيقات هاتفك.

### 2. تشغيل النموذج التفاعلي محلياً
```bash
python -m http.server 5000 --directory "prototypes"
# ثم افتح المتصفح على: http://localhost:5000
```

### 3. تشغيل خدمات الباك إند وقاعدة البيانات
```bash
cd infrastructure/docker
docker-compose up -d
```

---

## 📚 وثائق المراحل المنجزة بالكامل

1. [المرحلة 1: وثيقة متطلبات المنتج (PRD)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase1-prd.md)
2. [المرحلة 1: خارطة الطريق (Roadmap MVP & V2)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase1-roadmap.md)
3. [المرحلة 1: مقارنة التقنيات والتوصيات](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase1-tech-comparison.md)
4. [المرحلة 2: مخطط قاعدة البيانات (ERD) واستراتيجية الأداء](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase2-erd.md)
5. [المرحلة 2: دليل تصميم واجهات البرمجة (API Design)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase2-api-design.md)
6. [المرحلة 3: نظام التصميم الفخم والمخططات الشبكية (Wireframes)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase3-design-tokens-and-wireframes.md)
7. [المرحلة 4: توثيق النماذج التفاعلية عالية الدقة](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase4-interactive-prototypes.md)
8. [المرحلة 5: كود محرك الباك إند (NestJS Modular Monolith)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase5-backend-codebase.md)
9. [المرحلة 6: كود تطبيق الراكب ومكتبة المكونات (Flutter UI)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase6-rider-app-and-components.md)
10. [المرحلة 7: كود تطبيق السائق (وصّلني كابتن)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase7-driver-app.md)
11. [المرحلة 8: لوحة تحكم الإدارة (Admin Dashboard)](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase8-admin-dashboard.md)
12. [المرحلة 9: خطة النشر والتكلفة التقديرية وخطة الإطلاق](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase9-launch-and-devops-plan.md)
