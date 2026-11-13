-- Wasslni Platform - Seed Data: Places & Landmarks (Morocco)
-- Covers Airports, Train Stations (Al Boraq/ONCF), Malls, Universities, Hospitals, Key Landmarks

INSERT INTO places (id, name_ar, name_fr, category, city, address_ar, address_fr, aliases, location, popularity_score, is_active)
VALUES
-- AIRPORTS
('place_cmn_airport', 'مطار محمد الخامس الدولي', 'Aéroport International Mohammed V', 'AIRPORT', 'Casablanca', 'النواصر، الدار البيضاء', 'Nouaceur, Casablanca', ARRAY['CMN', 'مطار كازا', 'Aéroport Casablanca'], ST_SetSRID(ST_MakePoint(-7.5898, 33.3675), 4326)::geography, 99, true),
('place_rak_airport', 'مطار مراكش المنارة الدولي', 'Aéroport Marrakech-Ménara', 'AIRPORT', 'Marrakech', 'المنارة، مراكش', 'Ménara, Marrakech', ARRAY['RAK', 'مطار مراكش', 'Aéroport Marrakech'], ST_SetSRID(ST_MakePoint(-8.0363, 31.6069), 4326)::geography, 98, true),
('place_rba_airport', 'مطار الرباط سلا الدولي', 'Aéroport de Rabat-Salé', 'AIRPORT', 'Rabat', 'سلا، جهة الرباط سلا القنيطرة', 'Salé, Rabat', ARRAY['RBA', 'مطار الرباط', 'Aéroport Rabat'], ST_SetSRID(ST_MakePoint(-6.7515, 34.0515), 4326)::geography, 95, true),
('place_tng_airport', 'مطار طنجة ابن بطوطة الدولي', 'Aéroport Tanger Ibn Battouta', 'AIRPORT', 'Tangier', 'بوخالف، طنجة', 'Boukhalef, Tanger', ARRAY['TNG', 'مطار طنجة', 'Aéroport Tanger'], ST_SetSRID(ST_MakePoint(-5.9169, 35.7269), 4326)::geography, 95, true),
('place_aga_airport', 'مطار أكادير المسيرة الدولي', 'Aéroport d''Agadir-Al Massira', 'AIRPORT', 'Agadir', 'التمسية، أكادير إداوتنان', 'Temsia, Agadir', ARRAY['AGA', 'مطار أكادير'], ST_SetSRID(ST_MakePoint(-9.4131, 30.3250), 4326)::geography, 92, true),
('place_fez_airport', 'مطار فاس سايس الدولي', 'Aéroport de Fès-Saïss', 'AIRPORT', 'Fez', 'طريق إيموزار، فاس', 'Route d''Imouzzer, Fès', ARRAY['FEZ', 'مطار فاس'], ST_SetSRID(ST_MakePoint(-4.9780, 33.9273), 4326)::geography, 90, true),

