-- ==============================================================================
-- WASSLNI SEED DATA - MOROCCAN PRODUCTION PREPARATION
-- Cities, Pricing, Vehicle Categories, Airport Hubs & Super Admin Account
-- ==============================================================================

-- 1. VEHICLE CATEGORIES (الفئات المغربية)
INSERT INTO vehicle_categories (id, name_ar, name_fr, name_ber, description, seat_capacity, sort_order)
VALUES 
  ('ECO', 'اقتصادي', 'Économique', 'ⵜⴰⴷⵎⵙⴰⵏⵜ', 'سيارات عادية بأسعار مناسبة (داسيا لوغان، سانديرو، رونو كليو)', 4, 1),
  ('CONFORT', 'مريح', 'Confort', 'ⴰⴼⵔⴰ', 'سيارات حديثة ومريحة مع تكييف مضمون (فيات تيبو، هيونداي، تويوتا)', 4, 2),
  ('FAMILY_6', 'عائلي (6 مقاعد)', 'Familial (6 places)', 'ⵜⴰⵡⴰⵛⵓⵍⵜ', 'سيارات فسيحة لـ 6 ركاب وأمتعة (داسيا لودجي، رونو كانغو)', 6, 3),
  ('WOMEN_ONLY', 'سائقة فقط', 'Femmes Uniquement', 'ⵜⵉⵡⵜⵎⵉⵏ', 'مخصص للنساء حصرياً مع سائقات نساء محترفات ومعتمدات', 4, 4),
  ('PETIT_TAXI', 'طاكسي صغير', 'Petit Taxi', 'ⵟⴰⴽⵙⵉ ⴰⵎⵥⵢⴰⵏ', 'طاكسي مرخص داخل المدينة مع دعم المفاوضة أو العدّاد', 3, 5),
  ('GRAND_TAXI', 'طاكسي كبير (بين المدن)', 'Grand Taxi Interurbain', 'ⵟⴰⴽⵙⵉ ⴰⵎⵇⵔⴰⵏ', 'رحلات مريحة بين المدن الكبرى (كازا، الرباط، مراكش، طنجة)', 6, 6)
ON CONFLICT (id) DO UPDATE SET name_ar = EXCLUDED.name_ar;

-- 2. MOROCCAN METROPOLITAN CITIES (المدن المدعومة)
INSERT INTO cities (id, name_ar, name_fr, center_location, default_commission_rate, is_active)
VALUES
  ('CASABLANCA', 'الدار البيضاء', 'Casablanca', ST_SetSRID(ST_MakePoint(-7.6038, 33.5898), 4326), 8.00, true),
  ('RABAT', 'الرباط', 'Rabat', ST_SetSRID(ST_MakePoint(-6.8326, 34.0209), 4326), 8.00, true),
  ('MARRAKECH', 'مراكش', 'Marrakech', ST_SetSRID(ST_MakePoint(-7.9892, 31.6295), 4326), 10.00, true),
  ('TANGIER', 'طنجة', 'Tanger', ST_SetSRID(ST_MakePoint(-5.8339, 35.7595), 4326), 8.00, true),
  ('FES', 'فاس', 'Fès', ST_SetSRID(ST_MakePoint(-5.0003, 34.0331), 4326), 8.00, true),
  ('AGADIR', 'أكادير', 'Agadir', ST_SetSRID(ST_MakePoint(-9.6000, 30.4278), 4326), 8.00, true),
  ('MEKNES', 'مكناس', 'Meknès', ST_SetSRID(ST_MakePoint(-5.5407, 33.8938), 4326), 7.00, true),
  ('KENITRA', 'القنيطرة', 'Kénitra', ST_SetSRID(ST_MakePoint(-6.5802, 34.2610), 4326), 7.00, true),
  ('OUJDA', 'وجدة', 'Oujda', ST_SetSRID(ST_MakePoint(-1.9167, 34.6867), 4326), 7.00, true),
  ('TETOUAN', 'تطوان', 'Tétouan', ST_SetSRID(ST_MakePoint(-5.3684, 35.5785), 4326), 7.00, true)
ON CONFLICT (id) DO UPDATE SET is_active = EXCLUDED.is_active;

