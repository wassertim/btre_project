### Build and install packages
FROM python:3.7 as build-python

RUN apt-get -y update \
  && apt-get install -y gettext \
  # Cleanup apt cache
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install pipenv
COPY Pipfile Pipfile.lock /app/
WORKDIR /app
RUN pipenv install --skip-lock --system --deploy --dev


### Final image
FROM python:3.7-slim

ARG STATIC_URL
ENV STATIC_URL ${STATIC_URL:-/static/}

RUN groupadd -r btre && useradd -r -g btre btre

RUN apt-get update \
  && apt-get install -y \
    libxml2 \
    libssl1.1 \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    shared-mime-info \
    mime-support \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY . /app
COPY --from=build-python /usr/local/lib/python3.7/site-packages/ /usr/local/lib/python3.7/site-packages/
COPY --from=build-python /usr/local/bin/ /usr/local/bin/

WORKDIR /app

#RUN mkdir -p /app/media /app/static \
#  && chown -R btre:btre /app/

EXPOSE 8000
ENV PORT 8000
ENV PYTHONUNBUFFERED 1
ENV PROCESSES 4

CMD ["uwsgi", "--ini", "/app/btre/wsgi/uwsgi.ini"]
