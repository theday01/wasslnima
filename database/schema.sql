-- ==============================================================================
-- WASSLNI (وصّلني) - Ride Hailing Platform Database Schema
-- Moroccan inDrive Architecture (Negotiation Model)
-- Database: PostgreSQL 16+ with PostGIS 3.4+
-- Currency: Moroccan Dirham (MAD)
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 2. ENUM TYPES
CREATE TYPE user_role_type AS ENUM ('RIDER', 'DRIVER', 'BOTH', 'ADMIN');
CREATE TYPE user_status_type AS ENUM ('PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED', 'BANNED', 'DELETED');
CREATE TYPE driver_operational_status AS ENUM ('OFFLINE', 'ONLINE', 'BUSY');
CREATE TYPE verification_status AS ENUM ('PENDING', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'EXPIRED');
CREATE TYPE document_type_enum AS ENUM (
    'CIN_FRONT', 'CIN_BACK', 
    'DRIVING_LICENSE_FRONT', 'DRIVING_LICENSE_BACK', 
    'PROFESSIONAL_CARD', 
    'VEHICLE_REGISTRATION', -- Carte Grise
    'INSURANCE', 
    'TECHNICAL_INSPECTION', -- Visite Technique
    'SELFIE_FACE_MATCH'
);
CREATE TYPE ride_status_type AS ENUM (
    'REQUESTED', 
    'OFFERS_RECEIVED', 
    'MATCHED', 
    'DRIVER_EN_ROUTE', 
    'ARRIVED_AT_PICKUP', 
    'IN_PROGRESS', 
    'COMPLETED', 
    'CANCELLED_BY_RIDER', 
    'CANCELLED_BY_DRIVER', 
    'EXPIRED'
);
CREATE TYPE offer_status_type AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'COUNTERED', 'EXPIRED', 'WITHDRAWN');
CREATE TYPE payment_method_type AS ENUM ('CASH', 'WALLET', 'CARD_CMI', 'CASH_PLUS', 'WAFACASH');
CREATE TYPE payment_status_type AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED');
CREATE TYPE transaction_type_enum AS ENUM ('TOPUP', 'RIDE_PAYMENT', 'COMMISSION_DEDUCTION', 'COMMISSION_REFUND', 'WITHDRAWAL', 'BONUS');
CREATE TYPE commission_status_type AS ENUM ('WAIVED', 'DUE', 'COLLECTED', 'FORGIVEN');
CREATE TYPE complaint_priority_type AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');
CREATE TYPE complaint_status_type AS ENUM ('OPEN', 'IN_INVESTIGATION', 'RESOLVED', 'DISMISSED');
CREATE TYPE sos_status_type AS ENUM ('TRIGGERED', 'POLICE_DISPATCHED', 'FALSE_ALARM', 'RESOLVED');

-- 3. CORE IDENTITY & USERS

-- Table: users (Master identity table)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(150),
    email VARCHAR(255) UNIQUE,
    avatar_url TEXT,
    language_preference VARCHAR(10) DEFAULT 'ar-MA',
    status user_status_type DEFAULT 'PENDING_VERIFICATION' NOT NULL,
    roles user_role_type[] DEFAULT ARRAY['RIDER']::user_role_type[] NOT NULL,
    device_id VARCHAR(255),
    fcm_token TEXT,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMPTZ,
    CONSTRAINT chk_moroccan_phone CHECK (phone_number ~ '^\+212[5-7][0-9]{8}$')
);

