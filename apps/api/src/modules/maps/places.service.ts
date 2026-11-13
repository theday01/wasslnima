import { Injectable, Inject, Logger } from '@nestjs/common';
import { Pool } from 'pg';
import { DATABASE_POOL } from '../../database/database.module';
import { Coordinates, GeocodeResult } from './interfaces/map-results.interface';

export interface PlaceEntity {
  id: string;
  nameAr: string;
  nameFr: string;
  category: string;
  city: string;
  lat: number;
  lon: number;
  addressAr?: string;
  addressFr?: string;
  aliases: string[];
}

@Injectable()
export class PlacesService {
  private readonly logger = new Logger(PlacesService.name);

  // Embedded verified primary Moroccan landmarks (instant zero-delay fallback)
  private readonly staticLandmarks: PlaceEntity[] = [
    // Airports
    {
      id: 'cmn-airport',
      nameAr: 'مطار محمد الخامس الدولي (الدار البيضاء)',
      nameFr: 'Aéroport Mohammed V International (Casablanca)',
      category: 'AIRPORT',
      city: 'الدار البيضاء',
      lat: 33.3675,
      lon: -7.5899,
      aliases: ['CMN', 'مطار كازا', 'Aéroport Casa', 'مطار النواصر'],
    },
    {
      id: 'rak-airport',
      nameAr: 'مطار مراكش المنارة الدولي',
      nameFr: 'Aéroport Marrakech Ménara',
      category: 'AIRPORT',
      city: 'مراكش',
      lat: 31.6069,
      lon: -8.0363,
      aliases: ['RAK', 'مطار مراكش', 'Marrakech Airport'],
    },
    {
      id: 'rba-airport',
      nameAr: 'مطار الرباط سلا الدولي',
      nameFr: 'Aéroport Rabat-Salé',
      category: 'AIRPORT',
      city: 'الرباط',
      lat: 34.0514,
      lon: -6.7515,
      aliases: ['RBA', 'مطار الرباط', 'مطار سلا'],
    },
    {
      id: 'tng-airport',
      nameAr: 'مطار طنجة ابن بطوطة الدولي',
      nameFr: 'Aéroport Tanger Ibn Battouta',
      category: 'AIRPORT',
      city: 'طنجة',
      lat: 35.7269,
      lon: -5.9169,
      aliases: ['TNG', 'مطار طنجة'],
    },

    // Train Stations (ONCF / Al Boraq)
    {
      id: 'casa-voyageurs',
      nameAr: 'محطة القطار الدار البيضاء الميناء (كازا فواياجور)',
      nameFr: 'Gare Casa-Voyageurs (TGV Al Boraq)',
      category: 'STATION',
      city: 'الدار البيضاء',
      lat: 33.5892,
      lon: -7.5901,
      aliases: ['كازا فواياجور', 'Casa Voyageurs', 'البراق كازا'],
    },
    {
      id: 'casa-port',
      nameAr: 'محطة القطار كازا بورت',
      nameFr: 'Gare Casa-Port',
      category: 'STATION',
      city: 'الدار البيضاء',
      lat: 33.6015,
      lon: -7.6130,
      aliases: ['كازا بور', 'Casa Port', 'محطة الميناء'],
    },
    {
      id: 'rabat-agdal',
      nameAr: 'محطة القطار الرباط أكدال (البراق)',
      nameFr: 'Gare Rabat-Agdal (Al Boraq)',
      category: 'STATION',
      city: 'الرباط',
      lat: 33.9989,
      lon: -6.8544,
      aliases: ['الرباط أكدال', 'Gare Agdal', 'Rabat Agdal'],
    },
    {
      id: 'rabat-ville',
      nameAr: 'محطة القطار الرباط المدينة',
      nameFr: 'Gare Rabat-Ville',
      category: 'STATION',
      city: 'الرباط',
      lat: 34.0175,
      lon: -6.8375,
      aliases: ['الرباط سونتر', 'Rabat Ville'],
    },
    {
      id: 'kenitra-station',
      nameAr: 'محطة القطار القنيطرة (البراق)',
      nameFr: 'Gare Kénitra (Al Boraq)',
      category: 'STATION',
      city: 'القنيطرة',
      lat: 34.2541,
      lon: -6.5822,
      aliases: ['محطة القنيطرة', 'Gare Kenitra', 'البراق القنيطرة'],
    },
    {
      id: 'tanger-ville-station',
      nameAr: 'محطة القطار طنجة المدينة (البراق)',
      nameFr: 'Gare Tanger-Ville (Al Boraq)',
      category: 'STATION',
      city: 'طنجة',
      lat: 35.7725,
      lon: -5.7925,
      aliases: ['محطة طنجة', 'Tanger Ville Gare'],
    },
    {
      id: 'marrakech-station',
      nameAr: 'محطة القطار مراكش',
      nameFr: 'Gare de Marrakech (Guéliz)',
      category: 'STATION',
      city: 'مراكش',
      lat: 31.6300,
      lon: -8.0169,
      aliases: ['محطة كيليز', 'Gare Marrakech', 'قطار مراكش'],
    },

    // Major Malls & Commercial Hubs
    {
      id: 'morocco-mall',
      nameAr: 'موروكو مول (Morocco Mall)',
      nameFr: 'Morocco Mall (Boulevard de l\'Océan)',
      category: 'MALL',
      city: 'الدار البيضاء',
      lat: 33.5780,
      lon: -7.6980,
      aliases: ['موروكو مول', 'Morocco Mall', 'أكسيوم كازا'],
    },
    {
      id: 'anfaplace-mall',
      nameAr: 'أنفا بليس مول (AnfaPlace Mall)',
      nameFr: 'AnfaPlace Shopping Center',
      category: 'MALL',
      city: 'الدار البيضاء',
      lat: 33.5975,
      lon: -7.6625,
      aliases: ['انفا بليس', 'Anfa Place', 'عين الذئاب مول'],
    },
    {
      id: 'arribat-center',
      nameAr: 'الرباط سنتر (Arribat Center)',
      nameFr: 'Arribat Center Agdal',
      category: 'MALL',
      city: 'الرباط',
      lat: 33.9995,
      lon: -6.8505,
      aliases: ['الرباط سنتر', 'Arribat Center', 'مول أكدال'],
    },
    {
      id: 'menara-mall',
      nameAr: 'منارة مول (Menara Mall)',
      nameFr: 'Menara Mall Marrakech',
      category: 'MALL',
      city: 'مراكش',
      lat: 31.6190,
      lon: -8.0145,
      aliases: ['منارة مول', 'Menara Mall'],
    },
    {
      id: 'socco-alto',
      nameAr: 'سوكو ألتو مول (Socco Alto)',
      nameFr: 'Socco Alto Mall Tanger',
      category: 'MALL',
      city: 'طنجة',
      lat: 35.7780,
      lon: -5.8420,
      aliases: ['سوكو التو', 'Socco Alto Tanger'],
    },

    // Universities & Education
    {
      id: 'univ-ibn-tofail',
      nameAr: 'جامعة ابن طفيل (القنيطرة)',
      nameFr: 'Université Ibn Tofail (Kénitra)',
      category: 'UNIVERSITY',
      city: 'القنيطرة',
      lat: 34.2510,
      lon: -6.5810,
      aliases: ['ابن طفيل', 'جامعة القنيطرة', 'Fac Kenitra', 'Ibn Tofail'],
    },
    {
      id: 'univ-hassan2',
      nameAr: 'جامعة الحسن الثاني (طريق الجديدة - كازا)',
      nameFr: 'Université Hassan II Casablanca',
      category: 'UNIVERSITY',
      city: 'الدار البيضاء',
      lat: 33.5385,
      lon: -7.6650,
      aliases: ['فاك طريق الجديدة', 'كليات الوازيس', 'Hassan II Univ'],
    },
    {
      id: 'univ-mohammed5',
      nameAr: 'جامعة محمد الخامس (الرباط - أكدال)',
      nameFr: 'Université Mohammed V Rabat',
      category: 'UNIVERSITY',
      city: 'الرباط',
      lat: 34.0040,
      lon: -6.8480,
      aliases: ['جامعة محمد الخامس', 'Fac Sciences Rabat'],
    },

    // Famous Landmarks
    {
      id: 'hassan2-mosque',
      nameAr: 'مسجد الحسن الثاني (الدار البيضاء)',
      nameFr: 'Mosquée Hassan II',
      category: 'LANDMARK',
      city: 'الدار البيضاء',
      lat: 33.6086,
      lon: -7.6328,
      aliases: ['جامع الحسن الثاني', 'Hassan 2 Mosque'],
    },
    {
      id: 'jemaa-el-fna',
      nameAr: 'ساحة جامع الفنا (مراكش)',
      nameFr: 'Place Jemaa el-Fnaa Marrakech',
      category: 'LANDMARK',
      city: 'مراكش',
      lat: 31.6258,
      lon: -7.9891,
      aliases: ['جامع الفنا', 'Jemaa Fna', 'ساحة مراكش'],
    },
    {
      id: 'twin-center',
      nameAr: 'البرجين التوأم (توران كازا - المعاريف)',
      nameFr: 'Twin Center Casablanca (Maârif)',
      category: 'LANDMARK',
      city: 'الدار البيضاء',
      lat: 33.5866,
      lon: -7.6338,
      aliases: ['التوين سنتر', 'توران', 'Twin Center', 'المعاريف توين'],
    },
  ];

