#!/bin/bash

# Directory containing Git repositories and backup location
PROJECTS_DIR="/c/projects"
BACKUP_DIR="/c/backup"

# Folders and files to exclude from the tarball
EXCLUDE=("node_modules" "coverage" "allure-results" "gen" "logs" "tmp")

# Check if the backup directory exists, create it if not
mkdir -p "$BACKUP_DIR" || { echo "Failed to create backup directory."; exit 1; }

# Check if the projects directory exists
if [ ! -d "$PROJECTS_DIR" ]; then
  echo "Directory $PROJECTS_DIR does not exist. Exiting."
  exit 1
fi

# Loop through each repository directory
for repo in "$PROJECTS_DIR"/*; do
  if [ -d "$repo/.git" ]; then
    echo "Backing up repository: $repo"

    REPO_NAME=$(basename "$repo")
    BACKUP_FILE="$BACKUP_DIR/$REPO_NAME.tar.gz"

    # Prepare exclusion options for tar
    EXCLUDE_OPTIONS=""
    for item in "${EXCLUDE[@]}"; do
      EXCLUDE_OPTIONS="$EXCLUDE_OPTIONS --exclude=$item"
    done

    # Create the tarball with exclusions
    echo "  Creating backup tarball: $BACKUP_FILE"
    tar -czf "$BACKUP_FILE" $EXCLUDE_OPTIONS -C "$repo" . || { echo "Failed to create backup for $repo"; continue; }

    echo "  Backup completed for $repo"
  else
    echo "Skipping non-repository directory: $repo"
  fi
done

echo "Backup process completed."

