#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/sections"

mkdir -p "$OUTPUT_DIR"

declare -A SECTIONS=(
    ["1"]="System_and_File_Security"
    ["2"]="Installation_and_Planning"
    ["3"]="File_Permissions"
    ["4"]="General_Security"
    ["5"]="MySQL_Permissions"
    ["6"]="Auditing_and_Logging"
    ["7"]="Authentication"
    ["8"]="Network_Security"
    ["9"]="Replication"
    ["10"]="MySQL_InnoDB_Cluster_Group_Replication"
)

parse_controls() {
    local section_num="$1"
    declare -A controls
    
    while IFS= read -r line; do
        [[ "$line" =~ ^(ID|Control)[[:space:]]*$ ]] && continue
        
        if [[ "$line" =~ ^[[:space:]]*([[:digit:]]+\.?[[:digit:]]*\.?[[:digit:]]*)[[:space:]]+(.+)$ ]]; then
            local id="${BASH_REMATCH[1]}"
            local control="${BASH_REMATCH[2]}"
            
            [[ "$id" =~ ^[[:digit:]]+\.$ ]] && continue
            
            if [[ "$id" =~ ^${section_num}\. ]]; then
                local slug="${control// /_}"
                slug="${slug//\//_}"
                slug="${slug//\'/}"
                controls["$id"]="$slug"
            fi
        fi
    done < "$SCRIPT_DIR/audit-sections.txt"
    
    for id in "${!controls[@]}"; do
        echo "$id|${controls[$id]}"
    done | sort -t'|' -k1
}

create_structure() {
    local section_num="$1"
    local section_name="$2"
    
    local section_dir="$OUTPUT_DIR/${section_num}.${section_name}"
    mkdir -p "$section_dir"
    
    while IFS='|' read -r id control; do
        if [[ -n "$id" ]]; then
            local child_dir="$section_dir/${id}.${control}"
            mkdir -p "$child_dir/audit"
            mkdir -p "$child_dir/remediation"
            
            touch "$child_dir/audit/.gitkeep"
            touch "$child_dir/remediation/.gitkeep"
        fi
    done < <(parse_controls "$section_num")
    
    echo "Created: $section_dir"
}

echo "Creating folder structure..."

for section_num in "${!SECTIONS[@]}"; do
    section_name="${SECTIONS[$section_num]}"
    create_structure "$section_num" "$section_name"
done

echo "Done! Folder structure created in: $OUTPUT_DIR"
