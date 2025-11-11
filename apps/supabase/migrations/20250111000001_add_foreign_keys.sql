-- ============================================================================
-- FOREIGN KEY CONSTRAINTS
-- ============================================================================
-- Created: 2025-01-11
-- Purpose: Establish referential integrity between tables
-- 
-- This ensures:
--   - Media records always reference valid properties
--   - User preferences reference valid users
--   - User swipes reference valid users and properties
--   - Cascading deletes prevent orphaned records
-- ============================================================================

-- ============================================================================
-- FOREIGN KEY: media -> properties
-- ============================================================================
-- When a property is deleted, its media should also be deleted

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'fk_media_properties'
  ) THEN
    ALTER TABLE public.media
      ADD CONSTRAINT fk_media_properties
      FOREIGN KEY (mls_number)
      REFERENCES public.properties(mls_number)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
    
    RAISE NOTICE '✅ Added foreign key: media -> properties';
  ELSE
    RAISE NOTICE '⚠️  Foreign key already exists: media -> properties';
  END IF;
END $$;

-- ============================================================================
-- FOREIGN KEY: user_preferences -> auth.users
-- ============================================================================
-- When a user is deleted, their preferences should also be deleted

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'fk_user_preferences_users'
  ) THEN
    ALTER TABLE public.user_preferences
      ADD CONSTRAINT fk_user_preferences_users
      FOREIGN KEY (user_id)
      REFERENCES auth.users(id)
      ON DELETE CASCADE;
    
    RAISE NOTICE '✅ Added foreign key: user_preferences -> auth.users';
  ELSE
    RAISE NOTICE '⚠️  Foreign key already exists: user_preferences -> auth.users';
  END IF;
END $$;

-- ============================================================================
-- FOREIGN KEY: user_properties -> auth.users
-- ============================================================================
-- When a user is deleted, their swipe history should also be deleted

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'fk_user_properties_users'
  ) THEN
    ALTER TABLE public.user_properties
      ADD CONSTRAINT fk_user_properties_users
      FOREIGN KEY (user_id)
      REFERENCES auth.users(id)
      ON DELETE CASCADE;
    
    RAISE NOTICE '✅ Added foreign key: user_properties -> auth.users';
  ELSE
    RAISE NOTICE '⚠️  Foreign key already exists: user_properties -> auth.users';
  END IF;
END $$;

-- ============================================================================
-- FOREIGN KEY: user_properties -> properties
-- ============================================================================
-- When a property is deleted, keep swipe history but mark as orphaned
-- We use SET NULL instead of CASCADE to preserve user behavior data

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'fk_user_properties_properties'
  ) THEN
    -- First, we need to allow mls_number to be nullable for SET NULL to work
    -- Check if we should do this based on data integrity needs
    
    ALTER TABLE public.user_properties
      ADD CONSTRAINT fk_user_properties_properties
      FOREIGN KEY (mls_number)
      REFERENCES public.properties(mls_number)
      ON DELETE RESTRICT  -- Prevent deletion of properties with swipes
      ON UPDATE CASCADE;
    
    RAISE NOTICE '✅ Added foreign key: user_properties -> properties (RESTRICT)';
  ELSE
    RAISE NOTICE '⚠️  Foreign key already exists: user_properties -> properties';
  END IF;
END $$;

-- ============================================================================
-- FOREIGN KEY: users -> auth.users (Optional - if using extended profile)
-- ============================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'fk_users_auth_users'
  ) THEN
    ALTER TABLE public.users
      ADD CONSTRAINT fk_users_auth_users
      FOREIGN KEY (id)
      REFERENCES auth.users(id)
      ON DELETE CASCADE;
    
    RAISE NOTICE '✅ Added foreign key: users -> auth.users';
  ELSE
    RAISE NOTICE '⚠️  Foreign key already exists: users -> auth.users';
  END IF;
END $$;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

DO $$
DECLARE
  fk_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO fk_count
  FROM pg_constraint
  WHERE conname IN (
    'fk_media_properties',
    'fk_user_preferences_users',
    'fk_user_properties_users',
    'fk_user_properties_properties',
    'fk_users_auth_users'
  );
  
  RAISE NOTICE '✅ Foreign key constraints migration completed';
  RAISE NOTICE 'Total foreign keys: %', fk_count;
END $$;
