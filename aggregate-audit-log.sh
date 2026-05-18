#!/bin/bash

REPORTS_DIR="$(dirname "$0")/reports"
OUTPUT_FILE="$(dirname "$0")/reports/cis_mysql_audit_summary.log"

> "$OUTPUT_FILE"

for f in "$REPORTS_DIR"/cis_mysql_audit_section*.log; do
    section=$(basename "$f" | sed 's/cis_mysql_audit_section//' | sed 's/\.log//')
    echo "" >> "$OUTPUT_FILE"
    echo "================================================================" >> "$OUTPUT_FILE"
    echo "  SECTION $section" >> "$OUTPUT_FILE"
    echo "================================================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    cat "$f" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "Aggregated audit log written to: $OUTPUT_FILE"
echo "Sections found: $(ls "$REPORTS_DIR"/cis_mysql_audit_section*.log 2>/dev/null | wc -l)"
