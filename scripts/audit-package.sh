#!/usr/bin/env bash
#
# Strict package audit script for Trezoa crates
# Usage: ./scripts/audit-package.sh <crate-name>
#
# This script ensures that published .crate files contain ZERO
# forbidden references before they reach crates.io.

set -e

CRATE="${1:-trezoa-sdk}"
FORBIDDEN_PATTERN="(solana|\\bspl\\b|\\bsol\\b|anza|agave|coral\\.xyz)"

echo "=== Strict Package Audit ==="
echo "Crate: $CRATE"
echo "Commit: $(git rev-parse HEAD)"
echo ""

# Package the crate
echo "Packaging $CRATE..."
if ! cargo package -p "$CRATE" --allow-dirty 2>&1; then
    echo ""
    echo "⚠️  Package failed - likely due to missing dependencies"
    echo "This is EXPECTED if tpl-* crates are not yet on crates.io"
    echo ""
    echo "Status: Cannot audit package (dependencies not resolved)"
    exit 1
fi

# Find the generated .crate file
PKG=$(ls -1 target/package/"$CRATE"-*.crate 2>/dev/null | tail -n 1)

if [ -z "$PKG" ]; then
    echo "ERROR: Package file not found"
    exit 1
fi

echo "Package: $PKG"
echo ""

# Extract and scan
echo "Extracting package..."
rm -rf /tmp/trezoa_pkg
mkdir -p /tmp/trezoa_pkg
tar -xf "$PKG" -C /tmp/trezoa_pkg

echo "Scanning for forbidden references..."
echo ""

if rg -n --hidden --no-ignore -i "$FORBIDDEN_PATTERN" /tmp/trezoa_pkg; then
    MATCH_COUNT=$(rg -n --hidden --no-ignore -i "$FORBIDDEN_PATTERN" /tmp/trezoa_pkg | wc -l | tr -d ' ')
    echo ""
    echo "❌ FAIL: Found $MATCH_COUNT forbidden references in package"
    echo ""
    echo "DO NOT PUBLISH this crate to crates.io"
    exit 1
else
    echo "✅ PASS: Zero forbidden references in package"
    echo ""
    echo "Package is clean and ready for publication"
    exit 0
fi
