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

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDBOOK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PARENT_DIR="$(cd "$HANDBOOK_DIR/.." && pwd)"
GENERATED_DIR="$HANDBOOK_DIR/_generated"
ANNOTATIONS="$SCRIPT_DIR/tree-annotations.yml"
BUILD_TREE="$SCRIPT_DIR/build_tree.py"

mkdir -p "$GENERATED_DIR"

# Generate tree for a single template
# Usage: generate_tree repo_name display_name
generate_tree() {
  local repo="$1"
  local display_name="$2"
  local repo_path="$PARENT_DIR/$repo"
  local output_file="$GENERATED_DIR/${repo}-tree.md"

  if [ ! -d "$repo_path" ]; then
    echo "WARNING: $repo_path not found, skipping" >&2
    # Only write fallback if file doesn't already exist (preserve committed files)
    if [ ! -f "$output_file" ]; then
      printf '```\n%s/\n└── (template repo not available at build time)\n```\n' \
        "$display_name" > "$output_file"
    fi
    return
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
}

# Templates: repo-dir-name display-name
generate_tree "template-methods-paper" "my-paper"
generate_tree "template-research-project" "my-project"
generate_tree "template-clinical-trial" "my-trial"

echo "Template trees generated in $GENERATED_DIR/"
