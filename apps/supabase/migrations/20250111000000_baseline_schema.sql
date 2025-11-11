-- ============================================================================
-- BASELINE MIGRATION - HomeTinder Database Schema
-- ============================================================================
-- Created: 2025-01-11
-- Purpose: Document and establish the baseline schema for HomeTinder
-- 
-- IMPORTANT: This migration documents tables that were manually created via
-- Supabase Dashboard. It uses "IF NOT EXISTS" to safely handle both scenarios:
--   1. Production: Tables exist, migration becomes no-op
--   2. New environments: Tables get created properly
-- ============================================================================

-- Enable UUID extension (required for user IDs)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- TABLE: properties
-- ============================================================================
-- Purpose: Stores real estate property listings from TREB API
-- Primary Key: mls_number (unique MLS listing number)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.properties (
  id BIGSERIAL,
  mls_number TEXT PRIMARY KEY,
  address TEXT,
  address2 TEXT,
  postal_code TEXT,
  city TEXT,
  country TEXT,
  price NUMERIC(12, 2),
  bedrooms INTEGER,
  bathrooms INTEGER,
  property_type TEXT,
  property_subtype TEXT,
  transaction_type TEXT,
  description TEXT,
  is_active BOOLEAN DEFAULT true NOT NULL,
  last_timestamp TIMESTAMPTZ,
  last_key TEXT,
  lot_depth TEXT,
  lot_width TEXT,
  object JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Add comment for documentation
COMMENT ON TABLE public.properties IS 'Real estate property listings from TREB (Toronto Real Estate Board) API';
COMMENT ON COLUMN public.properties.mls_number IS 'Unique MLS (Multiple Listing Service) identifier';
COMMENT ON COLUMN public.properties.object IS 'Full JSON response from TREB API for reference';
COMMENT ON COLUMN public.properties.is_active IS 'Whether property is currently available (synced by activeSync Lambda)';
COMMENT ON COLUMN public.properties.last_timestamp IS 'ModificationTimestamp from TREB API (for incremental sync)';
COMMENT ON COLUMN public.properties.last_key IS 'ListingKey from TREB API (for cursor pagination)';

-- ============================================================================
-- TABLE: media
-- ============================================================================
-- Purpose: Stores property images/media URLs
-- Primary Key: mls_number (one-to-one with properties)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.media (
  mls_number TEXT PRIMARY KEY,
  image_urls TEXT[] NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

COMMENT ON TABLE public.media IS 'Property images and media URLs';
COMMENT ON COLUMN public.media.image_urls IS 'Array of image URLs fetched from TREB Media API';

-- ============================================================================
-- TABLE: user_preferences
-- ============================================================================
-- Purpose: Stores user search/filter preferences
-- Primary Key: user_id (one-to-one with auth.users)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.user_preferences (
  user_id UUID PRIMARY KEY,
  min_price NUMERIC(12, 2),
  max_price NUMERIC(12, 2),
  property_type TEXT DEFAULT 'House',
  transaction_type TEXT DEFAULT 'Sale',
  min_beds INTEGER,
  min_baths INTEGER,
  location_lat NUMERIC(10, 7),
  location_lng NUMERIC(10, 7),
  radius_m INTEGER DEFAULT 5000,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

COMMENT ON TABLE public.user_preferences IS 'User property search preferences and filters';
COMMENT ON COLUMN public.user_preferences.radius_m IS 'Search radius in meters from location point';
COMMENT ON COLUMN public.user_preferences.location_lat IS 'Preferred location latitude';
COMMENT ON COLUMN public.user_preferences.location_lng IS 'Preferred location longitude';

-- ============================================================================
-- TABLE: user_properties
-- ============================================================================
-- Purpose: Stores user swipe actions (likes/dislikes)
-- Primary Key: id (UUID)
-- Unique Constraint: (user_id, mls_number) - one action per property per user
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.user_properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  mls_number TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('liked', 'disliked')),
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  UNIQUE(user_id, mls_number)
);

COMMENT ON TABLE public.user_properties IS 'User swipe actions (likes/dislikes) on properties';
COMMENT ON COLUMN public.user_properties.status IS 'User action: liked or disliked';

-- ============================================================================
-- TABLE: users (Extended Profile - Optional)
-- ============================================================================
-- Purpose: Extended user profile beyond Supabase Auth
-- Primary Key: id (references auth.users.id)
-- Note: Currently not actively used, but included for future profile features
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  first_name TEXT,
  last_name TEXT,
  phone_number TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

COMMENT ON TABLE public.users IS 'Extended user profile data (supplements auth.users)';

-- ============================================================================
-- BASIC INDEXES (Performance optimization)
-- ============================================================================

-- Properties indexes
CREATE INDEX IF NOT EXISTS idx_properties_is_active 
  ON public.properties(is_active) 
  WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_properties_city 
  ON public.properties(city);

CREATE INDEX IF NOT EXISTS idx_properties_price 
  ON public.properties(price);

CREATE INDEX IF NOT EXISTS idx_properties_created_at 
  ON public.properties(created_at DESC);

-- User properties indexes
CREATE INDEX IF NOT EXISTS idx_user_properties_user_id 
  ON public.user_properties(user_id);

CREATE INDEX IF NOT EXISTS idx_user_properties_mls_number 
  ON public.user_properties(mls_number);

CREATE INDEX IF NOT EXISTS idx_user_properties_status 
  ON public.user_properties(user_id, status);

-- ============================================================================
-- TRIGGERS (Automatic timestamp updates)
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all tables with updated_at
CREATE TRIGGER update_properties_updated_at 
  BEFORE UPDATE ON public.properties
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_media_updated_at 
  BEFORE UPDATE ON public.media
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_user_preferences_updated_at 
  BEFORE UPDATE ON public.user_preferences
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_user_properties_updated_at 
  BEFORE UPDATE ON public.user_properties
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_users_updated_at 
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ============================================================================
-- VERIFICATION
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '✅ Baseline schema migration completed successfully';
  RAISE NOTICE 'Tables created: properties, media, user_preferences, user_properties, users';
  RAISE NOTICE 'Indexes created: 7 performance indexes';
  RAISE NOTICE 'Triggers created: 5 auto-update triggers';
END $$;
