From python:3.10.6-slim-buster
COPY app /app
WORKDIR /app
RUN pip install -r requirements.txt
ENV MONGODB_URI="mongodb://root:example@mongodb:27017"
ENTRYPOINT [ "python3", "app.py" ]