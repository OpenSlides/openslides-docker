from openslides
 
CMD DJANGO_SETTINGS_MODULE=settings \
  PYTHONPATH=personal_data/var/ \
  daphne openslides.asgi:channel_layer -p $DAPHNE_PORT -b 0.0.0.0 
