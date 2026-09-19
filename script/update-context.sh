#!/bin/bash
# Auto-update CONTEXT-ANCHOR.md with current repo state

set -e

cd "$(dirname "$0")/.."

ANCHOR="docs/CONTEXT-ANCHOR.md"
TMP=$(mktemp)

echo "▶ Regenerating CONTEXT-ANCHOR.md..."

# Timestamp
NOW=$(date -u +"%Y-%m-%d %H:%M UTC")

# ── Live contracts from evidence ──
CONTRACTS=""
if [ -d "evidence/deployments" ]; then
  for f in evidence/deployments/*.json; do
    [ -f "$f" ] || continue
    NAME=$(basename "$f" .json | sed 's/sepolia-//;s/-/ /g')
    ADDRS=$(grep -oE '0x[a-fA-F0-9]{40}' "$f" 2>/dev/null | head -3 | tr '\n' ' ')
    if [ -n "$ADDRS" ]; then
      CONTRACTS="${CONTRACTS}- **${NAME}**: \`${ADDRS}\`\n"
    fi
  done
fi
[ -z "$CONTRACTS" ] && CONTRACTS="- (no deployments found)\n"

# ── Repo stats ──
TOTAL_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo 0)
LAST_COMMIT=$(git log -1 --format="%h — %s" 2>/dev/null || echo "n/a")
TOTAL_CONTRACTS=$(ls src/*.sol 2>/dev/null | wc -l)
TOTAL_TESTS=$(find test -name "*.t.sol" 2>/dev/null | wc -l)
TOTAL_TAGS=$(git tag 2>/dev/null | wc -l)

# Test count from last run (approximate from forge)
TEST_COUNT="(run 'forge test' to refresh)"
if [ -f "out/.test-count" ]; then
  TEST_COUNT=$(cat out/.test-count)
fi

# ── Recent activity (last 15 commits) ──
RECENT=$(git log -15 --format="- \`%h\` %s" 2>/dev/null || echo "- (no commits)")

# ── Build updated file ──
awk -v now="$NOW" \
    -v contracts="$CONTRACTS" \
    -v commits="$TOTAL_COMMITS" \
    -v lastcommit="$LAST_COMMIT" \
    -v totalcontracts="$TOTAL_CONTRACTS" \
    -v totaltests="$TOTAL_TESTS" \
    -v totaltags="$TOTAL_TAGS" \
    -v testcount="$TEST_COUNT" \
    -v recent="$RECENT" '
BEGIN { section = "" }
/^## 🏗️ Live Contracts/ { print; print ""; printf "%s", contracts; print ""; in_contracts=1; next }
/^## 📊 Repository Stats/ { print; print ""; print "- Total commits: " commits; print "- Total contracts (src/): " totalcontracts; print "- Total test files: " totaltests; print "- Total tags: " totaltags; print "- Last test count: " testcount; print "- Last commit: " lastcommit; print ""; in_stats=1; next }
/^## 🎯 Recent Activity/ { print; print ""; print recent; print ""; in_recent=1; next }
/^## 🔑 Reminders/ { in_contracts=0; in_stats=0; in_recent=0 }
{ if (!in_contracts && !in_stats && !in_recent) print }
END { }
' "$ANCHOR" > "$TMP"

# Replace AUTO placeholders
sed -i "s/^\*\*Last Updated:\*\* AUTO/**Last Updated:** $NOW/" "$TMP"
sed -i "s/^\*\*Last auto-updated:\*\* AUTO/**Last auto-updated:** $NOW/" "$TMP"

mv "$TMP" "$ANCHOR"

echo "✅ CONTEXT-ANCHOR.md updated at $NOW"
echo ""
echo "Preview:"
echo "════════════════════════════════════════"
head -30 "$ANCHOR"
echo "..."
echo "════════════════════════════════════════"
