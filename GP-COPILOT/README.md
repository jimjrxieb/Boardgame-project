# Security Dashboard

![Security](https://img.shields.io/badge/security-good-yellow)
![Last Scan](https://img.shields.io/badge/last%20scan-2025--10--07-blue)
![Risk Score](https://img.shields.io/badge/risk%20score-37-yellow)

## Current Security Posture

| Severity | Count | Status |
|----------|-------|--------|
| 🔴 Critical | 0 | ✅ Clear |
| 🟠 High | 0 | ✅ Clear |
| 🟡 Medium | 18 | 📋 Review |
| 🟢 Low | 1 | 📋 Review |

**Total Findings:** 19
**Risk Score:** 37/100
**Scanners Used:** unknown, kics
**Last Scan:** 2025-10-07 00:52:28
**Scan ID:** 18302300830

## Quick Links

- 📊 [Executive Summary](reports/executive-summary.md) - For leadership
- 📋 [Detailed Analysis](reports/latest-analysis.md) - Full technical report

- 📦 [Raw Data](scans/latest/consolidated-results.json) - JSON export

## What is GP-Copilot?

GP-Copilot is an automated security analysis tool that:
- ✅ Analyzes your code for security vulnerabilities
- ✅ Parses multiple security scanners (KICS, Trivy, Checkov, etc.)
- ✅ Provides actionable fix recommendations
- ✅ Tracks security posture over time

## How to Use

### View Latest Results
```bash
# See findings summary
cat GP-COPILOT/reports/executive-summary.md

# See detailed analysis
cat GP-COPILOT/reports/latest-analysis.md
```

### Apply Fixes
```bash
# If HIGH/CRITICAL findings exist:
cat GP-COPILOT/fixes/active-fixes.md
# Follow the step-by-step instructions
```

### Re-scan After Fixes
```bash
# Commit your fixes, push, and wait for CI/CD to re-run
git add .
git commit -m "Security fixes applied"
git push

# GP-Copilot will automatically update this dashboard
```

---

*This dashboard is automatically updated by GP-Copilot after each security scan.*
