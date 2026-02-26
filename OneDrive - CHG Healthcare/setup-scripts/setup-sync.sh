#!/bin/bash
# Config sync script with pattern-based rules and size reporting

# Configuration start
read -r -d '' CONFIG << 'EOF'
# DBeaver Configuration
COPY=DBeaverData/workspace*/General/Scripts/**
COPY=DBeaverData/workspace*/General/Diagrams/**
EXCLUDE=DBeaverData/**/*.db
EXCLUDE=DBeaverData/**/*.db-journal
EXCLUDE=DBeaverData/**/.metadata/**
EXCLUDE=DBeaverData/**/Cache/**

# Background Switcher
COPY=johnsadventures.com/Background Switcher/**
EXCLUDE=johnsadventures.com/**/Cache/**
EXCLUDE=johnsadventures.com/**/Temp/**

# WinCompose
COPY=WinCompose/**
EXCLUDE=WinCompose/**/*.log
EXCLUDE=WinCompose/**/Cache/**
EXCLUDE=WinCompose/**/Temp/**

# Snagit (latest version only)
LATEST=TechSmith/Snagit [0-9]*/**
EXCLUDE=TechSmith/**/Identity/**
EXCLUDE=TechSmith/**/Cache/**

# Ditto
COPY=Ditto/**
EXCLUDE=Ditto/**/*.db
EXCLUDE=Ditto/**/*.db-journal

# Sensitive files (require confirmation, temporary sync)
SECURE=.ssh/**
EXCLUDE=.ssh/**/known_hosts
SECURE=.npmrc
EOF

# Base paths
APPDATA="$HOME/AppData/Roaming"
ONEDRIVE="$HOME/OneDrive - CHG Healthcare/AppData-sync"
TEMP_DIR="/tmp/sensitive-sync-$$"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Logging functions
log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }

# Format size in human readable format
format_size() {
    local size=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0
    
    while (( size > 1024 && unit < 4 )); do
        size=$(( size / 1024 ))
        unit=$(( unit + 1 ))
    done
    
    echo "$size${units[$unit]}"
}

# Get directory size excluding patterns
get_dir_size() {
    local dir="$1"
    local exclude_file="$2"
    local size
    
    if [ -f "$exclude_file" ]; then
        size=$(rsync -av --exclude-from="$exclude_file" --dry-run "$dir" /dev/null 2>&1 | 
               grep "total size" | 
               grep -o "[0-9]\+" | 
               head -1)
    else
        size=$(du -sb "$dir" 2>/dev/null | cut -f1)
    fi
    
    echo "${size:-0}"
}

# Get latest versioned folder matching pattern
get_latest_version() {
    local base_path="$1"
    local pattern="$2"
    find "$base_path" -maxdepth 1 -type d -regex ".*$pattern[0-9.]*" | sort -V | tail -n1
}

# Create temporary exclusion file
create_exclusion_file() {
    local section="$1"
    local temp_file=$(mktemp)
    echo "$CONFIG" | 
    awk -v section="$section" '
        $0 ~ "^# " section { in_section=1; next }
        /^# / { in_section=0 }
        in_section && /^EXCLUDE=/ { print substr($0, 9) }
    ' > "$temp_file"
    echo "$temp_file"
}

