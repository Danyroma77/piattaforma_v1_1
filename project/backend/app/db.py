import os
import psycopg
from psycopg.rows import dict_row

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://platform:change-me-local@localhost:5432/platform")

def get_connection():
    return psycopg.connect(DATABASE_URL, row_factory=dict_row)
