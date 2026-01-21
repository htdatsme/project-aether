FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
COPY .env .env

CMD exec uvicorn app.main:app --host 0.0.0.0 --port $PORT