  constructor(@Inject(DATABASE_POOL) private readonly db: Pool) { }

  /**
   * Search places in PostGIS table first, with fallback to static catalog
   */
  async search(query: string, proximity?: Coordinates, limit: number = 8): Promise<GeocodeResult[]> {
    const qLower = query.trim().toLowerCase();

    // 1. Try PostGIS query
    try {
      const sql = `
        SELECT 
          id, 
          name_ar, 
          name_fr, 
          category, 
          address_ar,
          ST_Y(location::geometry) as lat, 
          ST_X(location::geometry) as lon,
          ${proximity ? `ST_Distance(location::geography, ST_SetSRID(ST_MakePoint($2, $3), 4326)::geography) as dist` : '0 as dist'}
        FROM places
        WHERE 
          name_ar ILIKE $1 OR 
          name_fr ILIKE $1 OR 
          EXISTS (SELECT 1 FROM unnest(aliases) a WHERE a ILIKE $1)
        ORDER BY ${proximity ? 'dist ASC,' : ''} popularity_score DESC
        LIMIT $4
      `;

      const params = proximity
        ? [`%${query}%`, proximity.lon, proximity.lat, limit]
        : [`%${query}%`, limit];

      const res = await this.db.query(sql, params);

      if (res.rows && res.rows.length > 0) {
        return res.rows.map((row: any) => ({
          id: `place-${row.id}`,
          name: row.name_ar,
          label: `${row.name_ar} • ${row.name_fr}`,
          coordinates: { lat: parseFloat(row.lat), lon: parseFloat(row.lon) },
          category: row.category,
          country: 'Morocco',
          source: 'postgis_places',
          score: 1.0,
        }));
      }
    } catch (err: any) {
      // Table might not exist yet during migration
      this.logger.debug(`PostGIS places search fallback: ${err.message}`);
    }

    // 2. High-speed Static Catalog Matching (Airports, Stations, Malls, Universities)
    const matches = this.staticLandmarks.filter((p) => {
      const inAr = p.nameAr.toLowerCase().includes(qLower);
      const inFr = p.nameFr.toLowerCase().includes(qLower);
      const inCity = p.city.toLowerCase().includes(qLower);
      const inAlias = p.aliases.some((a) => a.toLowerCase().includes(qLower));
      return inAr || inFr || inCity || inAlias;
    });

    if (proximity) {
      matches.sort((a, b) => {
        const distA = Math.hypot(a.lat - proximity.lat, a.lon - proximity.lon);
        const distB = Math.hypot(b.lat - proximity.lat, b.lon - proximity.lon);
        return distA - distB;
      });
    }

    return matches.slice(0, limit).map((p) => ({
      id: `place-${p.id}`,
      name: p.nameAr,
      label: `${p.nameAr} • ${p.city}`,
      coordinates: { lat: p.lat, lon: p.lon },
      category: p.category,
      city: p.city,
      country: 'Morocco',
      source: 'postgis_places',
      score: 0.99,
    }));
  }
}

