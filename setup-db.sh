#!/bin/bash

# HomeTinder - Database Setup Script
# This script sets up your local development database

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏠 HomeTinder - Database Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Supabase CLI is installed locally
echo "🔍 Checking for Supabase CLI..."

# Check if npx can find supabase (either locally or globally)
if npx supabase --version > /dev/null 2>&1; then
    echo "✅ Supabase CLI found"
    npx supabase --version
else
    echo "❌ Supabase CLI not found!"
    echo "📦 Installing Supabase CLI locally..."
    
    # Get the script directory
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    # Navigate to root directory for package installation
    cd "$SCRIPT_DIR"
    
    # Install Supabase CLI as a dev dependency
    npm install --save-dev supabase@latest
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install Supabase CLI"
        exit 1
    fi
    echo "✅ Supabase CLI installed locally"
fi

echo ""

# Navigate to Supabase directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/apps/supabase"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Starting Supabase Local Instance"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Start Supabase (this will pull Docker images if needed)
echo "📦 Starting Supabase services..."
npx supabase start

if [ $? -ne 0 ]; then
    echo "❌ Failed to start Supabase"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Applying Database Migrations"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Reset database and apply all migrations
echo "🔄 Resetting database and applying migrations..."
npx supabase db reset

if [ $? -ne 0 ]; then
    echo "❌ Failed to apply migrations"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Database Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get and display connection info
echo "📋 Connection Information:"
echo ""
npx supabase status

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Copy the API URL and Anon Key to your frontend/.env file"
echo "2. Start the frontend: cd frontend && npm run dev"
echo "3. Access Supabase Studio: http://127.0.0.1:54323"
echo ""
echo "📚 Useful Commands:"
echo "   npx supabase status       - Check status of local instance"
echo "   npx supabase stop         - Stop local instance"
echo "   npx supabase db reset     - Reset database and reapply migrations"
echo "   npx supabase db diff      - Generate migration from changes"
echo ""
