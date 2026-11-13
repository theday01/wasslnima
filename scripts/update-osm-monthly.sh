#!/bin/bash
# ==============================================================================
# Wasslni Morocco OSM Monthly Maintenance & Graph Refresh
# Run on the 1st of every month via cron: 0 3 1 * * /path/to/update-osm-monthly.sh
# ==============================================================================

set -e

DATA_DIR="${DATA_DIR:-./infrastructure/docker/osm-data}"
BACKUP_DIR="${DATA_DIR}/backup_$(date +%Y%m%d)"
PBF_URL="https://download.geofabrik.de/africa/morocco-latest.osm.pbf"
TEMP_PBF="${DATA_DIR}/morocco-new.osm.pbf"

echo "[$(date -u)] Starting monthly Morocco OSM update..."

mkdir -p "${DATA_DIR}"
mkdir -p "${BACKUP_DIR}"

# 1. Download fresh dataset
echo "Fetching updated Morocco extract from Geofabrik..."
curl -L -o "${TEMP_PBF}" "${PBF_URL}"

# 2. Extract and compile in temporary staging
echo "Processing new OSRM graph..."
docker run -t -v "${DATA_DIR}:/data" ghcr.io/project-osrm/osrm-backend:v5.27.1 \
  osrm-extract -p /opt/car.lua /data/morocco-new.osm.pbf

docker run -t -v "${DATA_DIR}:/data" ghcr.io/project-osrm/osrm-backend:v5.27.1 \
  osrm-partition /data/morocco-new.osrm

docker run -t -v "${DATA_DIR}:/data" ghcr.io/project-osrm/osrm-backend:v5.27.1 \
  osrm-customize /data/morocco-new.osrm

# 3. Safe swap and restart container
echo "Rotating graph files..."
mv "${DATA_DIR}"/morocco-latest.osrm* "${BACKUP_DIR}/" || true
mv "${DATA_DIR}/morocco-latest.osm.pbf" "${BACKUP_DIR}/" || true

# Rename staged to active
for f in "${DATA_DIR}"/morocco-new.osrm*; do
  mv "$f" "${f/morocco-new/morocco-latest}"
done
mv "${TEMP_PBF}" "${DATA_DIR}/morocco-latest.osm.pbf"

# 4. Restart OSRM service with zero-impact reload
echo "Restarting OSRM container..."
docker compose restart osrm || docker restart wasslni_osrm || true

echo "[$(date -u)] Monthly update completed successfully!"
