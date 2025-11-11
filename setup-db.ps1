# HomeTinder - Database Setup Script
# This script sets up your local development database

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "🏠 HomeTinder - Database Setup" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Check if Supabase CLI is installed locally
Write-Host "🔍 Checking for Supabase CLI..." -ForegroundColor Yellow

# Check if npx can find supabase (either locally or globally)
$supabaseCheck = npx supabase --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Supabase CLI not found!" -ForegroundColor Red
    Write-Host "📦 Installing Supabase CLI locally..." -ForegroundColor Yellow
    
    # Navigate to root directory for package installation
    Set-Location -Path "$PSScriptRoot"
    
    # Install Supabase CLI as a dev dependency
    npm install --save-dev supabase@latest
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install Supabase CLI" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Supabase CLI installed locally" -ForegroundColor Green
} else {
    Write-Host "✅ Supabase CLI found" -ForegroundColor Green
    Write-Host $supabaseCheck
}

Write-Host ""

# Navigate to Supabase directory
Set-Location -Path "$PSScriptRoot\apps\supabase"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "🚀 Starting Supabase Local Instance" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Start Supabase (this will pull Docker images if needed)
Write-Host "📦 Starting Supabase services..." -ForegroundColor Yellow
npx supabase start

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to start Supabase" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📊 Applying Database Migrations" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Reset database and apply all migrations
Write-Host "🔄 Resetting database and applying migrations..." -ForegroundColor Yellow
npx supabase db reset

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to apply migrations" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ Database Setup Complete!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Get and display connection info
Write-Host "📋 Connection Information:" -ForegroundColor Cyan
Write-Host ""
npx supabase status

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Copy the API URL and Anon Key to your frontend/.env file" -ForegroundColor White
Write-Host "2. Start the frontend: cd frontend && npm run dev" -ForegroundColor White
Write-Host "3. Access Supabase Studio: http://127.0.0.1:54323" -ForegroundColor White
Write-Host ""
Write-Host "📚 Useful Commands:" -ForegroundColor Cyan
Write-Host "   npx supabase status       - Check status of local instance" -ForegroundColor White
Write-Host "   npx supabase stop         - Stop local instance" -ForegroundColor White
Write-Host "   npx supabase db reset     - Reset database and reapply migrations" -ForegroundColor White
Write-Host "   npx supabase db diff      - Generate migration from changes" -ForegroundColor White
Write-Host ""
