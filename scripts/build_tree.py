#!/usr/bin/env python3
"""Build an annotated directory tree from a list of paths and a YAML annotation map.

Usage:
    find ... | python3 build_tree.py <repo_name> <display_name> <annotations.yml> <output.md>
"""

import sys
import yaml

def main():
    repo_name = sys.argv[1]
    display_name = sys.argv[2]
    annotations_file = sys.argv[3]
    output_file = sys.argv[4]

    # Read paths from stdin
    paths_raw = sys.stdin.read().strip()
    paths = paths_raw.split("\n") if paths_raw else []

    # Load annotations
    with open(annotations_file, "r") as f:
        all_annotations = yaml.safe_load(f) or {}
    annotations = all_annotations.get(repo_name, {})

    # Track which paths are directories (appear as parent of another path)
    dir_paths = set()
    for p in paths:
        parts = p.split("/")
        for depth in range(1, len(parts)):
            dir_paths.add("/".join(parts[:depth]))

    # Build a tree structure: nested dicts
    tree = {}
    for p in paths:
        parts = p.split("/")
        node = tree
        for part in parts:
            if part not in node:
                node[part] = {}
            node = node[part]

    def get_annotation(path_key):
        """Look up annotation, trying with and without trailing /."""
        for key in [path_key, path_key + "/", path_key.rstrip("/")]:
            if key in annotations:
                return annotations[key]
        return None

    def is_known_dir(path_key):
        """Check if a path is a directory (has children, is a parent in the
        path list, or has a trailing-/ annotation key)."""
        return (
            path_key in dir_paths
            or (path_key + "/") in annotations
        )

    def render_tree(node, prefix="", parent_path=""):
        """Render a tree dict into lines with box-drawing characters."""
        lines = []
        entries = sorted(node.keys())
        for i, name in enumerate(entries):
            is_last = i == len(entries) - 1
            connector = "└── " if is_last else "├── "
            child_prefix = "    " if is_last else "│   "

            children = node[name]
            path_key = (parent_path + "/" + name).lstrip("/")
            is_dir = bool(children) or is_known_dir(path_key)
            display = name + "/" if is_dir else name

            ann = get_annotation(path_key)
            comment = f"  # {ann}" if ann else ""

            lines.append(f"{prefix}{connector}{display}{comment}")

            if children:
                lines.extend(
                    render_tree(children, prefix + child_prefix, path_key)
                )

        return lines

    lines = [f"{display_name}/"]
    lines.extend(render_tree(tree))

    output = "```\n" + "\n".join(lines) + "\n```\n"

    with open(output_file, "w") as f:
        f.write(output)

    print(f"  Generated: {output_file}")


if __name__ == "__main__":
    main()
