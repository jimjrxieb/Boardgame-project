# Security Scanning Configuration

## Active Scans (Always Run)

### 1. Trivy FS Scan ✅
**Status:** Active
**Configuration:** None required
**Severity:** CRITICAL
**Exit Code:** Fails pipeline on CRITICAL vulnerabilities

```yaml
- name: Trivy FS scan
  run: trivy fs . --exit-code 1 --severity CRITICAL
```

### 2. Trivy Image Scan ✅
**Status:** Active
**Configuration:** None required
**Target:** Docker image

```yaml
- name: Trivy Image Scan
  run: trivy image --format table -o trivy-image-report.html linksrobot/gh_actions:latest
```

### 3. OWASP Dependency-Check ✅
**Status:** Active
**Configuration:** None required
**Output:** JSON report artifact

```yaml
- name: Run OWASP Dependency-Check
  run: /usr/local/bin/dependency-check/bin/dependency-check.sh --format JSON --out dependency-check-report.json --scan .
```

---

## Optional Scans (Require API Keys/Secrets)

### 1. SonarQube/SonarCloud 🔧
**Status:** Optional (disabled if secrets not configured)
**Required Secrets:**
- `SONAR_TOKEN`
- `SONAR_HOST_URL`

**Setup Options:**

#### Option A: SonarCloud (Free for Public Repos)
1. Sign up at https://sonarcloud.io
2. Create new project
3. Add GitHub secrets:
   ```bash
   gh secret set SONAR_TOKEN --body "your_token_here"
   gh secret set SONAR_HOST_URL --body "https://sonarcloud.io"
   ```
4. Update `sonar-project.properties`:
   ```properties
   sonar.organization=your-org
   sonar.projectKey=your-project-key
   sonar.host.url=https://sonarcloud.io
   ```

#### Option B: Self-Hosted SonarQube
1. Deploy SonarQube server
2. Generate authentication token
3. Add GitHub secrets with your server URL

**Current Behavior:** Skipped silently if secrets not configured

---

### 2. TruffleHog Enterprise 🔧
**Status:** Optional (continues on error)
**Required:** TruffleHog Enterprise account

**Purpose:** Advanced secrets detection

**Setup:**
1. Sign up for TruffleHog Enterprise
2. Configure enterprise settings
3. The action will auto-authenticate via GitHub App

**Current Behavior:** Attempts to run but continues on failure

---

### 3. GitGuardian 🔧
**Status:** Optional (disabled if secret not configured)
**Required Secret:** `GITGUARDIAN_API_KEY`

**Purpose:** Secrets and credential scanning

**Setup:**
1. Sign up at https://www.gitguardian.com
2. Generate API key
3. Add to GitHub secrets:
   ```bash
   gh secret set GITGUARDIAN_API_KEY --body "your_api_key_here"
   ```

**Current Behavior:** Skipped if secret not configured

---

## Comprehensive Security Scan Workflow

The separate `security_scan.yml` workflow provides additional scans:

- ✅ Trivy FS & Dependency scans
- ✅ Snyk security analysis (requires `SNYK_TOKEN`)
- ✅ KICS infrastructure-as-code scanning
- ✅ Compliance validation (SOC 2, PCI DSS, GDPR)

---

## Secrets Configuration

### Currently Required for Full CI/CD Pipeline
```bash
# Docker
DOCKER_USER=your_dockerhub_username
DOCKER_CRED=your_dockerhub_token

# Kubernetes (if deploying)
KUBE_CONFIG=base64_encoded_kubeconfig
```

### Optional Security Tools
```bash
# SonarQube/SonarCloud
SONAR_TOKEN=your_sonar_token
SONAR_HOST_URL=https://sonarcloud.io

# GitGuardian
GITGUARDIAN_API_KEY=your_gitguardian_key

# Snyk (used in security_scan.yml)
SNYK_TOKEN=your_snyk_token
```

---

## Setting GitHub Secrets

### Via GitHub CLI
```bash
gh secret set SECRET_NAME --body "secret_value" --repo jimjrxieb/CLOUD-project
```

### Via GitHub Web UI
1. Go to repository settings
2. Navigate to "Secrets and variables" → "Actions"
3. Click "New repository secret"
4. Add name and value

---

## Current Security Posture

✅ **Zero CRITICAL vulnerabilities** (verified via Trivy)
✅ **Core security scanning** (Trivy, OWASP)
✅ **Container security hardening**
✅ **Compliance validation** (SOC 2, PCI DSS, GDPR)

🔧 **Optional enhancements available:**
- SonarQube/SonarCloud for code quality
- GitGuardian for secrets detection
- Snyk for dependency intelligence
- TruffleHog Enterprise for advanced secrets scanning

---

## Recommendations

### For Public Portfolio Projects
**Minimum (Free):**
- ✅ Trivy (included)
- ✅ OWASP Dependency-Check (included)
- 🔧 SonarCloud (free for public repos)
- 🔧 Snyk (free tier available)

### For Production/Enterprise
**Enhanced:**
- All minimum tools
- GitGuardian (paid)
- TruffleHog Enterprise (paid)
- Self-hosted SonarQube (better control)

---

## Troubleshooting

### Pipeline Failing on Optional Scans
**Symptom:** "Connection timeout" or "Authentication failed"

**Solution:** These scans are now optional and won't block the pipeline. Check that:
1. Required secrets are set (for Docker, K8s deployment)
2. Optional scans show as "skipped" or "passed with warnings"

### Adding New Security Tools
1. Add step to `.github/workflows/gh_actions.yml`
2. Use `continue-on-error: true` for optional tools
3. Use `if: ${{ secrets.SECRET_NAME != '' }}` to skip if not configured
4. Document in this file

---

## Verification

```bash
# Check configured secrets (names only, not values)
gh secret list --repo jimjrxieb/CLOUD-project

# Run local Trivy scan
trivy fs . --severity CRITICAL,HIGH

# Test OWASP Dependency-Check locally
dependency-check --scan . --format JSON --out report.json
```
