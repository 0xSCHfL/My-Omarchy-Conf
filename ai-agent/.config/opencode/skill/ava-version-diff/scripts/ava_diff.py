#!/usr/bin/env python3
"""
AVA Version Diff — Read-only comparison between upstream AVA and user's fork.

Usage:
    python3 ava_diff.py [--base BASE_REF] [--target TARGET_REF] [--file FILE]

Defaults:
    base  = upstream/main
    target = current branch HEAD
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], check: bool = True) -> str:
    """Run a git command and return stdout."""
    result = subprocess.run(
        cmd, capture_output=True, text=True, check=check
    )
    return result.stdout.strip()


def ensure_remotes() -> None:
    """Add upstream remote if missing."""
    remotes = run(["git", "remote"], check=False)
    if "upstream" not in remotes.splitlines():
        print("[setup] Adding upstream remote...")
        run([
            "git", "remote", "add", "upstream",
            "https://github.com/hkjarral/AVA-AI-Voice-Agent-for-Asterisk.git"
        ])


def fetch_upstream() -> None:
    """Fetch latest from upstream."""
    print("[fetch] Fetching upstream...")
    run(["git", "fetch", "upstream"])


def get_merge_base(base: str, target: str) -> str:
    """Find the merge base between base and target."""
    return run(["git", "merge-base", target, base])


AVA_DIRS = ["src/", "admin_ui/", "config/", "docker-compose.admin-ui-host-binaries.yml", "docker-compose.gpu.yml", "docker-compose.host.yml", "docker-compose.local-core.yml", "docker-compose.yml"]


def get_diff_stat(base: str, target: str) -> str:
    """Get diff stat between base and target (AVA dirs only)."""
    cmd = ["git", "diff", "--stat", f"{base}..{target}"] + AVA_DIRS
    return run(cmd, check=False)


def get_changed_files(base: str, target: str) -> list[str]:
    """List files changed between base and target (AVA dirs only)."""
    cmd = ["git", "diff", "--name-status", f"{base}..{target}"] + AVA_DIRS
    output = run(cmd, check=False)
    files = []
    for line in output.splitlines():
        if line.strip():
            parts = line.split("\t", 1)
            if len(parts) == 2:
                status, filepath = parts
                files.append((status, filepath))
    return files


def get_file_diff(base: str, target: str, filepath: str) -> str:
    """Get detailed diff for a specific file."""
    return run(["git", "diff", f"{base}..{target}", "--", filepath], check=False)


def get_file_patch(base: str, target: str, filepath: str) -> str:
    """Get patch format for a specific file."""
    return run(
        ["git", "diff", "--unified=3", f"{base}..{target}", "--", filepath],
        check=False,
    )


def is_ava_relevant(filepath: str) -> bool:
    """Filter out non-AVA files (personal configs, dotfiles, etc.)."""
    excluded_prefixes = (
        "dwm/", "i3/", "wallpapers/", "ai-agent/", "archived-features/",
        ".claude/", ".codex/", "scripts/", "secrets/", "limine/",
        "shell/", "news/",
    )
    excluded_files = (
        "CLAUDE.md", "AGENTS.md", ".stow-local-ignore", "install.sh",
    )
    if filepath.startswith(excluded_prefixes):
        return False
    if filepath in excluded_files:
        return False
    return True


def classify_change(filepath: str, status: str) -> str:
    """Human-readable change type."""
    if status == "A":
        return "ADDED"
    elif status == "D":
        return "DELETED"
    elif status == "R":
        return "RENAMED"
    elif status == "M":
        return "MODIFIED"
    return status


def summarize_diff(patch: str) -> list[str]:
    """Extract key changes from a patch (added/removed lines)."""
    summary = []
    added = []
    removed = []
    current_section = ""

    for line in patch.splitlines():
        if line.startswith("@@"):
            if current_section:
                summary.append(current_section)
            current_section = line
            added = []
            removed = []
        elif line.startswith("+") and not line.startswith("+++"):
            added.append(line[1:].strip())
        elif line.startswith("-") and not line.startswith("---"):
            removed.append(line[1:].strip())

    if current_section:
        summary.append(current_section)

    return summary


def format_report(
    base: str,
    target: str,
    files: list[tuple[str, str]],
    detailed: bool = False,
) -> str:
    """Format the full diff report."""
    lines = []
    lines.append("=" * 70)
    lines.append("AVA VERSION DIFF REPORT")
    lines.append(f"Base:  {base}")
    lines.append(f"Target: {target}")
    lines.append("=" * 70)
    lines.append("")

    # Stats
    stat = get_diff_stat(base, target)
    if stat:
        lines.append("SUMMARY:")
        for sline in stat.splitlines():
            lines.append(f"  {sline}")
        lines.append("")

    # File list
    lines.append(f"CHANGED FILES ({len(files)} total):")
    lines.append("-" * 40)

    added_count = 0
    modified_count = 0
    deleted_count = 0
    renamed_count = 0

    for status, filepath in files:
        change_type = classify_change(filepath, status)
        if status == "A":
            added_count += 1
        elif status == "D":
            deleted_count += 1
        elif status == "R":
            renamed_count += 1
        else:
            modified_count += 1
        lines.append(f"  [{change_type}] {filepath}")

    lines.append("")
    lines.append(
        f"Added: {added_count} | Modified: {modified_count} | "
        f"Deleted: {deleted_count} | Renamed: {renamed_count}"
    )
    lines.append("")

    # Detailed per-file diffs
    if detailed:
        lines.append("=" * 70)
        lines.append("DETAILED CHANGES")
        lines.append("=" * 70)

        for status, filepath in files:
            if status == "D":
                lines.append(f"\n--- {filepath} (DELETED) ---")
                continue

            lines.append(f"\n{'=' * 60}")
            lines.append(f"FILE: {filepath} [{classify_change(filepath, status)}]")
            lines.append("=" * 60)

            patch = get_file_patch(base, target, filepath)
            if patch:
                # Show first 100 lines of patch to avoid overwhelming output
                patch_lines = patch.splitlines()
                for pline in patch_lines[:100]:
                    lines.append(f"  {pline}")
                if len(patch_lines) > 100:
                    lines.append(f"  ... ({len(patch_lines) - 100} more lines)")
            else:
                lines.append("  (no diff available)")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="AVA Version Diff Tool")
    parser.add_argument(
        "--base",
        default="upstream/main",
        help="Base ref to compare against (default: upstream/main)",
    )
    parser.add_argument(
        "--target",
        default="HEAD",
        help="Target ref to compare (default: HEAD)",
    )
    parser.add_argument(
        "--file",
        help="Show diff for a specific file only",
    )
    parser.add_argument(
        "--detailed",
        action="store_true",
        default=True,
        help="Include per-file patch details (default: true)",
    )
    parser.add_argument(
        "--no-details",
        action="store_true",
        help="Skip per-file patch details",
    )
    parser.add_argument(
        "--output",
        help="Write report to file instead of stdout",
    )

    args = parser.parse_args()
    detailed = not args.no_details

    # Setup
    ensure_remotes()
    fetch_upstream()

    # Resolve base ref
    base_ref = args.base
    if base_ref.startswith("upstream/"):
        pass  # Already prefixed
    elif base_ref == "main" or base_ref == "master":
        base_ref = f"upstream/{base_ref}"

    # Verify refs exist
    try:
        run(["git", "rev-parse", "--verify", base_ref], check=True)
    except subprocess.CalledProcessError:
        print(f"ERROR: Base ref '{base_ref}' not found.", file=sys.stderr)
        sys.exit(1)

    try:
        run(["git", "rev-parse", "--verify", args.target], check=True)
    except subprocess.CalledProcessError:
        print(f"ERROR: Target ref '{args.target}' not found.", file=sys.stderr)
        sys.exit(1)

    # Get changed files
    files = get_changed_files(base_ref, args.target)

    if not files:
        print("No differences found between the two refs.")
        sys.exit(0)

    # If specific file requested
    if args.file:
        if not any(f == args.file for _, f in files):
            print(f"File '{args.file}' not found in diff.")
            sys.exit(0)
        patch = get_file_patch(base_ref, args.target, args.file)
        print(patch)
        sys.exit(0)

    # Generate report
    report = format_report(base_ref, args.target, files, detailed=detailed)

    if args.output:
        Path(args.output).write_text(report)
        print(f"Report written to {args.output}")
    else:
        print(report)


if __name__ == "__main__":
    main()
