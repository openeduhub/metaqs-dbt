FROM python:3.9
RUN pip install --upgrade pip
RUN pip install alembic databases dbt
COPY ./profiles.yml /root/.dbt/profiles.yml
WORKDIR /dbt