# Calculate and display sizes for all sync patterns
display_sync_plan() {
    local total_size=0
    local patterns=()
    local sizes=()
    
    echo "Sync Plan:"
    echo "=========="
    
    while IFS= read -r line; do
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        
        local type=${line%%=*}
        local pattern=${line#*=}
        
        case "$type" in
            COPY|LATEST)
                local source
                if [ "$type" = "LATEST" ]; then
                    local base_dir=$(dirname "$pattern")
                    local name_pattern=$(basename "$pattern")
                    source=$(get_latest_version "$APPDATA/$base_dir" "$name_pattern")
                    pattern="$base_dir/$(basename "$source")"
                else
                    source="$APPDATA/$pattern"
                fi
                
                if [ -e "$source" ]; then
                    local exclude_file=$(create_exclusion_file "$(echo "$pattern" | cut -d'/' -f1)")
                    local size=$(get_dir_size "$source" "$exclude_file")
                    rm -f "$exclude_file"
                    
                    total_size=$((total_size + size))
                    patterns+=("$pattern")
                    sizes+=("$(format_size $size)")
                    
                    printf "%-50s %10s\n" "${pattern:0:50}" "$(format_size $size)"
                fi
                ;;
        esac
    done <<< "$CONFIG"
    
    echo "----------------------------------------------------------"
    printf "%-50s %10s\n" "Total" "$(format_size $total_size)"
    echo
    
    read -p "Proceed with sync? (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 0
}

# Main sync function
main() {
    # Check for rsync and install if needed
    if ! command -v rsync >/dev/null 2>&1; then
        log "rsync not found, launching installer..."
        # Create a temporary PowerShell script
        local ps_script="/tmp/install_rsync_$.ps1"
        cat > "$ps_script" << 'POWERSHELL'
Start-Process powershell -Verb RunAs -ArgumentList "-Command", "choco install -y rsync"
POWERSHELL
        
        # Launch PowerShell script
        powershell.exe -ExecutionPolicy Bypass -File "$ps_script"
        rm -f "$ps_script"
        
        # Wait for rsync to become available
        log "Waiting for rsync installation..."
        for i in {1..30}; do
            if command -v rsync >/dev/null 2>&1; then
                log "rsync installed successfully"
                break
            fi
            if [ $i -eq 30 ]; then
                error "rsync installation timed out. Please install manually: 'choco install -y rsync'"
            fi
            sleep 2
        done
    fi
    
    # Create necessary directories
    mkdir -p "$ONEDRIVE" "$TEMP_DIR"
    
    # Display sync plan and get confirmation
    display_sync_plan
    
    # Process each line in config
    while IFS= read -r line; do
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        
        local type=${line%%=*}
        local pattern=${line#*=}
        
        case "$type" in
            COPY)
                local source="$APPDATA/$pattern"
                local dest="$ONEDRIVE/$pattern"
                local exclude_file=$(create_exclusion_file "$(echo "$pattern" | cut -d'/' -f1)")
                
                if [ -e "$source" ]; then
                    log "Copying: $pattern"
                    mkdir -p "$(dirname "$dest")"
                    rsync -av --delete --exclude-from="$exclude_file" "$source" "$dest"
                fi
                rm -f "$exclude_file"
                ;;
                
            LATEST)
                local base_dir=$(dirname "$pattern")
                local name_pattern=$(basename "$pattern")
                local latest=$(get_latest_version "$APPDATA/$base_dir" "$name_pattern")
                local exclude_file=$(create_exclusion_file "$(echo "$base_dir" | cut -d'/' -f1)")
                
                if [ -n "$latest" ]; then
                    local version=$(basename "$latest")
                    log "Found latest version: $version"
                    local dest="$ONEDRIVE/$base_dir/$version"
                    mkdir -p "$dest"
                    rsync -av --delete --exclude-from="$exclude_file" "$latest/" "$dest"
                fi
                rm -f "$exclude_file"
                ;;
                
            SECURE)
                local source="$APPDATA/$pattern"
                local dest="$TEMP_DIR/$pattern"
                if [ -e "$source" ]; then
                    log "Handling secure file: $pattern"
                    read -p "Sync sensitive file $pattern? (y/N) " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        mkdir -p "$(dirname "$dest")"
                        rsync -av "$source" "$dest"
                    fi
                fi
                ;;
        esac
    done <<< "$CONFIG"
    
    # Handle secure files
    if [ -d "$TEMP_DIR" ]; then
        log "Cleaning up sensitive files..."
        find "$TEMP_DIR" -type f -exec shred -u {} \;
        rm -rf "$TEMP_DIR"
    fi
    
    log "Sync completed"
}

# Run main function
main
# 
