--本程序用来提取急性低血压前30min内的GCS及温度数据，如果没有，用最近的数值代替

with uniqueid as (--年龄大于16周岁，第一次入ICU的患者
  SELECT DISTINCT  * from yj_finaleigen
where subject_id_order =1
and age>16
),
  ---------------------10小时之内的GCS值
    gcs10h AS
(
  SELECT  value1num as gcsvalue
  ,gcs.subject_id
    ,gcs.charttime
  from gcs
RIGHT JOIN uniqueid
   ON  uniqueid.subject_id=gcs.subject_id
and  gcs.charttime BETWEEN  uniqueid.pointtime AND  uniqueid.pointtime +INTERVAL '10' HOUR
),
    --------------10小时之内的tem值
    tem10h AS
(
  SELECT  DISTINCT
    temperature.subject_id
   ,value1uom
    ,value1num as temvalue
  ,temperature.charttime
  FROM  temperature
RIGHT JOIN uniqueid
    ON uniqueid.subject_id=temperature.subject_id
  AND temperature.charttime BETWEEN  uniqueid.pointtime AND  uniqueid.pointtime +INTERVAL '10' HOUR
) ,
    ---------------------- --对10小时内的GCS值按时间顺序排列，最后30min内有缺失值时，用前一时刻的值代替
    sortgcs10h AS
(SELECT
      gcs10h.subject_id
        ,gcs10h.gcsvalue
        ,gcs10h.charttime,
  rank() OVER (PARTITION BY gcs10h.subject_id  ORDER BY gcs10h.charttime DESC ) AS gcsorderid
  FROM  gcs10h
),
    -----------------------根据排序结果，提取最后一次测量值
    latestgcs AS
(
  SELECT
 sortgcs10h.gcsvalue,
sortgcs10h.subject_id
  FROM sortgcs10h
  WHERE  sortgcs10h.gcsorderid=1
),

    ----------对10小时内的值按时间顺序排列，最后30min内有缺失值时，用前一时刻的值代替
    sorttem10 AS
(
  SELECT DISTINCT
  tem10h.subject_id,
    tem10h.temvalue,
    tem10h.charttime,
    rank() OVER (PARTITION BY tem10h.subject_id ORDER BY  tem10h.charttime DESC ) AS temorderid
  FROM tem10h
),

  --根据charttime选择10小时内的最后一次测量值，如果后30min提不出来记录，则最后一次测量记录就是最近的
    latesttem AS
(
  SELECT DISTINCT
  sorttem10.temvalue,
    sorttem10.subject_id
  FROM sorttem10
  WHERE sorttem10.temorderid=1
),

  --计算最后30min内gcs的最大值、最小值、平均值
    scalegcs AS
(
  SELECT DISTINCT
   uniqueid. subject_id,
    max(gcsvalue) OVER (PARTITION BY sortgcs10h.subject_id ORDER BY charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_gcs,
    min(gcsvalue) OVER (PARTITION BY sortgcs10h.subject_id ORDER BY charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_gcs,
    avg(gcsvalue) OVER (PARTITION BY sortgcs10h.subject_id ORDER BY charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS mean_gcs
    FROM sortgcs10h
  RIGHT JOIN uniqueid
      ON uniqueid.subject_id =sortgcs10h.subject_id
    AND sortgcs10h.charttime BETWEEN  uniqueid.pointtime +INTERVAL '570' MINUTE  and uniqueid.pointtime+INTERVAL '10' HOUR
),

  --处理30min内gcs缺失数据，用最后一次测量记录代替
    finalgcs AS
(
  SELECT
 scalegcs.subject_id
   , CASE
      WHEN  scalegcs.mean_gcs IS  NULL  THEN  latestgcs.gcsvalue
      ELSE scalegcs.mean_gcs
      END  AS mean_gcs
  ,CASE
    WHEN scalegcs.mean_gcs IS NULL  THEN latestgcs.gcsvalue
    ELSE scalegcs.max_gcs
    END AS  max_gcs
  ,CASE
    WHEN scalegcs.mean_gcs IS NULL  THEN latestgcs.gcsvalue
    ELSE scalegcs.min_gcs
    END AS min_gcs
  FROM
 scalegcs
LEFT JOIN  latestgcs
  ON scalegcs.subject_id=latestgcs.subject_id
),

    --计算最后30min内体温数据的最大值、最小值、平均值
    scaletem AS
(
  SELECT DISTINCT
    uniqueid.subject_id,
    max(temvalue) OVER (PARTITION BY sorttem10.subject_id ORDER BY charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_tem,
    min(temvalue) OVER (PARTITION BY sorttem10.subject_id ORDER BY charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_tem,
    avg(temvalue) OVER (PARTITION BY sorttem10.subject_id ORDER BY charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS mean_tem
    FROM sorttem10
  RIGHT JOIN  uniqueid
      ON uniqueid.subject_id =sorttem10.subject_id
    AND sorttem10.charttime BETWEEN uniqueid.pointtime +INTERVAL '570' MINUTE  and uniqueid.pointtime+INTERVAL '10' HOUR
),

    ---------处理30min内体温数据的缺失数据
finaltem AS
  (
      SELECT scaletem.subject_id,
        CASE
          WHEN scaletem.min_tem IS  NULL  THEN latesttem.temvalue
          ELSE scaletem.min_tem
          END AS min_tem
      ,CASE
        WHEN scaletem.min_tem IS NULL  THEN latesttem.temvalue
        ELSE scaletem.mean_tem
        END AS mean_tem
      ,CASE
        WHEN scaletem.min_tem IS NULL THEN latesttem.temvalue
        ELSE scaletem.max_tem
        END AS max_tem
FROM scaletem
     LEFT JOIN  latesttem
    ON latesttem.subject_id=scaletem.subject_id
  ),

  ---------将最终提取出来的gcs、tem合并
    meanmaxmin AS
(
  SELECT
  sg.min_gcs,
  sg.mean_gcs,
  sg.max_gcs,
  sg.subject_id,
  st.max_tem,
  st.mean_tem,
  st.min_tem
  FROM finalgcs sg
LEFT JOIN finaltem st
    ON sg.subject_id=st.subject_id
)

SELECT  distinct
subject_id,
  min_gcs,
  mean_gcs,
  max_gcs,
  avg(max_tem) OVER (PARTITION BY  subject_id) AS  max_tem,
  avg(mean_tem)OVER (PARTITION BY subject_id)AS mean_tem,
  avg(min_tem)OVER  (PARTITION BY  subject_id)AS  min_tem
from  meanmaxmin







