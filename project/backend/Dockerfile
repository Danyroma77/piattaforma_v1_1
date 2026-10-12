FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# Migrazioni eseguite all'avvio via migrate.py (idempotente).
# In locale le trova in /app/migrations (volume compose); su Render in /app/database/migrations.
EXPOSE 8025
CMD ["sh", "-c", "python -m migrate && uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8025}"]

