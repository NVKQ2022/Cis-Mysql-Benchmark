#!/bin/bash

REPORTS_DIR="$(dirname "$0")/reports"
SUMMARY_LOG="$REPORTS_DIR/cis_mysql_audit_summary.log"

if [ ! -f "$SUMMARY_LOG" ]; then
    echo "Error: $SUMMARY_LOG not found. Run aggregate-audit-log.sh first."
    exit 1
fi

total_pass=$(grep -iow "PASS" "$SUMMARY_LOG" | wc -l)
total_fail=$(grep -iow "FAIL" "$SUMMARY_LOG" | wc -l)

echo "========== CIS MySQL Audit Summary =========="
echo ""
printf "  %-10s %5s %5s\n" "Section" "PASS" "FAIL"
echo "  ---------------------------------"

for f in "$REPORTS_DIR"/cis_mysql_audit_section*.log; do
    section=$(basename "$f" | sed 's/cis_mysql_audit_section//;s/\.log//')
    pass=$(grep -iow "PASS" "$f" | wc -l)
    fail=$(grep -iow "FAIL" "$f" | wc -l)
    printf "  %-10s %5s %5s\n" "$section" "$pass" "$fail"
done

echo "  ---------------------------------"
printf "  %-10s %5s %5s\n" "TOTAL" "$total_pass" "$total_fail"
echo ""
echo "=============================================="
