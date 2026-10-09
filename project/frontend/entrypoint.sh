#!/bin/sh
set -e
if [ ! -d "/app/node_modules/react-leaflet" ] || [ ! -d "/app/node_modules/leaflet" ]; then
  echo "[frontend] dipendenze mancanti, eseguo npm install..."
  cd /app && npm install
fi
exec npm run dev -- --host 0.0.0.0
