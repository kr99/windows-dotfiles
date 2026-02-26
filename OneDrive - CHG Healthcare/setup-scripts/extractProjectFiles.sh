#!/bin/bash

# Configuration
TARGET_DIR="/c/projects"
ONEDRIVE_BACKUP=$(echo ~/OneDrive*/projects/backup)

# Create projects directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Function to extract project name from tar filename
get_project_name() {
    local filename="$1"
    # Remove path and .tar.gz extension
    basename "$filename" .tar.gz
}

# Function to extract single tar file
extract_project() {
    local tar_file="$1"
    local project_name=$(get_project_name "$tar_file")
    local project_dir="$TARGET_DIR/$project_name"
    
    echo "Extracting $project_name..."
    
    # Create project directory
    mkdir -p "$project_dir"
    
    # Extract tar file into project directory
    tar -xzf "$tar_file" -C "$project_dir" 
    
    if [ $? -eq 0 ]; then
        echo "✓ Successfully extracted $project_name"
        # Verify .git directory exists
        if [ -d "$project_dir/.git" ]; then
            echo "  ✓ Git repository found"
        else
            echo "  ! Warning: No .git directory found"
        fi
    else
        echo "✗ Failed to extract $project_name"
    fi
    echo "----------------------------------------"
}

# Main execution
echo "Starting project extraction..."
echo "Source: $ONEDRIVE_BACKUP"
echo "Target: $TARGET_DIR"
echo "----------------------------------------"

# Check if backup directory exists
if [ ! -d "$ONEDRIVE_BACKUP" ]; then
    echo "Error: Backup directory not found: $ONEDRIVE_BACKUP"
    exit 1
fi

# Extract all tar.gz files
for tar_file in "$ONEDRIVE_BACKUP"/*.tar.gz; do
    if [ -f "$tar_file" ]; then
        extract_project "$tar_file"
    fi
done

echo "Extraction complete!"
echo "Projects have been extracted to: $TARGET_DIR"
