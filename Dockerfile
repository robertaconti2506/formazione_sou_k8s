FROM python:3.12
WORKDIR /app

COPY requirements.txt .
RUN pip3 install -r requirements.txt 

COPY . .

# Il container è progettato per ascoltare sulla porta 800
EXPOSE 8000

# Quando parte il container, esegue app.py
CMD ["python3", "app.py"]

