import psycopg2

# SELECT *
# FROM your_table
# WHERE ST_Distance_Sphere(the_geom, ST_MakePoint(your_lon,your_lat)) <= radius_mi * 1609.34
try:
    conn = psycopg2.connect("dbname='test' user='avnadmin' host='junction2k19-db-aarnio-b109.aivencloud.com' port='16910' password='nokmwq63rc6seyjs'")
    print("connected")
    conn.autocommit = True
    cur = conn.cursor()
    # actual measurement points
    # this should be run separately for monthly, daily and hourly
    # cur.execute("select visits, geom, month, ST_X(geom), ST_Y(geom), ogc_fid from " + target_table)
    # creating interpolated table:
    # create table ipvisits_monthly as select * from monthly_visits_2;
    # update ipvisits_monthly set visits = 0;
    count = 0
    for i in range(0, 24):
      target_table = "monthly_visits_2"
      # target_table = "hourly_visits_3"
      cur.execute("select visits, geom, month, ST_X(st_transform(geom, 4326)), ST_Y(st_transform(geom, 4326)), ogc_fid from " + target_table + " where month = " + str(i))
      # cur.execute("select visits, geom, hour, ST_X(st_transform(geom, 4326)), ST_Y(st_transform(geom, 4326)), ogc_fid from " + target_table + " where hour = " + str(i))
      rows = cur.fetchall()
      radiuses = [100, 2000, 3000, 4000, 5000]
      for point in rows:
        if (point[3] == None or point[4] == None): continue
        # ipvisits is exported from qgis qchainage plugin using polut as source
        # ST_GeomFromText('POINT(-118 38)',4326)
        for radius in radiuses:
          #ST_GeomFromText('POINT(-118 38)',4326)uu
          # select * from ipvisits where st_distancesphere(ipvisits.wkb_geometry, st_makepoint(24.1527390447457,67.9242369180296,3857)) < 3000;
  #                                                                                      ST_GeomFromText('POINT(-118 38)',4326)
          # WORKING QUERY:
          # query = "select ogc_fid, visits from ip.hourly" + str(i) + " where st_distancesphere(ip.hourly"+str(i) + ".wkb_geometry, st_makepoint("+str(point[3])+","+str(point[4])+",3857)) < "+str(radius)
          query = "select ogc_fid, visits from ip.monthly" + str(i) + " where st_distancesphere(ip.monthly"+str(i) + ".wkb_geometry, st_makepoint("+str(point[3])+","+str(point[4])+",3857)) < "+str(radius)
          # 
          # query = "select ogc_fid from polut_ip where st_distancesphere(polut_ip.wkb_geometry, st_makepoint("+str(point[3])+","+str(point[4])+",3857)) < "+str(radius)
          cur.execute(query)
          affected_points = cur.fetchall()
          for affected_point in affected_points:
            increment = point[0] / len(radiuses)
            if increment + affected_point[1] < point[0]:
              q = "update ip.monthly" + str(i) + " set visits = " + str(int(increment + int(affected_point[1]))) + " where ogc_fid = " + str(affected_point[0])
              # q = "update ip.hourly" + str(i) + " set visits = " + str(int(increment + int(affected_point[1]))) + " where ogc_fid = " + str(affected_point[0])
              print(count, q)
              count = count + 1
              cur.execute(q)

          # query = "select * from ipvisits_monthly where st_distancesphere(ipvisits_monthly.geom, ST_GeomFromText('POINT(-118 38)',4326)) < 1000"
          #select * from ipvisits_monthly where st_distancesphere(ipvisits_monthly.geom, st_geomfromtext('point(24.1527390447457 67.9242369180296)', 4326)) < 1000 
          # SELECT * FROM addresses WHERE ST_DWithin(location, ST_SetSRID(ST_MakePoint(longitude, latitude), 3785), radius);
          # query = "select * from polut st_dwithin(geom, st_setsrid(st_makepoint("+str(point[3])+","+str(point[4])+"), 4326), 5000)"
          # query = "select * from ipvisits_monthly where st_distance(ipvisits_monthly.geom, " + point[1] + ")) < " + str(radius)
        # query = "select * from ipvisits where st_distancesphere(ipvisits.wkb_geometry, st_geomfromtext('(-118 38)',3857)) < 5000"
        # cur.execute()
      # print(rows)
    print("closing")
    conn.commit()
    cur.close()
except Exception as e: print(e)
   # postgres://avnadmin:nokmwq63rc6seyjs@junction2k19-db-aarnio-b109.aivencloud.com:16910/defaultdb?sslmode=require