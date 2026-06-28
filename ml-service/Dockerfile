# FastAPI ML prediction service
# Python 3.12 (stable wheels for scikit-learn / xgboost; pinned in requirements.txt)
FROM python:3.12-slim

WORKDIR /app

# xgboost needs the OpenMP runtime (libgomp) at import time on slim images,
# otherwise you get "libgomp.so.1: cannot open shared object file".
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Install deps first so this layer is cached when only source changes.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Only what the service needs at runtime (training files are excluded via .dockerignore).
COPY main.py .
COPY artifacts/ ./artifacts/

EXPOSE 8000

# main.py reads ARTIFACTS_DIR (defaults to "artifacts"); the files sit next to it.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
