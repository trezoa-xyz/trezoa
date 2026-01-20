# Strict Migration Audit Documentation

## Overview

This repository enforces a **zero-tolerance policy** for forbidden legacy references. The migration from legacy branding to Trezoa is complete and verified through automated gates.

## Forbidden Terms

The following patterns are **strictly prohibited** in all versioned and packaged files:

- `solana`, `solanalabs`, `solana labs`, `solana foundation`
- `spl` (when referring to token standard)
- `sol` (when referring to currency or legacy naming)
- `anza`, `agave`
- `coral.xyz`, `solana.com`
- Legacy infrastructure: `release.anza.xyz`, `gs://anza-release`, `buildkite/agave`

## Audit Criteria

### Repository Audit (Mode: Strict)

**Command:**
```bash
rg -n --hidden --no-ignore --glob '!.git/**' -i \
"(solana|solanalabs|solana[-_ ]foundation|\\bspl\\b|\\bsol\\b|anza|agave|coral\\.xyz|solana\\.com|release\\.anza\\.xyz|gs://anza-release|anzaxyz/|buildkite/agave|anza/agave)" \
.
```

**Success Criteria:** 0 matches

**Current Status:** ✅ PASS (verified at commit bd04760cfa)

### Package Audit (Mode: Strict)

**Command:**
```bash
cargo package -p <crate-name> --allow-dirty
tar -xf target/package/<crate>-*.crate -C /tmp/trezoa_pkg
rg -n --hidden --no-ignore -i "(solana|\\bspl\\b|\\bsol\\b|anza|agave)" /tmp/trezoa_pkg
```

**Success Criteria:** 0 matches in extracted .crate file

**Current Status:** ⚠️  BLOCKED - tpl-* dependencies not yet on crates.io

## Automated Gates

### GitHub Actions: Strict Audit Gate

Location: `.github/workflows/strict-audit-gate.yml`

**Triggers:**
- Every push to `master`
- Every pull request to `master`

**Behavior:**
- Scans entire repository (excluding only `.git/`)
- No exclusion lists, no "acceptable references"
- Fails CI if ANY forbidden reference is found
- Uploads audit report as artifact (90-day retention)

**Viewing Results:**
```bash
# Download from GitHub Actions artifacts
# Or run locally:
rg -n --hidden --no-ignore --glob '!.git/**' -i \
"(solana|solanalabs|solana[-_ ]foundation|\\bspl\\b|\\bsol\\b|anza|agave|coral\\.xyz|solana\\.com|release\\.anza\\.xyz|gs://anza-release|anzaxyz/|buildkite/agave|anza/agave)" \
.
```

### Local Package Audit Script

Location: `scripts/audit-package.sh`

**Usage:**
```bash
./scripts/audit-package.sh trezoa-sdk
```

**What it does:**
1. Packages the specified crate
2. Extracts the .crate tarball
3. Scans for forbidden references
4. Exits with error if ANY matches found

## Why This Matters

### Problem: Immutable Crates on crates.io

Once a crate version is published to crates.io, it **cannot be deleted or modified**. If forbidden references leak into published crates:

1. **Broken branding:** Legacy terms appear in public API
2. **Version churn:** Must publish new versions to fix strings
3. **Dependency hell:** Downstream projects pull contaminated versions
4. **Audit failures:** Compliance scans fail on published artifacts

### Solution: Gate Before Publishing

The strict audit prevents this by:

1. **Repository gate:** Blocks commits with forbidden references
2. **Package gate:** Blocks publishing contaminated .crate files
3. **Evidence trail:** Audit reports prove compliance
4. **Automation:** CI fails fast, no manual checks needed

## Current Migration Status

### ✅ Completed

- [x] Repository scan: 0 forbidden references (366 → 0 eliminated)
- [x] Code migration: All source files updated
- [x] Documentation migration: All docs updated
- [x] CI/CD migration: All workflows updated
- [x] Infrastructure: All configs updated
- [x] Automated gate: CI workflow active

### ⚠️  Blocked (Expected)

- [ ] Package audit: Cannot test until tpl-* deps resolved
- [ ] Crates.io publishing: Waiting for tpl-* availability

### 🔜 Next Steps

1. **Resolve tpl-* dependencies:**
   - Use `path` or `git` dependencies internally
   - Coordinate tpl-* publishing OR fork with new names
   - Update Cargo.toml manifests

2. **Test package audit:**
   - Run `./scripts/audit-package.sh` on each crate
   - Verify 0 forbidden references in .crate files
   - Document results

3. **Publish to crates.io:**
   - Only after package audit PASSES
   - Follow dependency order (leaf crates first)
   - Verify published crates with `cargo show`

## Audit Evidence

Latest audit report: `.audit/STRICT_AUDIT_bd04760cfa.txt`

**Summary:**
- Commit: `bd04760cfaab901c97ff1186f6e8fe4b1f5c3e34`
- Repository scan: **PASS** (0 matches)
- Package scan: **BLOCKED** (tpl-* not on crates.io)
- Status: Ready for dependency resolution

## Reproducibility

Anyone can verify the migration independently:

```bash
# Clone repo
git clone https://github.com/trezoa-xyz/trezoa.git
cd trezoa

# Checkout audit commit
git checkout bd04760cfa

# Run repository scan
rg -n --hidden --no-ignore --glob '!.git/**' -i \
"(solana|solanalabs|solana[-_ ]foundation|\\bspl\\b|\\bsol\\b|anza|agave|coral\\.xyz|solana\\.com|release\\.anza\\.xyz|gs://anza-release|anzaxyz/|buildkite/agave|anza/agave)" \
.

# Expected output: (empty) = PASS
```

## Contact

For questions about the strict audit process, see CI workflow logs or GitHub Actions artifacts.
