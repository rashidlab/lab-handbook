#!/usr/bin/env bash
# =============================================================================
# Validate handbook build locally before pushing
# =============================================================================
# Run this script to catch common build errors before they break CI.
#
# Usage:
#   bash scripts/validate-build.sh
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDBOOK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$HANDBOOK_DIR"

echo "=========================================="
echo "Validating handbook build..."
echo "=========================================="
echo ""

errors=0

# Check 1: Broken symlinks
echo -n "Checking for broken symlinks... "
broken=$(find . -type l ! -exec test -e {} \; -print 2>/dev/null | grep -v ".git" || true)
if [ -n "$broken" ]; then
  echo -e "${RED}FAILED${NC}"
  echo "  Broken symlinks found:"
  echo "$broken" | sed 's/^/    /'
  echo "  Fix: Remove the symlinks or ensure targets exist"
  errors=$((errors + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# Check 2: .qmd files in assets/branding
echo -n "Checking for renderable templates in assets/branding... "
bad_files=$(find assets/branding -name "*.qmd" ! -name "*.qmd.txt" 2>/dev/null || true)
if [ -n "$bad_files" ]; then
  echo -e "${RED}FAILED${NC}"
  echo "  .qmd files found that will be rendered (and likely fail):"
  echo "$bad_files" | sed 's/^/    /'
  echo "  Fix: Rename to .qmd.txt to prevent Quarto from rendering"
  errors=$((errors + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# Check 3: _generated files exist
echo -n "Checking _generated tree files... "
missing_gen=""
for f in _generated/template-methods-paper-tree.md _generated/template-research-project-tree.md; do
  if [ ! -f "$f" ]; then
    missing_gen="$missing_gen $f"
  fi
done
if [ -n "$missing_gen" ]; then
  echo -e "${RED}FAILED${NC}"
  echo "  Missing files:$missing_gen"
  echo "  Fix: Run 'bash scripts/generate-template-trees.sh' and commit results"
  errors=$((errors + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# Check 4: config symlinks (common issue)
echo -n "Checking config directory for broken symlinks... "
if [ -d "config" ]; then
  config_broken=$(find config -type l ! -exec test -e {} \; -print 2>/dev/null || true)
  if [ -n "$config_broken" ]; then
    echo -e "${RED}FAILED${NC}"
    echo "  Broken symlinks in config/:"
    echo "$config_broken" | sed 's/^/    /'
    echo "  Fix: Remove these symlinks (they point to non-existent files)"
    errors=$((errors + 1))
  else
    echo -e "${GREEN}OK${NC}"
  fi
else
  echo -e "${GREEN}OK${NC} (no config directory)"
fi

# Check 5: Quarto installed
echo -n "Checking Quarto installation... "
if command -v quarto &> /dev/null; then
  version=$(quarto --version)
  echo -e "${GREEN}OK${NC} (v$version)"
else
  echo -e "${YELLOW}WARNING${NC}"
  echo "  Quarto not installed. Cannot test render locally."
  echo "  Install from: https://quarto.org/docs/get-started/"
fi

echo ""
echo "=========================================="
if [ $errors -gt 0 ]; then
  echo -e "${RED}Validation FAILED with $errors error(s)${NC}"
  echo "Fix the issues above before pushing."
  exit 1
else
  echo -e "${GREEN}All checks passed!${NC}"
  echo ""
  echo "Optional: Test full render with 'quarto render'"
fi
