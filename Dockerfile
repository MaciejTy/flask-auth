FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY . /app

# Ensure the SQLite instance folder exists (Flask instance path)
RUN mkdir -p /app/instance

EXPOSE 5000

# Use Gunicorn to serve the Flask app
CMD ["gunicorn", "-b", "0.0.0.0:5000", "-w", "2", "main:app"]

