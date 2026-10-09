import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr, Field
from .db import get_connection

app = FastAPI(title="Platform API", version="0.2.0")
origins = [x.strip() for x in os.getenv("CORS_ORIGINS", "http://localhost:5173").split(",") if x.strip()]
app.add_middleware(CORSMiddleware, allow_origins=origins, allow_credentials=True,
                   allow_methods=["GET", "POST", "OPTIONS"], allow_headers=["*"])

class ContactRequest(BaseModel):
    name: str = Field(min_length=2, max_length=160)
    email: EmailStr
    profile: str = Field(pattern="^(utente|negoziante|altro)$")
    message: str = Field(min_length=10, max_length=4000)
    privacy_consent: bool

@app.get("/health")
def health():
    return {"status": "ok", "service": "platform-api"}

@app.get("/api/public/posts")
def posts():
    try:
        with get_connection() as conn:
            items = conn.execute("""
                SELECT id, slug, title, excerpt, body, published_at
                FROM blog_post WHERE status = 'published'
                ORDER BY published_at DESC NULLS LAST LIMIT 30
            """).fetchall()
        return {"items": items}
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Contenuti temporaneamente non disponibili.") from exc

@app.get("/api/public/featured-businesses")
def featured_businesses():
    try:
        with get_connection() as conn:
            items = conn.execute("""
                SELECT id, public_name, category, city, description
                FROM business_public_profile
                WHERE featured = TRUE AND status = 'published'
                ORDER BY featured_order, public_name LIMIT 30
            """).fetchall()
        return {"items": items}
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Attività temporaneamente non disponibili.") from exc

@app.get("/api/public/activities-nearby")
def activities_nearby(lat: float, lon: float, distance: float = 5.0):
    try:
        lat_f = float(lat)
        lon_f = float(lon)
        dist_f = float(distance)
    except (TypeError, ValueError):
        raise HTTPException(status_code=422, detail="Parametri lat/lon/distance non validi.")
    if not (-90 <= lat_f <= 90 and -180 <= lon_f <= 180):
        raise HTTPException(status_code=422, detail="Coordinate non valide.")
    if not (0 < dist_f <= 500):
        raise HTTPException(status_code=422, detail="Distanza non valida (1-500 km).")
    try:
        with get_connection() as conn:
            items = conn.execute("""
                SELECT
                    bpp.business_id AS id,
                    bpp.public_name,
                    bpp.category,
                    bl.city,
                    COALESCE(bl.address_line, '') AS address,
                    bpp.description,
                    bl.latitude,
                    bl.longitude,
                    (6371 * acos(
                        LEAST(1.0, GREATEST(-1.0,
                            cos(radians(%s)) * cos(radians(bl.latitude))
                            * cos(radians(bl.longitude) - radians(%s))
                            + sin(radians(%s)) * sin(radians(bl.latitude))
                        ))
                    )) AS distance_km
                FROM business_location bl
                JOIN business b ON b.id = bl.business_id AND b.status = 'active'
                LEFT JOIN business_public_profile bpp ON bpp.business_id = b.id
                WHERE bl.status = 'active'
                  AND bl.latitude IS NOT NULL AND bl.longitude IS NOT NULL
                  AND (6371 * acos(
                        LEAST(1.0, GREATEST(-1.0,
                            cos(radians(%s)) * cos(radians(bl.latitude))
                            * cos(radians(bl.longitude) - radians(%s))
                            + sin(radians(%s)) * sin(radians(bl.latitude))
                        ))
                    )) <= %s
                ORDER BY distance_km ASC
                LIMIT 100
            """, (lat_f, lon_f, lat_f, lat_f, lon_f, lat_f, dist_f)).fetchall()
        return {"items": items, "lat": lat_f, "lon": lon_f, "distance_km": dist_f}
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Ricerca vicinanza temporaneamente non disponibile.") from exc

@app.post("/api/public/contact", status_code=201)
def contact(payload: ContactRequest):
    if not payload.privacy_consent:
        raise HTTPException(status_code=422, detail="Conferma la presa visione dell'informativa.")
    try:
        with get_connection() as conn:
            item = conn.execute("""
                INSERT INTO contact_message(name, email, profile, message, privacy_consent)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING id, created_at
            """, (payload.name, str(payload.email), payload.profile, payload.message, payload.privacy_consent)).fetchone()
        return {"status": "received", "id": item["id"], "created_at": item["created_at"]}
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Invio non riuscito. Riprova più tardi.") from exc
