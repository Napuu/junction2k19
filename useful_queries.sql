CREATE TABLE monthly_visits AS SELECT CAST(AVG(visit_sum) as INTEGER) as visits, month, geom
FROM(SELECT SUM(visits) as visit_sum, EXTRACT(YEAR FROM starttime) as year, EXTRACT(MONTH FROM starttime) as month, geom
      FROM junction
      GROUP BY month, year, geom) as sums
GROUP BY month, geom;