-- TRAIN STATIONS (ONCF & AL BORAQ)
('place_casa_voyageurs', 'محطة الدار البيضاء المسافرين (البراق)', 'Gare Casa-Voyageurs', 'STATION', 'Casablanca', 'ساحة المسافرين، بلفيدير، الدار البيضاء', 'Place des Voyageurs, Belvédère, Casablanca', ARRAY['كازا فواياجور', 'TGV Casablanca', 'قطار البراق'], ST_SetSRID(ST_MakePoint(-7.5898, 33.5892), 4326)::geography, 98, true),
('place_casa_port', 'محطة الدار البيضاء الميناء', 'Gare Casa-Port', 'STATION', 'Casablanca', 'شارع حليف بن عباد، سيدي بليوط', 'Bd Houphouët Boigny, Sidi Belyout, Casablanca', ARRAY['كازا بور', 'Casa Port'], ST_SetSRID(ST_MakePoint(-7.6114, 33.5992), 4326)::geography, 96, true),
('place_rabat_agdal', 'محطة الرباط أكدال (البراق)', 'Gare Rabat-Agdal', 'STATION', 'Rabat', 'شارع فرنسا، أكدال، الرباط', 'Avenue de France, Agdal, Rabat', ARRAY['الرباط أكدال', 'TGV Rabat', 'Gare Agdal'], ST_SetSRID(ST_MakePoint(-6.8553, 34.0044), 4326)::geography, 97, true),
('place_rabat_ville', 'محطة الرباط المدينة', 'Gare Rabat-Ville', 'STATION', 'Rabat', 'شارع محمد الخامس، حسان، الرباط', 'Avenue Mohammed V, Hassan, Rabat', ARRAY['الرباط فيل', 'Rabat Ville'], ST_SetSRID(ST_MakePoint(-6.8344, 34.0156), 4326)::geography, 95, true),
('place_kenitra_gare', 'محطة القنيطرة (البراق)', 'Gare de Kénitra', 'STATION', 'Kenitra', 'شارع محمد الخامس، القنيطرة', 'Avenue Mohammed V, Kénitra', ARRAY['محطة القنيطرة', 'TGV Kenitra', 'قطار القنيطرة'], ST_SetSRID(ST_MakePoint(-6.5802, 34.2541), 4326)::geography, 94, true),
('place_tanger_ville', 'محطة طنجة المدينة (البراق)', 'Gare Tanger-Ville', 'STATION', 'Tangier', 'مالاباطا، طنجة', 'Malabata, Tanger', ARRAY['محطة طنجة', 'TGV Tanger', 'Tanger Ville'], ST_SetSRID(ST_MakePoint(-5.7834, 35.7725), 4326)::geography, 95, true),
('place_marrakech_gare', 'محطة قطار مراكش', 'Gare de Marrakech', 'STATION', 'Marrakech', 'شارع الحسن الثاني، جليز، مراكش', 'Avenue Hassan II, Guéliz, Marrakech', ARRAY['محطة مراكش', 'Gare Marrakech'], ST_SetSRID(ST_MakePoint(-8.0189, 31.6300), 4326)::geography, 94, true),
('place_fez_gare', 'محطة قطار فاس', 'Gare de Fès-Ville', 'STATION', 'Fez', 'فاس الجديد، فاس', 'Fès El Jadid, Fès', ARRAY['محطة فاس'], ST_SetSRID(ST_MakePoint(-4.9996, 34.0458), 4326)::geography, 90, true),

-- SHOPPING MALLS
('place_morocco_mall', 'موروكو مول', 'Morocco Mall', 'MALL', 'Casablanca', 'زاوية سيدي عبد الرحمن، عين الدياب', 'Angle Bd Sidi Abderrahmane, Aïn Diab, Casablanca', ARRAY['Morocco Mall', 'المول الكبير'], ST_SetSRID(ST_MakePoint(-7.7003, 33.5762), 4326)::geography, 97, true),
('place_anfaplace_mall', 'أنفا بليس مول', 'AnfaPlace Mall', 'MALL', 'Casablanca', 'شارع الكورنيش، عين الدياب', 'Boulevard de la Corniche, Aïn Diab, Casablanca', ARRAY['أنفا بلاس', 'Anfaplace'], ST_SetSRID(ST_MakePoint(-7.6668, 33.5986), 4326)::geography, 91, true),
('place_marina_shopping', 'مارينا مول الدار البيضاء', 'Marina Shopping Center', 'MALL', 'Casablanca', 'المارينا، سيدي بليوط', 'Bd des Almohades, La Marina, Casablanca', ARRAY['مارينا شوبينغ', 'Marina Mall'], ST_SetSRID(ST_MakePoint(-7.6186, 33.6067), 4326)::geography, 89, true),
('place_arribat_center', 'الرباط سنتر', 'Arribat Center', 'MALL', 'Rabat', 'شارع الأبطال، أكدال، الرباط', 'Avenue des Nations Unies / Al Abtal, Agdal, Rabat', ARRAY['Arribat Center', 'مول أكدال'], ST_SetSRID(ST_MakePoint(-6.8517, 34.0042), 4326)::geography, 95, true),
('place_menara_mall', 'منارة مول', 'Menara Mall', 'MALL', 'Marrakech', 'شارع محمد السادس، الحي الشتوي', 'Avenue Mohammed VI, Hivernage, Marrakech', ARRAY['Menara Mall', 'مول المنارة'], ST_SetSRID(ST_MakePoint(-8.0167, 31.6214), 4326)::geography, 93, true),
('place_socco_alto', 'سوكو ألتو طنجة', 'Socco Alto Tanger', 'MALL', 'Tangier', 'كاليفورنيا، طنجة', 'Quartier Californie, Tanger', ARRAY['Socco Alto', 'سوكو ألطو'], ST_SetSRID(ST_MakePoint(-5.8369, 35.7761), 4326)::geography, 90, true),
('place_tanger_city_mall', 'طنجة سيتي مول', 'Tanger City Mall', 'MALL', 'Tangier', 'مالاباطا، طنجة', 'Place du Maghreb Arabe, Tanger', ARRAY['Tanger City Mall', 'سيتي مول طنجة'], ST_SetSRID(ST_MakePoint(-5.7820, 35.7733), 4326)::geography, 91, true),

