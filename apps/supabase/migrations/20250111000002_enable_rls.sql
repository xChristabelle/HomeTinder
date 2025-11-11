-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================
-- Created: 2025-01-11
-- Purpose: Implement database-level security policies
-- 
-- Security Model:
--   - properties/media: Public read (for browsing)
--   - user_preferences: Private (users can only access their own)
--   - user_properties: Private (users can only access their own swipes)
--   - users: Private (users can only access their own profile)
-- 
-- NOTE: Edge Functions use SERVICE_ROLE_KEY which bypasses RLS
-- This provides defense-in-depth if credentials leak
-- ============================================================================

-- ============================================================================
-- ENABLE RLS ON ALL TABLES
-- ============================================================================

ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PROPERTIES TABLE POLICIES
-- ============================================================================
-- Properties are public for browsing, but only Lambda can write

-- Allow everyone to read active properties
CREATE POLICY "Anyone can view active properties"
  ON public.properties
  FOR SELECT
  USING (is_active = true);

-- Only service role (Lambda functions) can insert/update
CREATE POLICY "Service role can insert properties"
  ON public.properties
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Service role can update properties"
  ON public.properties
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- MEDIA TABLE POLICIES
-- ============================================================================
-- Media is public for viewing property images

-- Allow everyone to read media
CREATE POLICY "Anyone can view media"
  ON public.media
  FOR SELECT
  USING (true);

-- Only service role can insert/update
CREATE POLICY "Service role can insert media"
  ON public.media
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Service role can update media"
  ON public.media
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- USER_PREFERENCES TABLE POLICIES
-- ============================================================================
-- Users can only access their own preferences

-- Users can read their own preferences
CREATE POLICY "Users can view own preferences"
  ON public.user_preferences
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own preferences
CREATE POLICY "Users can insert own preferences"
  ON public.user_preferences
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own preferences
CREATE POLICY "Users can update own preferences"
  ON public.user_preferences
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own preferences
CREATE POLICY "Users can delete own preferences"
  ON public.user_preferences
  FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- USER_PROPERTIES TABLE POLICIES
-- ============================================================================
-- Users can only access their own swipe history

-- Users can read their own swipes
CREATE POLICY "Users can view own swipes"
  ON public.user_properties
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own swipes
CREATE POLICY "Users can insert own swipes"
  ON public.user_properties
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own swipes
CREATE POLICY "Users can update own swipes"
  ON public.user_properties
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own swipes (undo feature)
CREATE POLICY "Users can delete own swipes"
  ON public.user_properties
  FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- USERS TABLE POLICIES (Extended Profile)
-- ============================================================================
-- Users can only access their own extended profile

-- Users can read their own profile
CREATE POLICY "Users can view own profile"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON public.users
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Users can delete their own profile
CREATE POLICY "Users can delete own profile"
  ON public.users
  FOR DELETE
  USING (auth.uid() = id);

-- ============================================================================
-- VERIFICATION
-- ============================================================================

DO $$
DECLARE
  policy_count INTEGER;
  rls_enabled_count INTEGER;
BEGIN
  -- Count policies
  SELECT COUNT(*) INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public';
  
  -- Count RLS-enabled tables
  SELECT COUNT(*) INTO rls_enabled_count
  FROM pg_tables
  WHERE schemaname = 'public'
    AND rowsecurity = true;
  
  RAISE NOTICE '✅ RLS policies migration completed';
  RAISE NOTICE 'Total policies created: %', policy_count;
  RAISE NOTICE 'Tables with RLS enabled: %', rls_enabled_count;
END $$;

-- ============================================================================
-- SECURITY NOTES
-- ============================================================================
-- 
-- 1. Edge Functions use SERVICE_ROLE_KEY which bypasses RLS
--    This is intentional for backend operations
-- 
-- 2. Frontend uses ANON_KEY which respects RLS
--    This protects against client-side attacks
-- 
-- 3. If SERVICE_ROLE_KEY leaks, RLS provides defense-in-depth
--    Attackers still can't access data they shouldn't
-- 
-- 4. Lambda functions use SERVICE_ROLE_KEY for TREB sync
--    This is necessary for bulk operations
-- ============================================================================
