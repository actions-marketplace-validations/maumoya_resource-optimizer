#!/usr/bin/env bash
# Read-only snapshot of disk, memory and load. Usage: measure.sh before [--scan] | after
# Writes ~/.resource-optimizer/<label>.txt. "after" also prints the before/after table.
set -euo pipefail

label="${1:-}"
case "$label" in before|after) ;; *) echo "usage: measure.sh before [--scan] | after" >&2; exit 2 ;; esac

dir="$HOME/.resource-optimizer"
mkdir -p "$dir"
out="$dir/$label.txt"

# Disk: 1K blocks of the volume holding $HOME. On macOS the data volume is what fills.
read -r total used avail < <(df -k "$HOME" | awk 'NR==2 {print $2, $3, $4}')
gb() { awk -v k="$1" 'BEGIN { printf "%.2f", k * 1024 / 1e9 }'; }

if [ "$(uname)" = "Darwin" ]; then
  ram_total=$(sysctl -n hw.memsize)
  swap_used=$(sysctl -n vm.swapusage | awk '{print $6}')
  load=$(sysctl -n vm.loadavg | awk '{print $2}')
else
  ram_total=$(awk '/MemTotal/ {print $2 * 1024}' /proc/meminfo)
  swap_used=$(awk '/SwapTotal/ {t=$2} /SwapFree/ {f=$2} END {printf "%.0fM", (t-f)/1024}' /proc/meminfo)
  load=$(cut -d' ' -f1 /proc/loadavg)
fi

{
  echo "taken=$(date '+%Y-%m-%d %H:%M')"
  echo "disk_total_gb=$(gb "$total")"
  echo "disk_used_gb=$(gb $((total - avail)))"
  echo "disk_free_gb=$(gb "$avail")"
  echo "ram_gb=$(awk -v b="$ram_total" 'BEGIN { printf "%.0f", b / 1e9 }')"
  echo "swap_used=$swap_used"
  echo "load_1m=$load"
  if [ "$(uname)" = "Darwin" ]; then
    # df ignores purgeable space; diskutil's container free is what Settings shows.
    echo "container_free=$(diskutil info / | awk -F: '/Container Free Space/ {gsub(/^ +/, "", $2); split($2, a, " [(]"); print a[1]}')"
    echo "local_snapshots=$(tmutil listlocalsnapshots / 2>/dev/null | grep -c 'com.apple' || true)"
  fi
} > "$out"

# Top-level home folders, largest first (explicit names, no globs). Slow on big homes.
if [ "$label" = "before" ] && [ "${2:-}" = "--scan" ]; then
  echo "top folders in $HOME:" >> "$out"
  ls -A "$HOME" | while IFS= read -r name; do
    du -sk "$HOME/$name" 2>/dev/null || true
  done | sort -rn | head -20 | awk '{ printf "  %6.1f GB  %s\n", $1 * 1024 / 1e9, substr($0, index($0, $2)) }' >> "$out"
fi

cat "$out"

if [ "$label" = "after" ]; then
  if [ ! -f "$dir/before.txt" ]; then echo "no before snapshot: run measure.sh before first" >&2; exit 1; fi
  val() { awk -F= -v k="$2" '$1 == k {print $2}' "$1"; }
  b_used=$(val "$dir/before.txt" disk_used_gb); a_used=$(val "$out" disk_used_gb)
  b_free=$(val "$dir/before.txt" disk_free_gb); a_free=$(val "$out" disk_free_gb)
  echo
  echo "| | Before | After | Change |"
  echo "|---|---|---|---|"
  echo "| Used | ${b_used} GB | ${a_used} GB | $(awk -v b="$b_used" -v a="$a_used" 'BEGIN { printf "%+.2f GB", a - b }') |"
  echo "| Free | ${b_free} GB | ${a_free} GB | $(awk -v b="$b_free" -v a="$a_free" 'BEGIN { printf "%+.2f GB", a - b }') |"
  echo "| Swap | $(val "$dir/before.txt" swap_used) | $(val "$out" swap_used) | |"
fi
