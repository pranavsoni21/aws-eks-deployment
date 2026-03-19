FROM python:3.14-slim

WORKDIR /app

COPY *.py .

RUN pip install flask

EXPOSE 5000

CMD ["python3", "app.py"] 