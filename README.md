# مشروع وصّلني (Wasslni) — المنصة المتكاملة للنقل المغربي الحر بنموذج التفاوض

> تطبيق نقل مغربي متكامل بنموذج inDrive (الراكب يقترح السعر والسائق يفاوض أو يقبل)، مصمم خصيصاً لخصوصيات السوق المغربي بهوية فاخرة (الأخضر الزمردي والذهب الملكي)، مع 0% عمولة أول شهرين وبرنامج دعوة السائقين.

---

## 🧭 روابط سريعة للمعاينة والتجربة المباشرة

| التطبيق / المكون | الرابط المباشر | الوصف |
|------------------|----------------|-------|
| 📱 **النموذج التفاعلي الفاخر (UI/UX)** | **[http://localhost:5000](http://localhost:5000)** | تجربة شاشات الراكب والسائق الست مع خريطة كازا الحية التفاعلية |
| 📊 **لوحة تحكم الإدارة (Admin Dashboard)** | **[http://localhost:5001](http://localhost:5001)** | متابعة الأسطول المباشر وتدقيق وثائق السائقين وإدارة الأسعار |
| 📖 **توثيق واجهات البرمجة (OpenAPI)** | [`docs/api-spec.yaml`](file:///d:/scripts/19-%20like_IN-Driver/docs/api-spec.yaml) | مواصفات REST API ومقابس WebSocket الكاملة |
| 🗄️ **مخطط قاعدة البيانات (SQL Schema)** | [`database/schema.sql`](file:///d:/scripts/19-%20like_IN-Driver/database/schema.sql) | سكربت PostgreSQL 16 + PostGIS لـ 34 جدولاً وفهارس GIST |
| 🌱 **البيانات الأولية للمدن والأسعار (Seeds)** | [`database/seeds/01_initial_seed.sql`](file:///d:/scripts/19-%20like_IN-Driver/database/seeds/01_initial_seed.sql) | تسعير الدار البيضاء، الرباط، مراكش، والمطارات |
| 🌐 **إعدادات خادم Nginx للإنتاج** | [`infrastructure/nginx/wasslni.conf`](file:///d:/scripts/19-%20like_IN-Driver/infrastructure/nginx/wasslni.conf) | إعدادات SSL، حماية الـ Rate Limiting، ومقابس WebSocket |

---

## 📁 هيكل المستودع البرمجي (Monorepo Architecture)

```
d:\scripts\19- like_IN-Driver\
├── apps/
│   ├── api/                     # محرك الباك إند (NestJS + TypeScript + WebSocket)
│   ├── rider-app/               # تطبيق الراكب (Flutter - iOS & Android)
│   ├── driver-app/              # تطبيق السائق (Flutter - iOS & Android)
│   └── admin-web/               # لوحة تحكم الإدارة (React Web Dashboard)
├── packages/
│   ├── flutter-ui/              # حزمة المكونات المشتركة لتطبيقي الموبايل
│   └── design-tokens/           # رموز نظام التصميم الفخم (JSON, CSS, Dart)
├── database/
│   ├── schema.sql               # كود قاعدة البيانات الشامل (Postgres + PostGIS)
│   └── seeds/
│       └── 01_initial_seed.sql  # بذور البيانات للمدن والتعريفات وحساب المشرف
├── infrastructure/
│   ├── docker/
│   │   ├── docker-compose.yml   # تشغيل Postgres و Redis و API
│   │   └── Dockerfile.api       # بناء حاوية الإنتاج للباك إند
│   ├── nginx/
│   │   └── wasslni.conf         # ملف إعدادات خادم الويب Nginx مع شهادات SSL
│   └── scripts/
│       └── backup-database.sh   # سكربت النسخ الاحتياطي التلقائي مع الأرشفة 30 يوماً
├── .github/
│   └── workflows/
│       └── ci-cd.yml            # خط أنابيب الفحص والاختبار والنشر المؤتمت CI/CD
├── prototypes/
│   └── index.html               # النموذج التفاعلي عالي الدقة (المنفذ 5000)
└── docs/
    └── api-spec.yaml            # مواصفات OpenAPI الرسمية
```

---

## 📚 وثائق المراحل المنجزة بالكامل

1. [**المرحلة 1: وثيقة متطلبات المنتج (PRD)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase1-prd.md)
2. [**المرحلة 1: خارطة الطريق (Roadmap MVP & V2)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase1-roadmap.md)
3. [**المرحلة 1: مقارنة التقنيات والتوصيات**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase1-tech-comparison.md)
4. [**المرحلة 2: مخطط قاعدة البيانات (ERD) واستراتيجية الأداء**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase2-erd.md)
5. [**المرحلة 2: دليل تصميم واجهات البرمجة (API Design)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase2-api-design.md)
6. [**المرحلة 3: نظام التصميم الفخم والمخططات الشبكية (Wireframes)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase3-design-tokens-and-wireframes.md)
7. [**المرحلة 4: توثيق النماذج التفاعلية عالية الدقة**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase4-interactive-prototypes.md)
8. [**المرحلة 5: كود محرك الباك إند (NestJS Modular Monolith)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase5-backend-codebase.md)
9. [**المرحلة 6: كود تطبيق الراكب ومكتبة المكونات (Flutter UI)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase6-rider-app-and-components.md)
10. [**المرحلة 7: كود تطبيق السائق (وصّلني كابتن)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase7-driver-app.md)
11. [**المرحلة 8: لوحة تحكم الإدارة (Admin Dashboard)**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase8-admin-dashboard.md)
12. [**المرحلة 9: خطة النشر والتكلفة التقديرية وخطة الإطلاق**](file:///C:/Users/Hamza/.gemini/antigravity/brain/2d755162-2af2-4672-a516-1d36c26830c5/phase9-launch-and-devops-plan.md)
