#!/bin/bash
# ==============================================================================
# Wasslni Morocco OSM Routing & Geocoding Setup
# Downloads Morocco extract from Geofabrik and builds OSRM graph & Photon index
# ==============================================================================

set -e

DATA_DIR="${DATA_DIR:-./infrastructure/docker/osm-data}"
PBF_URL="https://download.geofabrik.de/africa/morocco-latest.osm.pbf"
PBF_FILE="${DATA_DIR}/morocco-latest.osm.pbf"
OSRM_FILE="${DATA_DIR}/morocco-latest.osrm"

echo "=================================================="
echo " Wasslni Map Engine: Morocco OSM Ingestion Pipeline"
echo "=================================================="

mkdir -p "${DATA_DIR}"
mkdir -p "${DATA_DIR}/photon"

echo "[1/4] Downloading latest Morocco OSM extract from Geofabrik..."
if [ -f "${PBF_FILE}" ]; then
  echo "  Existing PBF file found: ${PBF_FILE}"
  echo "  Use scripts/update-osm-monthly.sh to force refresh."
else
  curl -L -o "${PBF_FILE}" "${PBF_URL}"
  echo "  Download complete: $(du -h "${PBF_FILE}" | cut -f1)"
fi

echo "[2/4] Extracting OSRM routing graph with car profile..."
docker run -t -v "${DATA_DIR}:/data" ghcr.io/project-osrm/osrm-backend:v5.27.1 \
  osrm-extract -p /opt/car.lua /data/morocco-latest.osm.pbf

echo "[3/4] Partitioning OSRM Multi-Level Dijkstra (MLD)..."
docker run -t -v "${DATA_DIR}:/data" ghcr.io/project-osrm/osrm-backend:v5.27.1 \
  osrm-partition /data/morocco-latest.osrm

echo "[4/4] Customizing OSRM routing cells..."
docker run -t -v "${DATA_DIR}:/data" ghcr.io/project-osrm/osrm-backend:v5.27.1 \
  osrm-customize /data/morocco-latest.osrm

echo "=================================================="
echo " Morocco OSM Graph built successfully!"
echo " Routing file: ${OSRM_FILE}"
echo " You can now start docker compose services: osrm, photon"
echo "=================================================="