-- 3. PRICING RULES (تعريفات المدن والفئات)
INSERT INTO city_pricing (city_id, category_id, base_fare_mad, per_km_rate_mad, per_minute_rate_mad, minimum_fare_mad, night_surge_percentage)
VALUES
  -- الدار البيضاء
  ('CASABLANCA', 'ECO', 7.00, 3.50, 0.50, 12.00, 20.00),
  ('CASABLANCA', 'CONFORT', 10.00, 4.50, 0.70, 18.00, 20.00),
  ('CASABLANCA', 'FAMILY_6', 15.00, 5.50, 0.90, 25.00, 20.00),
  ('CASABLANCA', 'WOMEN_ONLY', 7.00, 3.50, 0.50, 12.00, 20.00),
  ('CASABLANCA', 'PETIT_TAXI', 7.50, 3.00, 0.40, 10.00, 20.00),

  -- الرباط
  ('RABAT', 'ECO', 6.00, 3.20, 0.45, 10.00, 20.00),
  ('RABAT', 'CONFORT', 9.00, 4.20, 0.65, 16.00, 20.00),
  ('RABAT', 'WOMEN_ONLY', 6.00, 3.20, 0.45, 10.00, 20.00),

  -- مراكش (السياحة والمدينة الحمراء)
  ('MARRAKECH', 'ECO', 6.00, 3.00, 0.40, 10.00, 20.00),
  ('MARRAKECH', 'CONFORT', 10.00, 4.50, 0.70, 20.00, 20.00),
  ('MARRAKECH', 'WOMEN_ONLY', 6.00, 3.00, 0.40, 10.00, 20.00)
ON CONFLICT (city_id, category_id) DO NOTHING;

-- 4. AIRPORT & TRAIN HUBS (المطارات ومحطات القطار ONCF)
INSERT INTO airport_station_pricing (city_id, hub_name, hub_type, hub_location, flat_rate_mad, pickup_surcharge_mad)
VALUES
  ('CASABLANCA', 'Aéroport Mohammed V (CMN)', 'AIRPORT', ST_SetSRID(ST_MakePoint(-7.5898, 33.3675), 4326), 250.00, 0.00),
  ('CASABLANCA', 'Gare Casa-Port (TGV/ONCF)', 'TRAIN_STATION', ST_SetSRID(ST_MakePoint(-7.6111, 33.6006), 4326), NULL, 10.00),
  ('CASABLANCA', 'Gare Casa-Voyageurs (Al Boraq)', 'TRAIN_STATION', ST_SetSRID(ST_MakePoint(-7.5898, 33.5898), 4326), NULL, 10.00),
  ('MARRAKECH', 'Aéroport Marrakech Ménara (RAK)', 'AIRPORT', ST_SetSRID(ST_MakePoint(-8.0363, 31.6069), 4326), 120.00, 0.00),
  ('RABAT', 'Gare Rabat-Agdal (Al Boraq)', 'TRAIN_STATION', ST_SetSRID(ST_MakePoint(-6.8526, 33.9994), 4326), NULL, 10.00)
ON CONFLICT DO NOTHING;

-- 5. INITIAL SUPER ADMIN ACCOUNT (المشرف العام)
-- Password: AdminWasslni2026! (Bcrypt hash cost 12)
INSERT INTO admins (username, email, password_hash, full_name, is_superadmin, is_active)
VALUES (
  'superadmin',
  'admin@wasslni.ma',
  '$2b$12$e6eL9g/BfTzX5sUa56wMMeO21F87Y5j9k7m9L8zP0a3V8k5w9nLqm',
  'أمين العلمي (المدير العام)',
  true,
  true
) ON CONFLICT (username) DO NOTHING;

-- 6. PLATFORM SETTINGS (إعدادات العمل الافتراضية)
INSERT INTO settings (key, value, description)
VALUES
  ('free_commission_months', '2', 'عدد الأشهر المجانية الافتراضية لكل سائق تبدأ من أول رحلة مكتملة'),
  ('max_accumulated_free_months', '6', 'الحد الأقصى للأشهر المجانية المتراكمة عبر برنامج الدعوة'),
  ('referral_qualifying_rides', '5', 'عدد الرحلات المطلوبة من المدعو لتأهيل مكافأة الداعي'),
  ('bidding_timeout_seconds', '120', 'مهلة استقبال عروض السائقين للراكب'),
  ('driver_response_timeout_seconds', '30', 'مهلة رد السائق على الطلب الوارد'),
  ('max_driver_debt_mad', '-500.00', 'الحد الأقصى المسموح به لدين عمولة السائق قبل إيقاف استقبال الطلبات النقدية')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

