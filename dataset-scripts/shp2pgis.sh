ogr2ogr -f PostgreSQL PG:"$OGRPGSTRING" -nln public.polut merge.shp -append