-- UNIVERSITIES & CAMPUSES
('place_univ_ibn_tofail', 'جامعة ابن طفيل', 'Université Ibn Tofail', 'UNIVERSITY', 'Kenitra', 'طريق معسكر، القنيطرة', 'Campus Universitaire, Kénitra', ARRAY['جامعة القنيطرة', 'Ibn Tofail University', 'UIT'], ST_SetSRID(ST_MakePoint(-6.5856, 34.2519), 4326)::geography, 88, true),
('place_univ_hassan2_casa', 'جامعة الحسن الثاني - عين الشق', 'Université Hassan II - Aïn Chock', 'UNIVERSITY', 'Casablanca', 'طريق الجديدة، عين الشق', 'Route d''El Jadida, Casablanca', ARRAY['جامعة الحسن الثاني', 'UH2C', 'Faculté Ben M''sik'], ST_SetSRID(ST_MakePoint(-7.6492, 33.5411), 4326)::geography, 89, true),
('place_univ_mohammed5_rabat', 'جامعة محمد الخامس - أكدال', 'Université Mohammed V - Agdal', 'UNIVERSITY', 'Rabat', 'شارع ابن بطوطة، أكدال', 'Avenue Ibn Battouta, Agdal, Rabat', ARRAY['جامعة محمد الخامس', 'UM5', 'Faculté des Sciences Rabat'], ST_SetSRID(ST_MakePoint(-6.8486, 34.0044), 4326)::geography, 91, true),
('place_univ_cadi_ayyad', 'جامعة القاضي عياض', 'Université Cadi Ayyad', 'UNIVERSITY', 'Marrakech', 'شارع عبد الكريم الخطابي، أمرشيش', 'Bd Abdelkrim Khattabi, Marrakech', ARRAY['جامعة مراكش', 'UCA', 'جامعة القاضي عياض'], ST_SetSRID(ST_MakePoint(-8.0169, 31.6542), 4326)::geography, 87, true),
('place_univ_abdelmalek_saadi', 'جامعة عبد المالك السعدي', 'Université Abdelmalek Essaâdi', 'UNIVERSITY', 'Tangier', 'طريق طنجة تطوان، بوخالف', 'Campus Ziaten / Boukhalef, Tanger', ARRAY['جامعة طنجة', 'UAE Tanger', 'كلية الحقوق طنجة'], ST_SetSRID(ST_MakePoint(-5.8972, 35.7369), 4326)::geography, 86, true),

-- HOSPITALS & HEALTH HUBS
('place_chu_ibn_rochd', 'المستشفى الجامعي ابن رشد', 'CHU Ibn Rochd', 'HOSPITAL', 'Casablanca', 'زنقة جنان الزيتون، مرس السلطان', '1 Rue des Hôpitaux, Casablanca', ARRAY['موريزكو', 'Hopital Ibn Rochd', 'CHU Casa'], ST_SetSRID(ST_MakePoint(-7.6200, 33.5786), 4326)::geography, 93, true),
('place_chu_ibn_sina', 'المستشفى الجامعي ابن سينا (السويسي)', 'CHU Ibn Sina (Souissi)', 'HOSPITAL', 'Rabat', 'زنقة المفضل السملالي، السويسي', 'Rue Al Mofaddal Semlali, Souissi, Rabat', ARRAY['سبيطار السويسي', 'Hopital Avicenne', 'CHU Rabat'], ST_SetSRID(ST_MakePoint(-6.8522, 33.9839), 4326)::geography, 94, true),
('place_hopital_cheikh_khalifa', 'مستشفى الشيخ خليفة بن زايد', 'Hôpital Universitaire Cheikh Khalifa', 'HOSPITAL', 'Casablanca', 'شارع طارق بن زياد، بولو', 'Bd Mohamed Taieb Naciri, Hay Hassani, Casablanca', ARRAY['الشيخ خليفة', 'Hopital Cheikh Khalifa'], ST_SetSRID(ST_MakePoint(-7.6653, 33.5603), 4326)::geography, 92, true),
('place_chu_mohammed6_marrakech', 'المركز الاستشفائي الجامعي محمد السادس', 'CHU Mohammed VI Marrakech', 'HOSPITAL', 'Marrakech', 'طريق تاركة، مراكش', 'BP 2360, Principal, Marrakech', ARRAY['CHU Marrakech', 'مستشفى محمد السادس مراكش'], ST_SetSRID(ST_MakePoint(-8.0558, 31.6669), 4326)::geography, 89, true),
('place_hopital_el_idrissi_kenitra', 'مستشفى الإدريسي الإقليمي', 'Hôpital Régional Al Idrissi', 'HOSPITAL', 'Kenitra', 'المعمورة، القنيطرة', 'Quartier Administratif / Maâmora, Kénitra', ARRAY['سبيطار الغابة', 'Hopital El Idrissi Kenitra'], ST_SetSRID(ST_MakePoint(-6.5772, 34.2575), 4326)::geography, 87, true),

