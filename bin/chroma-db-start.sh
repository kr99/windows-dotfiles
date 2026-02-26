# Backup current add-filesystem-path.sh and setup Chroma
{
  echo "=== Current add-filesystem-path.sh ==="
  cat ~/bin/add-filesystem-path.sh 2>/dev/null || echo "[Script not found]"
  echo ""
  echo "=== Starting Chroma Setup ==="
  
  # Create data directory
  mkdir -p /c/projects/chroma-vector-db
  
  # Start Chroma container with persistence
  docker run -d \
    --name chromadb-local \
    --restart unless-stopped \
    -p 8000:8000 \
    -v /c/projects/chroma-vector-db:/chroma/chroma \
    -e IS_PERSISTENT=TRUE \
    -e ANONYMIZED_TELEMETRY=FALSE \
    chromadb/chroma:latest
  
  # Wait for startup
  sleep 3
  
  # Test connection
  echo ""
  echo "=== Chroma Status ==="
  docker ps | grep chromadb || echo "[Container not running]"
  
  # Test API
  curl -s http://localhost:8000/api/v1/heartbeat 2>/dev/null && echo "✓ Chroma API responding" || echo "✗ Chroma API not responding"
  
  echo ""
  echo "=== Chroma Data Directory ==="
  ls -lh /c/projects/chroma-vector-db/ 2>/dev/null || echo "[Directory not accessible]"
  
} 2>&1 | tee /dev/tty | head -50 | clip.exe
