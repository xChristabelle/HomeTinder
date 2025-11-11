-- ============================================================================
-- ADDITIONAL PERFORMANCE INDEXES
-- ============================================================================
-- Created: 2025-01-11
-- Purpose: Optimize common query patterns
-- 
-- Query Patterns Optimized:
--   1. Property filtering by price, location, type
--   2. User swipe history lookups
--   3. Active property searches
--   4. Geographic searches (location-based)
-- 
-- NOTE: CONCURRENTLY cannot be used in migrations (which run in transactions)
--       For production, indexes are created as part of the initial migration
-- ============================================================================

-- ============================================================================
-- PROPERTIES TABLE INDEXES
-- ============================================================================

-- Composite index for active properties with price range
CREATE INDEX IF NOT EXISTS idx_properties_active_price_type
  ON public.properties(is_active, price, property_type)
  WHERE is_active = true;

-- Index for transaction type filtering
CREATE INDEX IF NOT EXISTS idx_properties_transaction_type
  ON public.properties(transaction_type)
  WHERE is_active = true;

-- Index for bedroom/bathroom filtering
CREATE INDEX IF NOT EXISTS idx_properties_beds_baths
  ON public.properties(bedrooms, bathrooms)
  WHERE is_active = true;

-- Full-text search index on address and description
CREATE INDEX IF NOT EXISTS idx_properties_search
  ON public.properties 
  USING GIN (to_tsvector('english', 
    COALESCE(address, '') || ' ' || 
    COALESCE(city, '') || ' ' || 
    COALESCE(description, '')
  ));

-- Index for Lambda sync operations (incremental fetch)
CREATE INDEX IF NOT EXISTS idx_properties_sync_cursor
  ON public.properties(last_timestamp, last_key);

-- Index for city-based searches (popular filter)
CREATE INDEX IF NOT EXISTS idx_properties_city_active
  ON public.properties(city, is_active)
  WHERE is_active = true;

-- ============================================================================
-- USER_PROPERTIES TABLE INDEXES
-- ============================================================================

-- Composite index for user's liked properties
CREATE INDEX IF NOT EXISTS idx_user_properties_user_liked
  ON public.user_properties(user_id, created_at DESC)
  WHERE status = 'liked';

-- Composite index for user's disliked properties
CREATE INDEX IF NOT EXISTS idx_user_properties_user_disliked
  ON public.user_properties(user_id, created_at DESC)
  WHERE status = 'disliked';

-- Index for property lookup (to check if user already swiped)
CREATE INDEX IF NOT EXISTS idx_user_properties_mls_lookup
  ON public.user_properties(mls_number, user_id);

-- ============================================================================
-- USER_PREFERENCES TABLE INDEXES
-- ============================================================================

-- Index for geographic searches (lat/lng radius queries)
-- This enables efficient distance calculations
CREATE INDEX IF NOT EXISTS idx_user_preferences_location
  ON public.user_preferences(location_lat, location_lng)
  WHERE location_lat IS NOT NULL AND location_lng IS NOT NULL;

-- ============================================================================
-- VERIFICATION & STATISTICS
-- ============================================================================

DO $$
DECLARE
  index_count INTEGER;
  total_size TEXT;
BEGIN
  -- Count all indexes on public schema
  SELECT COUNT(*) INTO index_count
  FROM pg_indexes
  WHERE schemaname = 'public';
  
  -- Get total index size
  SELECT pg_size_pretty(SUM(pg_relation_size(indexrelid))::bigint) INTO total_size
  FROM pg_index
  JOIN pg_class ON pg_class.oid = pg_index.indexrelid
  JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
  WHERE pg_namespace.nspname = 'public';
  
  RAISE NOTICE '✅ Performance indexes migration completed';
  RAISE NOTICE 'Total indexes in public schema: %', index_count;
  RAISE NOTICE 'Total index size: %', total_size;
  
  -- Recommend ANALYZE for query planner
  RAISE NOTICE '💡 Run ANALYZE to update statistics for query planner';
END $$;

-- ============================================================================
-- UPDATE TABLE STATISTICS
-- ============================================================================
-- Help PostgreSQL query planner make better decisions

ANALYZE public.properties;
ANALYZE public.media;
ANALYZE public.user_preferences;
ANALYZE public.user_properties;
ANALYZE public.users;

-- ============================================================================
-- INDEX USAGE MONITORING QUERY
-- ============================================================================
-- Run this query periodically to check if indexes are being used:
-- 
-- SELECT
--   schemaname,
--   tablename,
--   indexname,
--   idx_scan as index_scans,
--   idx_tup_read as tuples_read,
--   idx_tup_fetch as tuples_fetched,
--   pg_size_pretty(pg_relation_size(indexrelid)) as index_size
-- FROM pg_stat_user_indexes
-- WHERE schemaname = 'public'
-- ORDER BY idx_scan ASC;
-- 
-- If idx_scan is 0, the index may not be needed
-- ============================================================================
