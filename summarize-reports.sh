#!/bin/bash

REPORTS_DIR="$(dirname "$0")/reports"
SCRIPT_NAME="$(basename "$0")"

# ──────────────────────────────────────────────
# UTILITY HELPERS
# ──────────────────────────────────────────────
repeat_char() {
    printf "%${2}s" | tr ' ' "$1"
}

print_banner() {
    local title="$1"
    local sub="$2"
    local w=66
    printf "\n"
    printf "  +%s+\n" "$(repeat_char "-" $((w - 2)))"
    printf "  | %-*s |\n" $((w - 4)) "CIS MySQL Security Benchmark"
    printf "  | %-*s |\n" $((w - 4)) "$title"
    [ -n "$sub" ] && printf "  | %-*s |\n" $((w - 4)) "$sub"
    printf "  +%s+\n" "$(repeat_char "-" $((w - 2)))"
}

print_section_header() {
    local title="$1"
    local w=66
    printf "\n  +%s+\n" "$(repeat_char "-" $((w - 2)))"
    printf "  | %-*s |\n" $((w - 4)) "$title"
    printf "  +%s+\n" "$(repeat_char "-" $((w - 2)))"
}

print_table_row() {
    printf "  | %-28s | %6s | %6s | %6s | %6s |\n" "$1" "$2" "$3" "$4" "$5"
}

print_table_sep() {
    printf "  |%s|%s|%s|%s|%s|\n" \
        "$(repeat_char "-" 30)" "$(repeat_char "-" 8)" \
        "$(repeat_char "-" 8)" "$(repeat_char "-" 8)" "$(repeat_char "-" 8)"
}

print_table_top() {
    printf "  .%s.%s.%s.%s.%s.\n" \
        "$(repeat_char "-" 30)" "$(repeat_char "-" 8)" \
        "$(repeat_char "-" 8)" "$(repeat_char "-" 8)" "$(repeat_char "-" 8)"
}

print_table_bottom() {
    printf "  '%s'%s'%s'%s'%s'\n" \
        "$(repeat_char "-" 30)" "$(repeat_char "-" 8)" \
        "$(repeat_char "-" 8)" "$(repeat_char "-" 8)" "$(repeat_char "-" 8)"
}

# ──────────────────────────────────────────────
# BANNER
# ──────────────────────────────────────────────
print_banner "Audit & Remediation Summary" "Generated: $(date '+%Y-%m-%d %H:%M:%S')"

# ──────────────────────────────────────────────
# AUDIT SUMMARY TABLE
# ──────────────────────────────────────────────
total_audit_pass=0
total_audit_fail=0
total_audit_na=0

print_section_header "Audit Results by Section"
print_table_top
print_table_row "Section" "PASS" "FAIL" "N/A" "TOTAL"
print_table_sep

for f in "$REPORTS_DIR"/cis_mysql_audit_*.log; do
    [ ! -f "$f" ] && continue
    basename "$f" | grep -q "summary" && continue
    section=$(basename "$f" .log | sed 's/cis_mysql_audit_//;s/_/ - /g')
    pass=$(grep -icow "PASS" "$f" 2>/dev/null)
    fail=$(grep -icow "FAIL" "$f" 2>/dev/null)
    na=$(grep -ci "MANUAL CHECK" "$f" 2>/dev/null)
    total=$((pass + fail + na))
    [ "$total" -eq 0 ] && continue
    print_table_row "$section" "$pass" "$fail" "$na" "$total"
    total_audit_pass=$((total_audit_pass + pass))
    total_audit_fail=$((total_audit_fail + fail))
    total_audit_na=$((total_audit_na + na))
done

print_table_sep
print_table_row "TOTAL" "$total_audit_pass" "$total_audit_fail" "$total_audit_na" "$((total_audit_pass + total_audit_fail + total_audit_na))"
print_table_bottom

# ──────────────────────────────────────────────
# PASS RATE INDICATOR
# ──────────────────────────────────────────────
total_audit_all=$((total_audit_pass + total_audit_fail))
if [ "$total_audit_all" -gt 0 ]; then
    pass_rate=$((total_audit_pass * 100 / total_audit_all))
    printf "\n  PASS RATE: %d/%d (%d%%)\n" "$total_audit_pass" "$total_audit_all" "$pass_rate"
fi

# ──────────────────────────────────────────────
# REMEDIATION SUMMARY TABLE
# ──────────────────────────────────────────────
total_rem_done=0
total_rem_applied=0
total_rem_fail=0

print_section_header "Remediation Results by Section"
print_table_top
print_table_row "Section" "DONE" "APPLIED" "FAIL" "TOTAL"
print_table_sep

