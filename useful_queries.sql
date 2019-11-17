CREATE TABLE daily_visits_3 as
SELECT CAST(AVG(visit_sum) as INTEGER) as visits, day, geom
FROM(SELECT SUM(visits) as visit_sum, EXTRACT(YEAR FROM starttime) as year, EXTRACT(MONTH FROM starttime) as month, EXTRACT(DAY FROM starttime) as dayz, EXTRACT(DOW FROM starttime) as day, geom
    FROM visits_noempty
    GROUP BY month, year, dayz, day, geom) as sums
    WHERE endtime - starttime = INTERVAL '1 hour'
GROUP BY day, geom;

CREATE TABLE hourly_visits_3 AS
SELECT CAST(AVG(visit_sum) as INTEGER) as visits, hour, geom
FROM(SELECT SUM(visits) as visit_sum, EXTRACT(YEAR FROM starttime) as year, EXTRACT(MONTH FROM endtime) as month, EXTRACT(DAY FROM starttime) as day, EXTRACT(HOUR FROM starttime) as hour, geom
      FROM visits_noempty
      GROUP BY month, year, day, hour, geom) as sums
GROUP BY hour, geom;


CREATE TABLE hourly_visits_3 as
SELECT CAST(AVG(visits) as INTEGER) as visits, EXTRACT(HOUR FROM starttime) as hour, geom
FROM visits_noempty
WHERE endtime - starttime = INTERVAL '1 hour'
GROUP BY hour, geom;

SELECT MAX(visits), starttime, endtime FROM visits_noempty;

CREATE TABLE monthly_visits_3 as
SELECT CAST(AVG(visits) as INTEGER), EXTRACT(MONTH FROM starttime) as month
FROM visits_noempty
WHERE endtime - starttime = INTERVAL '1 month'
GROUP BY month;


CREATE TABLE monthly_visits_2 as
SELECT CAST(AVG(visit_sum) as INTEGER) as visits, month, geom
FROM(SELECT SUM(visits) as visit_sum, EXTRACT(YEAR FROM starttime) as year, EXTRACT(MONTH FROM starttime) as month, geom
    FROM visits_noempty
    WHERE endtime - starttime = interval '1 hour'
    GROUP BY month, year, geom) as sums
GROUP BY month, geom;