-- Table: riders (Rider specific profile)
CREATE TABLE riders (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    female_driver_only_preferred BOOLEAN DEFAULT FALSE NOT NULL,
    total_rides_count INTEGER DEFAULT 0 NOT NULL,
    completed_rides_count INTEGER DEFAULT 0 NOT NULL,
    cancelled_rides_count INTEGER DEFAULT 0 NOT NULL,
    rating_avg NUMERIC(3, 2) DEFAULT 5.00 NOT NULL,
    rating_count INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: drivers (Driver specific operational & legal profile)
CREATE TABLE drivers (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    operational_status driver_operational_status DEFAULT 'OFFLINE' NOT NULL,
    verification_status verification_status DEFAULT 'PENDING' NOT NULL,
    is_female BOOLEAN DEFAULT FALSE NOT NULL,
    current_location geography(Point, 4326),
    last_location_updated_at TIMESTAMPTZ,
    total_trips_count INTEGER DEFAULT 0 NOT NULL,
    completed_trips_count INTEGER DEFAULT 0 NOT NULL,
    cancelled_trips_count INTEGER DEFAULT 0 NOT NULL,
    acceptance_rate NUMERIC(5, 2) DEFAULT 100.00 NOT NULL,
    rating_avg NUMERIC(3, 2) DEFAULT 5.00 NOT NULL,
    rating_count INTEGER DEFAULT 0 NOT NULL,
    first_completed_ride_at TIMESTAMPTZ,
    free_commission_until TIMESTAMPTZ,
    accumulated_free_months_count INTEGER DEFAULT 0 NOT NULL,
    debt_limit_mad NUMERIC(10, 2) DEFAULT -500.00 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_max_free_months CHECK (accumulated_free_months_count <= 6)
);

-- Table: driver_documents (Legal compliance documents with CNDP requirements)
CREATE TABLE driver_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL REFERENCES drivers(id) ON DELETE CASCADE,
    document_type document_type_enum NOT NULL,
    document_number VARCHAR(100),
    file_s3_key TEXT NOT NULL,
    verification_status verification_status DEFAULT 'PENDING' NOT NULL,
    rejection_reason TEXT,
    expires_at DATE,
    verified_at TIMESTAMPTZ,
    verified_by UUID,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uq_driver_doc_type UNIQUE (driver_id, document_type)
);