-- HISTORICAL & ICONIC LANDMARKS
('place_mosquee_hassan2', 'مسجد الحسن الثاني', 'Mosquée Hassan II', 'LANDMARK', 'Casablanca', 'شارع سيدي محمد بن عبد الله', 'Bd de la Corniche / Sidi Mohammed Ben Abdellah', ARRAY['جامع الحسن الثاني', 'Hassan II Mosque'], ST_SetSRID(ST_MakePoint(-7.6320, 33.6086), 4326)::geography, 99, true),
('place_tour_hassan', 'صومعة حسان وضريح محمد الخامس', 'Tour Hassan & Mausolée Mohammed V', 'LANDMARK', 'Rabat', 'حسان، الرباط', 'Boulevard Mohamed Lyazidi, Hassan, Rabat', ARRAY['صومعة حسان', 'Tour Hassan', 'ضريح محمد الخامس'], ST_SetSRID(ST_MakePoint(-6.8225, 34.0242), 4326)::geography, 96, true),
('place_jemaa_el_fna', 'ساحة جامع الفنا', 'Place Jemaa el-Fna', 'LANDMARK', 'Marrakech', 'المدينة العتيقة، مراكش', 'Médina, Marrakech', ARRAY['جامع الفنا', 'Jemaa el Fna'], ST_SetSRID(ST_MakePoint(-7.9892, 31.6258), 4326)::geography, 99, true),
('place_bab_boujloud', 'باب بوجلود', 'Bab Bou Jeloud', 'LANDMARK', 'Fez', 'المدينة القديمة، فاس البالي', 'Fès el-Bali, Fès', ARRAY['الباب الأزرق', 'Blue Gate Fez'], ST_SetSRID(ST_MakePoint(-4.9842, 34.0617), 4326)::geography, 92, true),
('place_grottes_hercule', 'مغارة هرقل', 'Grottes d''Hercule', 'LANDMARK', 'Tangier', 'رأس سبارتيل، طنجة', 'Cap Spartel, Tanger', ARRAY['مغارات هرقل', 'Caves of Hercules'], ST_SetSRID(ST_MakePoint(-5.9392, 35.7594), 4326)::geography, 93, true),
('place_twin_center', 'مركز التوأم الدار البيضاء', 'Twin Center Casablanca', 'LANDMARK', 'Casablanca', 'شارع الزرقطوني، معاريف', 'Angle Bd Zerktouni et Bd Al Massira Al Khadra, Maarif', ARRAY['التوين سنتر', 'Twin Center', 'Maarif Twin'], ST_SetSRID(ST_MakePoint(-7.6331, 33.5869), 4326)::geography, 94, true),
('place_mehdia_beach', 'شاطئ المهدية قصبة المهدية', 'Plage & Kasbah de Mehdia', 'LANDMARK', 'Kenitra', 'المهدية، القنيطرة', 'Mehdia Plage, Kénitra', ARRAY['شاطئ مهدية', 'قصبة مهدية', 'Mehdia Surf'], ST_SetSRID(ST_MakePoint(-6.6617, 34.2589), 4326)::geography, 88, true)
ON CONFLICT (id) DO UPDATE SET
  name_ar = EXCLUDED.name_ar,
  name_fr = EXCLUDED.name_fr,
  category = EXCLUDED.category,
  city = EXCLUDED.city,
  address_ar = EXCLUDED.address_ar,
  address_fr = EXCLUDED.address_fr,
  aliases = EXCLUDED.aliases,
  location = EXCLUDED.location,
  popularity_score = EXCLUDED.popularity_score,
  is_active = EXCLUDED.is_active,
  updated_at = CURRENT_TIMESTAMP;
