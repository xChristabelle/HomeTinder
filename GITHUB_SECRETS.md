# GitHub Secrets Setup Checklist

Before deploying, ensure all required secrets are configured in your GitHub repository.

## 📍 Where to Add Secrets

1. Go to your GitHub repository: `https://github.com/xChristabelle/HomeTinder`
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

---

## ✅ Required Secrets

### 1. Supabase Secrets

#### `SUPABASE_ACCESS_TOKEN`

- **What:** Personal access token for Supabase CLI
- **How to get:**
  1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
  2. Click your profile (top right)
  3. Click **Access Tokens**
  4. Click **Generate New Token**
  5. Give it a name (e.g., "GitHub Actions - HomeTinder")
  6. Copy the token
- **Status:** ✅ Already configured (based on existing workflow)

#### `SUPABASE_PROJECT_REF`

- **What:** Your Supabase project reference ID
- **How to get:**
  1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
  2. Select your HomeTinder project
  3. Go to **Settings** → **General**
  4. Copy **Reference ID** (format: `abcdefghijklmnop`)
- **Status:** ✅ Already configured (based on existing workflow)

#### `SUPABASE_DB_PASSWORD` ⚠️ **NEW - REQUIRED**

- **What:** Your database password (needed for migrations)
- **How to get:**
  1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
  2. Select your HomeTinder project
  3. Go to **Settings** → **Database**
  4. Scroll to **Database Password**
  5. Click **Reset Database Password** if you don't have it
  6. Copy the password
- **Status:** ⚠️ **NEEDS TO BE ADDED**

---

### 2. AWS Secrets

#### `AWS_ACCESS_KEY_ID`

- **What:** AWS IAM access key for Lambda deployment
- **Status:** ✅ Already configured

#### `AWS_SECRET_ACCESS_KEY`

- **What:** AWS IAM secret key for Lambda deployment
- **Status:** ✅ Already configured

#### `AWS_REGION`

- **What:** AWS region where your Lambdas are deployed
- **Example:** `us-east-1` or `ca-central-1`
- **Status:** ✅ Already configured

---

## 🎯 Quick Add Instructions

### To add `SUPABASE_DB_PASSWORD`:

```bash
# 1. Copy your database password from Supabase Dashboard
# 2. Go to GitHub: Settings → Secrets and variables → Actions
# 3. Click "New repository secret"
# 4. Name: SUPABASE_DB_PASSWORD
# 5. Secret: [paste your database password]
# 6. Click "Add secret"
```

---

## ✅ Verification

After adding secrets, verify they're configured:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. You should see:
   - ✅ `AWS_ACCESS_KEY_ID`
   - ✅ `AWS_REGION`
   - ✅ `AWS_SECRET_ACCESS_KEY`
   - ✅ `SUPABASE_ACCESS_TOKEN`
   - ✅ `SUPABASE_DB_PASSWORD` ← New
   - ✅ `SUPABASE_PROJECT_REF`

---

## 🧪 Test Deployment

After adding all secrets:

```bash
# Create a test commit
git add .
git commit -m "test: Verify GitHub Actions with new secrets"
git push origin dev

# Monitor deployment
# Go to: Actions tab on GitHub
# Watch the workflow run
```

---

## 🔐 Security Best Practices

- ❌ Never commit secrets to git
- ❌ Never share secrets in plain text (Slack, email, etc.)
- ✅ Rotate secrets regularly (every 90 days)
- ✅ Use separate secrets for dev/staging/production
- ✅ Audit secret access logs periodically

---

## 🆘 If Deployment Fails

### Common Issues:

1. **"Authentication failed"**

   - Check `SUPABASE_ACCESS_TOKEN` is valid
   - Regenerate token if expired

2. **"Could not connect to database"**

   - Check `SUPABASE_DB_PASSWORD` is correct
   - Try resetting database password

3. **"AWS credentials invalid"**

   - Check AWS keys haven't expired
   - Verify IAM user has Lambda permissions

4. **"Permission denied"**
   - Check IAM user has correct policies:
     - `AWSLambdaFullAccess` or custom policy
     - S3 access for deployment artifacts