-- Table: vehicle_categories (Service tiers: Eco, Comfort, Family, Taxi, etc.)
CREATE TABLE vehicle_categories (
    id VARCHAR(50) PRIMARY KEY, -- 'ECO', 'CONFORT', 'FAMILY_6', 'WOMEN_ONLY', 'PETIT_TAXI', 'GRAND_TAXI'
    name_ar VARCHAR(100) NOT NULL,
    name_fr VARCHAR(100) NOT NULL,
    name_ber VARCHAR(100),
    description TEXT,
    seat_capacity INTEGER NOT NULL,
    icon_url TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    sort_order INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: vehicles
CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL REFERENCES drivers(id) ON DELETE CASCADE,
    category_id VARCHAR(50) NOT NULL REFERENCES vehicle_categories(id),
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    color VARCHAR(30) NOT NULL,
    license_plate VARCHAR(30) NOT NULL UNIQUE,
    has_air_conditioning BOOLEAN DEFAULT TRUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 4. GEOGRAPHY, CITIES & PRICING

-- Table: cities (Moroccan metropolitan coverage)
CREATE TABLE cities (
    id VARCHAR(50) PRIMARY KEY, -- 'CASABLANCA', 'RABAT', 'MARRAKECH', etc.
    name_ar VARCHAR(100) NOT NULL,
    name_fr VARCHAR(100) NOT NULL,
    boundary geography(MultiPolygon, 4326),
    center_location geography(Point, 4326) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    default_commission_rate NUMERIC(5, 2) DEFAULT 8.00 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: zones (Neighborhoods, surge hotspots, transit hubs)
CREATE TABLE zones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_id VARCHAR(50) NOT NULL REFERENCES cities(id) ON DELETE CASCADE,
    name_ar VARCHAR(100) NOT NULL,
    name_fr VARCHAR(100) NOT NULL,
    boundary geography(Polygon, 4326) NOT NULL,
    is_surge_active BOOLEAN DEFAULT FALSE NOT NULL,
    surge_multiplier NUMERIC(3, 2) DEFAULT 1.00 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: city_pricing (Baseline negotiation price matrix per city & tier)
CREATE TABLE city_pricing (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_id VARCHAR(50) NOT NULL REFERENCES cities(id) ON DELETE CASCADE,
    category_id VARCHAR(50) NOT NULL REFERENCES vehicle_categories(id) ON DELETE CASCADE,
    base_fare_mad NUMERIC(10, 2) NOT NULL,
    per_km_rate_mad NUMERIC(10, 2) NOT NULL,
    per_minute_rate_mad NUMERIC(10, 2) NOT NULL,
    minimum_fare_mad NUMERIC(10, 2) NOT NULL,
    night_surge_percentage NUMERIC(5, 2) DEFAULT 20.00 NOT NULL, -- 22:00 to 06:00
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uq_city_category_pricing UNIQUE (city_id, category_id)
);

-- Table: airport_station_pricing (Specific flat or surcharge rules for CMN, ONCF)
CREATE TABLE airport_station_pricing (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_id VARCHAR(50) NOT NULL REFERENCES cities(id) ON DELETE CASCADE,
    hub_name VARCHAR(150) NOT NULL, -- 'Aéroport Mohammed V (CMN)', 'Gare Casa-Port', etc.
    hub_type VARCHAR(50) NOT NULL, -- 'AIRPORT', 'TRAIN_STATION'
    hub_location geography(Point, 4326) NOT NULL,
    flat_rate_mad NUMERIC(10, 2),
    pickup_surcharge_mad NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 5. RIDES & BIDDING LIFECYCLE (THE CORE ENGINE)

-- Table: ride_requests (Rider initiated request with suggested price)
CREATE TABLE ride_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id UUID NOT NULL REFERENCES riders(id) ON DELETE CASCADE,
    city_id VARCHAR(50) NOT NULL REFERENCES cities(id),
    category_id VARCHAR(50) NOT NULL REFERENCES vehicle_categories(id),
    pickup_location geography(Point, 4326) NOT NULL,
    pickup_address_text TEXT NOT NULL,
    pickup_landmark_description TEXT, -- 'حدا مرجان، قبالة القهوة'
    dropoff_location geography(Point, 4326) NOT NULL,
    dropoff_address_text TEXT NOT NULL,
    estimated_distance_km NUMERIC(8, 2) NOT NULL,
    estimated_duration_minutes INTEGER NOT NULL,
    calculated_reference_price_mad NUMERIC(10, 2) NOT NULL,
    rider_suggested_price_mad NUMERIC(10, 2) NOT NULL,
    preferred_payment_method payment_method_type DEFAULT 'CASH' NOT NULL,
    status ride_status_type DEFAULT 'REQUESTED' NOT NULL,
    broadcast_radius_meters INTEGER DEFAULT 1000 NOT NULL, -- Expands: 1km -> 3km -> 5km
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: ride_offers (Bids from nearby drivers)
CREATE TABLE ride_offers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL REFERENCES ride_requests(id) ON DELETE CASCADE,
    driver_id UUID NOT NULL REFERENCES drivers(id) ON DELETE CASCADE,
    offered_price_mad NUMERIC(10, 2) NOT NULL,
    estimated_arrival_minutes INTEGER NOT NULL,
    driver_current_distance_meters INTEGER,
    status offer_status_type DEFAULT 'PENDING' NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    CONSTRAINT uq_request_driver_offer UNIQUE (request_id, driver_id)
);

-- Table: rides (Partitioned by range of created_at - Confirmed ride after agreement)
CREATE TABLE rides (
    id UUID DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    rider_id UUID NOT NULL REFERENCES riders(id),
    driver_id UUID NOT NULL REFERENCES drivers(id),
    vehicle_id UUID NOT NULL REFERENCES vehicles(id),
    city_id VARCHAR(50) NOT NULL REFERENCES cities(id),
    category_id VARCHAR(50) NOT NULL REFERENCES vehicle_categories(id),
    pickup_location geography(Point, 4326) NOT NULL,
    pickup_address_text TEXT NOT NULL,
    pickup_landmark_description TEXT,
    dropoff_location geography(Point, 4326) NOT NULL,
    dropoff_address_text TEXT NOT NULL,
    agreed_price_mad NUMERIC(10, 2) NOT NULL,
    tip_amount_mad NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    total_amount_mad NUMERIC(10, 2) NOT NULL,
    payment_method payment_method_type DEFAULT 'CASH' NOT NULL,
    payment_status payment_status_type DEFAULT 'PENDING' NOT NULL,
    status ride_status_type DEFAULT 'MATCHED' NOT NULL,
    matched_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    driver_arrived_at TIMESTAMPTZ,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT,
    cancelled_by VARCHAR(20),
    actual_distance_km NUMERIC(8, 2),
    actual_duration_minutes INTEGER,
    share_token VARCHAR(64) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

-- Partition examples for rides
CREATE TABLE rides_y2026m11 PARTITION OF rides
    FOR VALUES FROM ('2026-11-01 00:00:00+00') TO ('2026-12-01 00:00:00+00');
CREATE TABLE rides_y2026m12 PARTITION OF rides
    FOR VALUES FROM ('2026-12-01 00:00:00+00') TO ('2027-01-01 00:00:00+00');

-- Table: ride_status_history
CREATE TABLE ride_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL,
    old_status ride_status_type,
    new_status ride_status_type NOT NULL,
    changed_by_user_id UUID,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: ride_locations_log (Partitioned Breadcrumbs GPS trace every 3-5 seconds)
CREATE TABLE ride_locations_log (
    id BIGSERIAL,
    ride_id UUID NOT NULL,
    location geography(Point, 4326) NOT NULL,
    speed_kmh NUMERIC(5, 2),
    heading_degrees NUMERIC(5, 2),
    recorded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id, recorded_at)
) PARTITION BY RANGE (recorded_at);

-- Partition examples for GPS breadcrumbs
CREATE TABLE ride_locations_log_y2026m11 PARTITION OF ride_locations_log
    FOR VALUES FROM ('2026-11-01 00:00:00+00') TO ('2026-12-01 00:00:00+00');
CREATE TABLE ride_locations_log_y2026m12 PARTITION OF ride_locations_log
    FOR VALUES FROM ('2026-12-01 00:00:00+00') TO ('2027-01-01 00:00:00+00');

-- 6. WALLETS, PAYMENTS & COMMISSIONS

-- Table: wallets
CREATE TABLE wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    balance_mad NUMERIC(12, 2) DEFAULT 0.00 NOT NULL,
    currency VARCHAR(3) DEFAULT 'MAD' NOT NULL,
    is_frozen BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: wallet_transactions
CREATE TABLE wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
    ride_id UUID,
    transaction_type transaction_type_enum NOT NULL,
    amount_mad NUMERIC(12, 2) NOT NULL,
    balance_after_mad NUMERIC(12, 2) NOT NULL,
    reference_id VARCHAR(100),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: payments
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL,
    payer_user_id UUID NOT NULL REFERENCES users(id),
    payee_user_id UUID REFERENCES users(id),
    amount_mad NUMERIC(10, 2) NOT NULL,
    payment_method payment_method_type NOT NULL,
    payment_status payment_status_type DEFAULT 'PENDING' NOT NULL,
    gateway_transaction_id VARCHAR(150),
    gateway_response JSONB,
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: commissions
CREATE TABLE commissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL,
    driver_id UUID NOT NULL REFERENCES drivers(id) ON DELETE CASCADE,
    rate_percentage NUMERIC(5, 2) NOT NULL,
    calculated_amount_mad NUMERIC(10, 2) NOT NULL,
    status commission_status_type DEFAULT 'DUE' NOT NULL,
    waiver_reason VARCHAR(100), -- '60_DAYS_FREE_PROMO', 'REFERRAL_FREE_MONTH'
    collected_via_wallet_transaction_id UUID REFERENCES wallet_transactions(id),
    collected_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: commission_waivers
CREATE TABLE commission_waivers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL REFERENCES drivers(id) ON DELETE CASCADE,
    reason VARCHAR(100) NOT NULL, -- 'FIRST_60_DAYS', 'REFERRAL_REWARD'
    valid_from TIMESTAMPTZ NOT NULL,
    valid_until TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 7. REFERRALS & PROMOTIONS

-- Table: driver_referrals (Moroccan driver acquisition program)
CREATE TABLE driver_referrals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referrer_driver_id UUID NOT NULL REFERENCES drivers(id) ON DELETE CASCADE,
    referred_driver_id UUID NOT NULL UNIQUE REFERENCES drivers(id) ON DELETE CASCADE,
    referral_code VARCHAR(30) NOT NULL,
    qualifying_rides_required INTEGER DEFAULT 5 NOT NULL,
    qualifying_rides_completed INTEGER DEFAULT 0 NOT NULL,
    is_reward_granted BOOLEAN DEFAULT FALSE NOT NULL,
    reward_granted_at TIMESTAMPTZ,
    suspected_fraud BOOLEAN DEFAULT FALSE NOT NULL,
    fraud_check_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: referral_rewards
CREATE TABLE referral_rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referral_id UUID NOT NULL REFERENCES driver_referrals(id) ON DELETE CASCADE,
    beneficiary_driver_id UUID NOT NULL REFERENCES drivers(id) ON DELETE CASCADE,
    reward_type VARCHAR(50) NOT NULL, -- 'ONE_FREE_MONTH', 'ONE_FREE_WEEK'
    free_days_count INTEGER NOT NULL,
    applied_from TIMESTAMPTZ NOT NULL,
    applied_until TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: promotions (Passenger promo codes)
CREATE TABLE promotions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(150) NOT NULL,
    discount_percentage NUMERIC(5, 2),
    discount_fixed_amount_mad NUMERIC(10, 2),
    max_discount_cap_mad NUMERIC(10, 2),
    city_id VARCHAR(50) REFERENCES cities(id),
    category_id VARCHAR(50) REFERENCES vehicle_categories(id),
    total_usage_limit INTEGER,
    per_user_limit INTEGER DEFAULT 1 NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: promo_usages
CREATE TABLE promo_usages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    promotion_id UUID NOT NULL REFERENCES promotions(id) ON DELETE CASCADE,
    rider_id UUID NOT NULL REFERENCES riders(id) ON DELETE CASCADE,
    ride_id UUID NOT NULL,
    discount_applied_mad NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 8. TRUST, SAFETY, RATINGS & SOS

-- Table: ratings
CREATE TABLE ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL,
    from_user_id UUID NOT NULL REFERENCES users(id),
    to_user_id UUID NOT NULL REFERENCES users(id),
    rating_score SMALLINT NOT NULL CHECK (rating_score BETWEEN 1 AND 5),
    tags TEXT[], -- ['نظافة السيارة', 'احترام الطريق', 'لطيف']
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: complaints
CREATE TABLE complaints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_number VARCHAR(30) NOT NULL UNIQUE,
    ride_id UUID,
    complainant_user_id UUID NOT NULL REFERENCES users(id),
    respondent_user_id UUID REFERENCES users(id),
    category VARCHAR(100) NOT NULL, -- 'OVERCHARGING', 'RUDE_BEHAVIOR', 'UNSAFE_DRIVING'
    priority complaint_priority_type DEFAULT 'MEDIUM' NOT NULL,
    status complaint_status_type DEFAULT 'OPEN' NOT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    resolution_notes TEXT,
    resolved_by UUID,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: sos_events (High alert safety events with Morocco Police 19 / Ambulance 15)
CREATE TABLE sos_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL,
    triggered_by_user_id UUID NOT NULL REFERENCES users(id),
    location geography(Point, 4326) NOT NULL,
    status sos_status_type DEFAULT 'TRIGGERED' NOT NULL,
    audio_recording_s3_key TEXT,
    notes TEXT,
    resolved_at TIMESTAMPTZ,
    resolved_by UUID,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: trusted_contacts
CREATE TABLE trusted_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id UUID NOT NULL REFERENCES riders(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    notify_on_ride_start BOOLEAN DEFAULT TRUE NOT NULL,
    notify_on_sos BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: saved_places
CREATE TABLE saved_places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id UUID NOT NULL REFERENCES riders(id) ON DELETE CASCADE,
    label VARCHAR(50) NOT NULL, -- 'الدار', 'الخدمة', 'المسجد'
    location geography(Point, 4326) NOT NULL,
    address_text TEXT NOT NULL,
    landmark_description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 9. COMMUNICATION & MESSAGING

-- Table: chat_messages
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL,
    sender_user_id UUID NOT NULL REFERENCES users(id),
    message_text TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: notifications (Partitioned)
CREATE TABLE notifications (
    id UUID DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    payload JSONB,
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE notifications_y2026m11 PARTITION OF notifications
    FOR VALUES FROM ('2026-11-01 00:00:00+00') TO ('2026-12-01 00:00:00+00');
CREATE TABLE notifications_y2026m12 PARTITION OF notifications
    FOR VALUES FROM ('2026-12-01 00:00:00+00') TO ('2027-01-01 00:00:00+00');

-- 10. ADMIN, RBAC & AUDIT LOGS

-- Table: admins
CREATE TABLE admins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    is_superadmin BOOLEAN DEFAULT FALSE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: admin_roles & permissions
CREATE TABLE admin_roles (
    id VARCHAR(50) PRIMARY KEY, -- 'OPERATIONS_MANAGER', 'FINANCE_MANAGER', 'SUPPORT_AGENT'
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE admin_permissions (
    id VARCHAR(100) PRIMARY KEY, -- 'drivers.verify', 'commissions.edit', 'sos.manage'
    module VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE role_permissions (
    role_id VARCHAR(50) REFERENCES admin_roles(id) ON DELETE CASCADE,
    permission_id VARCHAR(100) REFERENCES admin_permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE admin_role_assignments (
    admin_id UUID REFERENCES admins(id) ON DELETE CASCADE,
    role_id VARCHAR(50) REFERENCES admin_roles(id) ON DELETE CASCADE,
    PRIMARY KEY (admin_id, role_id)
);

-- Table: audit_logs (Partitioned, strictly append-only)
CREATE TABLE audit_logs (
    id BIGSERIAL,
    admin_id UUID,
    actor_type VARCHAR(50) NOT NULL,
    action VARCHAR(100) NOT NULL,
    entity_name VARCHAR(100) NOT NULL,
    entity_id VARCHAR(100),
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE audit_logs_y2026m11 PARTITION OF audit_logs
    FOR VALUES FROM ('2026-11-01 00:00:00+00') TO ('2026-12-01 00:00:00+00');
CREATE TABLE audit_logs_y2026m12 PARTITION OF audit_logs
    FOR VALUES FROM ('2026-12-01 00:00:00+00') TO ('2027-01-01 00:00:00+00');

-- Table: settings (Dynamic platform configuration)
CREATE TABLE settings (
    key VARCHAR(100) PRIMARY KEY,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: places (Pre-indexed landmarks for instant Moroccan POI resolution: Airports, Stations, Malls, Universities, Hospitals)
CREATE TABLE places (
    id VARCHAR(64) PRIMARY KEY,
    name_ar TEXT NOT NULL,
    name_fr TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address_ar TEXT,
    address_fr TEXT,
    aliases TEXT[] DEFAULT '{}',
    location GEOGRAPHY(Point, 4326) NOT NULL,
    popularity_score INTEGER DEFAULT 50,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 11. INDEXES

-- PostGIS Spatial Indexes (GIST)
CREATE INDEX idx_drivers_online_location ON drivers USING GIST (current_location) WHERE operational_status = 'ONLINE';
CREATE INDEX idx_ride_requests_pickup ON ride_requests USING GIST (pickup_location) WHERE status = 'REQUESTED';
CREATE INDEX idx_ride_requests_dropoff ON ride_requests USING GIST (dropoff_location);
CREATE INDEX idx_cities_boundary ON cities USING GIST (boundary);
CREATE INDEX idx_zones_boundary ON zones USING GIST (boundary);
CREATE INDEX idx_airport_hubs_location ON airport_station_pricing USING GIST (hub_location);
CREATE INDEX idx_places_location ON places USING GIST (location);
CREATE INDEX idx_places_category ON places (category);
CREATE INDEX idx_places_city ON places (city);

-- B-Tree Performance Indexes
CREATE INDEX idx_users_phone ON users (phone_number);
CREATE INDEX idx_ride_offers_request_status ON ride_offers (request_id, status);
CREATE INDEX idx_ride_offers_driver ON ride_offers (driver_id);
CREATE INDEX idx_rides_rider_status ON rides (rider_id, status);
CREATE INDEX idx_rides_driver_status ON rides (driver_id, status);
CREATE INDEX idx_driver_referrals_referrer ON driver_referrals (referrer_driver_id);
CREATE INDEX idx_driver_referrals_code ON driver_referrals (referral_code);
CREATE INDEX idx_commissions_driver_status ON commissions (driver_id, status);
CREATE INDEX idx_wallet_tx_wallet ON wallet_transactions (wallet_id, created_at DESC);
CREATE INDEX idx_complaints_status_priority ON complaints (status, priority);
CREATE INDEX idx_sos_status ON sos_events (status);
CREATE INDEX idx_chat_ride_created ON chat_messages (ride_id, created_at);

-- 12. TRIGGERS & PROCEDURES (Auto-update timestamps)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_riders_updated_at BEFORE UPDATE ON riders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_drivers_updated_at BEFORE UPDATE ON drivers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_vehicles_updated_at BEFORE UPDATE ON vehicles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_cities_updated_at BEFORE UPDATE ON cities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_city_pricing_updated_at BEFORE UPDATE ON city_pricing FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_ride_requests_updated_at BEFORE UPDATE ON ride_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_wallets_updated_at BEFORE UPDATE ON wallets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_complaints_updated_at BEFORE UPDATE ON complaints FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_places_updated_at BEFORE UPDATE ON places FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

