#!/bin/bash

# Зупинити виконання скрипта у разі помилки
set -e

# Виконання міграцій бази даних
echo "Running database migrations..."
python manage.py migrate

# Створення суперкористувача, якщо він ще не існує
echo "Checking for existing superuser..."
if [ "$DJANGO_SUPERUSER_USERNAME" ] && [ "$DJANGO_SUPERUSER_EMAIL" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
    python manage.py createsuperuser --noinput || echo "Superuser already exists."
fi

# Запуск основної команди контейнера
exec "$@"


docker build -t my-django-app:latest .
docker tag my-django-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/my-django-app:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/my-django-app:latest