#!/bin/bash
set -e

echo "🔍 Starting OP Stack Security Analysis with Slither..."
echo "=================================================="

SLITHER_PATH="$HOME/opstack-lab/optimism/packages/contracts-bedrock"
SLITHER_CMD="$HOME/opstack-lab/.venv/bin/slither"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
REPORT_DIR="$HOME/opstack-lab/security-reports"
REPORT_FILE="$REPORT_DIR/slither_analysis_$TIMESTAMP"

# Create reports directory if it doesn't exist
mkdir -p "$REPORT_DIR"

cd "$SLITHER_PATH"

echo "📁 Analysis Target: $SLITHER_PATH/src/"
echo "🕒 Timestamp: $(date)"
echo "📊 Generating comprehensive security report..."
echo ""

# Run comprehensive Slither analysis with multiple output formats
echo "🔍 Running core vulnerability detection..."
$SLITHER_CMD src/ \
  --exclude-dependencies \
  --filter-paths "node_modules,lib" \
  --solc-remaps @openzeppelin/=lib/openzeppelin-contracts/ \
  --foundry-ignore-compile \
  --print human-summary \
  --json "$REPORT_FILE.json" 2>&1 | tee "$REPORT_FILE.txt"

echo ""
echo "🎯 Running specific security checks..."

# High-impact vulnerability checks
echo "🚨 Checking for reentrancy vulnerabilities..."
$SLITHER_CMD src/ \
  --exclude-dependencies \
  --filter-paths "node_modules,lib" \
  --solc-remaps @openzeppelin/=lib/openzeppelin-contracts/ \
  --foundry-ignore-compile \
  --detect reentrancy-eth,reentrancy-no-eth,reentrancy-unlimited-gas 2>/dev/null || true

echo ""
echo "🔐 Checking access control issues..."
$SLITHER_CMD src/ \
  --exclude-dependencies \
  --filter-paths "node_modules,lib" \
  --solc-remaps @openzeppelin/=lib/openzeppelin-contracts/ \
  --foundry-ignore-compile \
  --detect suicidal,unprotected-upgrade 2>/dev/null || true

echo ""
echo "💰 Checking for economic vulnerabilities..."
$SLITHER_CMD src/ \
  --exclude-dependencies \
  --filter-paths "node_modules,lib" \
  --solc-remaps @openzeppelin/=lib/openzeppelin-contracts/ \
  --foundry-ignore-compile \
  --detect incorrect-equality,dangerous-strict-equalities 2>/dev/null || true

echo ""
echo "⛽ Analyzing gas optimization opportunities..."
$SLITHER_CMD src/ \
  --exclude-dependencies \
  --filter-paths "node_modules,lib" \
  --solc-remaps @openzeppelin/=lib/openzeppelin-contracts/ \
  --foundry-ignore-compile \
  --detect costly-loop,dead-code 2>/dev/null || true

echo ""
echo "📋 Analysis Summary:"
echo "=================="
if [ -f "$REPORT_FILE.json" ]; then
    TOTAL_ISSUES=$(jq '.results.detectors | length' "$REPORT_FILE.json" 2>/dev/null || echo "N/A")
    HIGH_ISSUES=$(jq '[.results.detectors[] | select(.impact == "High")] | length' "$REPORT_FILE.json" 2>/dev/null || echo "N/A")
    MEDIUM_ISSUES=$(jq '[.results.detectors[] | select(.impact == "Medium")] | length' "$REPORT_FILE.json" 2>/dev/null || echo "N/A")
    
    echo "📊 Total Issues Found: $TOTAL_ISSUES"
    echo "🚨 High Severity: $HIGH_ISSUES"
    echo "⚠️  Medium Severity: $MEDIUM_ISSUES"
fi

echo "📄 Full report saved to: $REPORT_FILE.txt"
echo "📄 JSON report saved to: $REPORT_FILE.json"
echo ""
echo "✅ Slither analysis complete!"
echo "🔍 Review the reports above for detailed findings and potential security issues."
