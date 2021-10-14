FROM python:3.9
RUN pip install dbt
COPY ./profiles.yml /root/.dbt/profiles.yml
WORKDIR /dbt
