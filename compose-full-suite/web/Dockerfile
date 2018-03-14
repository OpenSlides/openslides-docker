from openslides

EXPOSE 8000

CMD DJANGO_SETTINGS_MODULE=settings \
  PYTHONPATH=personal_data/var/ \
  daphne openslides.asgi:channel_layer -p 8000 -b 0.0.0.0 
