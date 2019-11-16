#!/bin/bash
srcdir=polut
targetdir=polutshp
# ls polutshp -1 |grep ".shp" | while read line ; 
ls polut | while read line ; 
do
	a=$(basename $line)
	a=${a##*/}
	a=${a%.geojson}
	# mv polut/$a.json polut/$a.geojson
	#echo $a
	# to shapefile
	ogr2ogr -f "ESRI Shapefile" $targetdir/$a.shp $srcdir/$line
	# merge shapefiles
	ogr2ogr -f "ESRI Shapefile" -update -append $targetdir/merged.shp $targetdir/$a.shp -nln merge
	#echo $line

done