for f in "$REPORTS_DIR"/cis_mysql_remediation_*.log; do
    [ ! -f "$f" ] && continue
    section=$(basename "$f" .log | sed 's/cis_mysql_remediation_//;s/_/ - /g')
    done_count=$(grep -icow "DONE" "$f" 2>/dev/null)
    applied=$(grep -icow "APPLIED" "$f" 2>/dev/null)
    fail=$(grep -icow "FAIL" "$f" 2>/dev/null)
    total=$((done_count + applied + fail))
    [ "$total" -eq 0 ] && continue
    print_table_row "$section" "$done_count" "$applied" "$fail" "$total"
    total_rem_done=$((total_rem_done + done_count))
    total_rem_applied=$((total_rem_applied + applied))
    total_rem_fail=$((total_rem_fail + fail))
done

print_table_sep
print_table_row "TOTAL" "$total_rem_done" "$total_rem_applied" "$total_rem_fail" "$((total_rem_done + total_rem_applied + total_rem_fail))"
print_table_bottom

# ──────────────────────────────────────────────
# FAILED AUDIT ITEMS
# ──────────────────────────────────────────────
print_section_header "Failed Audit Items"
found_fail=0
for f in "$REPORTS_DIR"/cis_mysql_audit_*.log; do
    [ ! -f "$f" ] && continue
    basename "$f" | grep -q "summary" && continue
    while IFS= read -r line; do
        if [[ $line =~ ^\[([0-9.]+)\]\ (.*) ]]; then
            id="${BASH_REMATCH[1]}"
            title="${BASH_REMATCH[2]}"
        fi
        if [[ $line =~ ^Result[[:space:]]*:[[:space:]]*FAIL ]]; then
            printf "  [FAIL] %-8s %s\n" "[$id]" "$title"
            found_fail=1
        fi
    done < "$f"
done
if [ "$found_fail" -eq 0 ]; then
    printf "  (no failed items)\n"
fi

# ──────────────────────────────────────────────
# MANUAL CHECKS REQUIRING ATTENTION
# ──────────────────────────────────────────────
print_section_header "Manual Checks Requiring Attention"
found_manual=0
for f in "$REPORTS_DIR"/cis_mysql_audit_manual_*.log; do
    [ ! -f "$f" ] && continue
    current_id=""
    current_title=""
    while IFS= read -r line; do
        if [[ $line =~ ^\[([0-9.]+)\]\ (.*) ]]; then
            current_id="${BASH_REMATCH[1]}"
            current_title="${BASH_REMATCH[2]}"
        fi
        if [[ $line =~ MANUAL.CHECK ]]; then
            printf "  [INFO] %-8s %s\n" "[$current_id]" "$current_title"
            found_manual=1
        fi
    done < "$f"
done
if [ "$found_manual" -eq 0 ]; then
    printf "  (no manual checks remaining)\n"
fi

# ──────────────────────────────────────────────
# REMEDIATION FAILURES
# ──────────────────────────────────────────────
print_section_header "Remediation Failures"
found_rem_fail=0
for f in "$REPORTS_DIR"/cis_mysql_remediation_*.log; do
    [ ! -f "$f" ] && continue
    current_id=""
    current_title=""
    while IFS= read -r line; do
        if [[ $line =~ ^\[([0-9.]+)\] ]]; then
            current_id="${BASH_REMATCH[1]}"
            current_title="${line#*\] }"
        fi
        if [[ $line =~ ^Result[[:space:]]*:[[:space:]]*FAIL ]]; then
            printf "  [FAIL] %-8s %s\n" "[$current_id]" "$current_title"
            found_rem_fail=1
        fi
    done < "$f"
done
if [ "$found_rem_fail" -eq 0 ]; then
    printf "  (no remediation failures)\n"
fi

# ──────────────────────────────────────────────
# OVERALL ASSESSMENT
# ──────────────────────────────────────────────
print_section_header "Overall Assessment"

issues=0
[ "$total_audit_fail" -gt 0 ] && issues=1
[ "$total_audit_na" -gt 0 ] && issues=1
[ "$total_rem_fail" -gt 0 ] && issues=1

if [ "$issues" -eq 0 ]; then
    printf "\n  RESULT: PASS — All checks passed and all remediations applied.\n"
else
    printf "\n  RESULT: FAIL — Issues detected, review and remediate.\n"
fi

printf "\n"
printf "    Category                  Count\n"
printf "    ------------------------------ \n"
printf "    Audit failures             %3d\n" "$total_audit_fail"
printf "    Manual checks pending      %3d\n" "$total_audit_na"
printf "    Remediation failures       %3d\n" "$total_rem_fail"

# ──────────────────────────────────────────────
# FOOTER
# ──────────────────────────────────────────────
printf "\n"
printf "  +%s+\n" "$(repeat_char "-" 64)"
printf "  | Report dir: %-51s |\n" "$(cd "$REPORTS_DIR" && pwd)"
printf "  | Script    : %-51s |\n" "$SCRIPT_NAME"
printf "  | Generated : %-51s |\n" "$(date '+%Y-%m-%d %H:%M:%S')"
printf "  +%s+\n" "$(repeat_char "-" 64)"
printf "\n"
