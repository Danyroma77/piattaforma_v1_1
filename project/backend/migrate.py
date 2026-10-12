"""Esegue le migrazioni SQL in ordine su DATABASE_URL (Render/Neon safe).

Uso:
  python -m migrate            # applica tutte le migrazioni mancanti
  python -m migrate --check    # esce 1 se ci sono migrazioni mancanti

Idempotente: ogni file .sql registra il suo ID in schema_migrations.

La cartella delle migrazioni viene cercata in ordine:
  1. $MIGRATIONS_DIR (se impostata)
  2. <backend>/../database/migrations  (layout repo, es. locale senza volume)
  3. /app/migrations                     (volume montato in compose)
  4. /app/database/migrations           (immagine Docker con contesto project/)
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

import psycopg

BASE_DIR = Path(__file__).resolve().parent

ORDERED_MIGRATIONS = [
    ("001_core", "001_core.sql"),
    ("002_marconi_seed", "002_marconi_seed.sql"),
    ("003_publish_marconi", "003_publish_marconi.sql"),
    ("004_business_images", "004_business_images.sql"),
    ("005_remove_demo_content", "005_remove_demo_content.sql"),
]


def find_migrations_dir() -> Path:
    candidates: list[Path] = []
    env = os.getenv("MIGRATIONS_DIR", "").strip()
    if env:
        candidates.append(Path(env))
    candidates += [
        BASE_DIR.parent / "database" / "migrations",
        BASE_DIR / "migrations",
        Path("/app/migrations"),
        Path("/app/database/migrations"),
    ]
    for path in candidates:
        if path.is_dir() and (path / "001_core.sql").exists():
            return path
    tried = ", ".join(str(p) for p in candidates)
    print(f"[migrate] cartella migrazioni non trovata. Provate: {tried}", file=sys.stderr)
    raise SystemExit(2)


def _connect() -> psycopg.Connection:
    url = os.getenv("DATABASE_URL", "")
    if not url:
        print("[migrate] DATABASE_URL mancante.", file=sys.stderr)
        raise SystemExit(2)
    # Neon richiede TLS: aggiungi sslmode=require se assente.
    if "sslmode" not in url and ("neon.tech" in url or "render" in url.lower()):
        sep = "&" if "?" in url else "?"
        url = f"{url}{sep}sslmode=require"
    return psycopg.connect(url, autocommit=True)


def _applied_ids(conn: psycopg.Connection) -> set[str]:
    with conn.cursor() as cur:
        cur.execute(
            """
            CREATE TABLE IF NOT EXISTS schema_migrations (
              migration_id VARCHAR(120) PRIMARY KEY,
              applied_at TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        cur.execute("SELECT migration_id FROM schema_migrations")
        return {row[0] for row in cur.fetchall()}


def pending() -> list[tuple[str, Path]]:
    migrations_dir = find_migrations_dir()
    print(f"[migrate] uso cartella: {migrations_dir}")
    out: list[tuple[str, Path]] = []
    for migration_id, filename in ORDERED_MIGRATIONS:
        path = migrations_dir / filename
        if not path.exists():
            print(f"[migrate] file mancante: {path}", file=sys.stderr)
            raise SystemExit(2)
        out.append((migration_id, path))
    return out


def apply() -> int:
    items = pending()
    with _connect() as conn:
        applied = _applied_ids(conn)
        todo = [(mid, p) for mid, p in items if mid not in applied]
        if not todo:
            print("[migrate] tutto aggiornato.")
            return 0
        for migration_id, path in todo:
            sql = path.read_text(encoding="utf-8")
            print(f"[migrate] applico {migration_id} ({path.name})...")
            with conn.cursor() as cur:
                cur.execute(sql)
            print(f"[migrate] ok {migration_id}.")
        print(f"[migrate] applicate {len(todo)} migrazioni.")
        return 0


def check() -> int:
    with _connect() as conn:
        applied = _applied_ids(conn)
        missing = [mid for mid, _ in pending() if mid not in applied]
        if missing:
            print(f"[migrate] migrazioni mancanti: {', '.join(missing)}")
            return 1
        print("[migrate] tutto aggiornato.")
        return 0


if __name__ == "__main__":
    if "--check" in sys.argv[1:]:
        raise SystemExit(check())
    raise SystemExit(apply())
