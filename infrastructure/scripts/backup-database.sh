#!/bin/bash
# ==============================================================================
# WASSLNI DATABASE BACKUP & RESTORE SCRIPT
# Automated Daily Backup with S3 Upload & 30-Day Retention
# ==============================================================================

set -e

# Configuration
BACKUP_DIR="/var/backups/wasslni/postgres"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/wasslni_db_${TIMESTAMP}.sql.gz"
DB_CONTAINER="wasslni_postgres"
DB_NAME="${DB_NAME:-wasslni_db}"
DB_USER="${DB_USER:-wasslni_admin}"

mkdir -p "$BACKUP_DIR"

echo "📦 Starting Wasslni PostgreSQL backup at $(date)..."

# Dump database through Docker container with compression
docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" | gzip > "$BACKUP_FILE"

echo "✅ Backup completed successfully: $BACKUP_FILE"
echo "📊 Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"

# Optional: Upload to DigitalOcean Spaces / S3
if command -v s3cmd &> /dev/null; then
    echo "☁️ Uploading backup to S3 Cold Storage..."
    s3cmd put "$BACKUP_FILE" s3://wasslni-backups/database/
fi

# Retention: Delete local backups older than 30 days
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +30 -delete
echo "🧹 Old backups older than 30 days cleaned up."

