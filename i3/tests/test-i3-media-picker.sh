#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture_dir="$repo_dir/tests/fixtures/media-picker"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

export MEDIA_PICKER_TEST_LOG="$tmp_dir/playerctl.log"
export PLAYERCTL_BIN="$fixture_dir/playerctl"
export ROFI_BIN="$fixture_dir/rofi"

if ! "$repo_dir/.config/i3/scripts/media/i3-media-picker.sh"; then
  echo "media picker exited unsuccessfully" >&2
  exit 1
fi

grep -F -- "-p chromium play-pause" "$MEDIA_PICKER_TEST_LOG" >/dev/null
if grep -F -- "-p spotify play-pause" "$MEDIA_PICKER_TEST_LOG" >/dev/null; then
  echo "media picker toggled the wrong player" >&2
  exit 1
fi

echo "i3-media-picker: ok"
