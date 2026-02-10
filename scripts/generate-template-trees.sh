#!/usr/bin/env bash
# =============================================================================
# Generate directory tree snippets for template handbook pages
# =============================================================================
# Called as a Quarto pre-render hook. Reads actual template repos and produces
# markdown code-block snippets in _generated/ that the .qmd files include.
#
# Requirements: python3, PyYAML
#
# Usage:
#   bash scripts/generate-template-trees.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDBOOK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PARENT_DIR="$(cd "$HANDBOOK_DIR/.." && pwd)"
GENERATED_DIR="$HANDBOOK_DIR/_generated"
ANNOTATIONS="$SCRIPT_DIR/tree-annotations.yml"
BUILD_TREE="$SCRIPT_DIR/build_tree.py"

mkdir -p "$GENERATED_DIR"

# Templates: repo-dir-name -> display-name for tree root
declare -A TEMPLATES=(
  ["template-methods-paper"]="my-paper"
  ["template-research-project"]="my-project"
  ["template-clinical-trial"]="my-trial"
)

for repo in "${!TEMPLATES[@]}"; do
  repo_path="$PARENT_DIR/$repo"
  display_name="${TEMPLATES[$repo]}"
  output_file="$GENERATED_DIR/${repo}-tree.md"

  if [ ! -d "$repo_path" ]; then
    echo "WARNING: $repo_path not found, skipping" >&2
    # Write fallback so {{< include >}} doesn't break the build
    printf '```\n%s/\n└── (template repo not available at build time)\n```\n' \
      "$display_name" > "$output_file"
    continue
  fi

  # Collect paths, excluding .git, .claude, .gitkeep
  (cd "$repo_path" && find . \
    -not -path './.git/*' \
    -not -path './.git' \
    -not -path './.claude/*' \
    -not -path './.claude' \
    -not -name '.gitkeep' \
    -not -path '.' \
    | sed 's|^\./||' | sort) \
  | python3 "$BUILD_TREE" "$repo" "$display_name" "$ANNOTATIONS" "$output_file"

done

echo "Template trees generated in $GENERATED_DIR/"
