#!/bin/bash
# add-filesystem-path.sh - Add path to Docker MCP filesystem config
# Edits ~/.docker/mcp/config.yaml directly with git commit support

set -euo pipefail

CONFIG_FILE="$HOME/.docker/mcp/config.yaml"

usage() {
  echo "Usage: $0 <path-to-add> [--create-dir]"
  echo ""
  echo "Example:"
  echo "  $0 'c:\projects\new-repo' --create-dir"
  echo ""
  echo "This script:"
  echo "  - Edits $CONFIG_FILE directly"
  echo "  - Prompts for git commits (before/after)"
  echo "  - Applies changes to Docker MCP"
  exit 1
}

# Check if file is in git repo and has uncommitted changes
check_git_status() {
  local file="$1"
  local file_dir=$(dirname "$file")
  
  # Check if directory is in a git repo
  if ! git -C "$file_dir" rev-parse --git-dir &>/dev/null; then
    return 1  # Not in git repo
  fi
  
  # Check if file has uncommitted changes
  if git -C "$file_dir" status --porcelain "$file" 2>/dev/null | grep -q "^"; then
    return 0  # Has uncommitted changes
  fi
  
  return 1  # No uncommitted changes
}

# Prompt for git commit
prompt_git_commit() {
  local message="$1"
  local file="$2"
  
  if ! check_git_status "$file"; then
    return 0  # Not in git or no changes
  fi
  
  echo ""
  echo "⚠️  $message"
  read -p "Commit changes now? (y/N): " -n 1 -r
  echo
  
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    local file_dir=$(dirname "$file")
    git -C "$file_dir" add "$file"
    read -p "Commit message: " commit_msg
    git -C "$file_dir" commit -m "$commit_msg"
    echo "✅ Committed"
  else
    echo "⏭️  Skipping commit"
  fi
}

# Create directory if it doesn't exist
create_directory() {
  local path="$1"
  
  # Convert path for mkdir (handle both forward/backslash)
  local dir_path="${path//\\/\/}"  # Replace backslashes
  dir_path="${dir_path//C:/c/}"   # Handle C: -> c/
  
  if [[ ! -d "$dir_path" ]]; then
    echo "📁 Creating directory: $dir_path"
    mkdir -p "$dir_path" || {
      echo "❌ Failed to create directory"
      return 1
    }
  fi
  return 0
}

# Main execution
main() {
  [[ $# -lt 1 ]] && usage
  
  local new_path="$1"
  local create_dir="${2:-}"
  
  # Check dependencies
  if ! command -v yq &> /dev/null; then
    echo "❌ yq not found. Install with:"
    echo "   choco install yq        # Windows (run as Admin)"
    exit 1
  fi
  
  if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Config file not found: $CONFIG_FILE"
    exit 1
  fi
  
  # Git commit check - BEFORE changes
  prompt_git_commit "Config file has uncommitted changes" "$CONFIG_FILE"
  
  # Create directory if requested
  if [[ "$create_dir" == "--create-dir" ]]; then
    create_directory "$new_path" || exit 1
  fi
  
  # Check if path already exists
  if yq e ".filesystem.paths[] | select(. == \"$new_path\")" "$CONFIG_FILE" | grep -q .; then
    echo "✅ Path already exists in config"
    exit 0
  fi
  
  # Add path to config file
  echo "➕ Adding path to filesystem.paths in $CONFIG_FILE"
  yq e ".filesystem.paths += [\"$new_path\"]" -i "$CONFIG_FILE"
  
  # Apply to Docker MCP
  echo "💾 Applying config to Docker MCP..."
  docker mcp config write "$(cat "$CONFIG_FILE")"
  
  echo "✅ Done! Path added: $new_path"
  
  # Git commit check - AFTER changes
  prompt_git_commit "New changes made to config file" "$CONFIG_FILE"
  
  echo ""
  echo "Verify with: docker mcp config read"
}

main "$@"
