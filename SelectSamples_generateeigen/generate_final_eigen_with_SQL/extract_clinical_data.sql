--从matlab中得到包含年龄、性别、整个数据段其实记录时间、AHE开始时间点、70个特征值的表
--根据subject_id,找到GCS、身高、体重、体温数据
CREATE MATERIALIZED VIEW  yj_finaleigen AS
WITH converttime AS (--开始时间点转换为时间间隔
         SELECT (yte.startpoint || ' minute'::text) AS intervaltime,
            yte.subject_id,
            yte.start_time
           FROM mimic2v26.yj_timepoint  yte
        ), begintime AS (--数据段开始的时刻
         SELECT (cvt.start_time + (cvt.intervaltime)::interval) AS pointtime,--急性低血压开始的时间点
            cvt.subject_id,
            cvt.start_time
           FROM converttime cvt
        ), full_tem AS
( SELECT
           bg.subject_id,
           -- gcs.icustay_id,
            tem.charttime,
            tem.value1num,
            bg.pointtime,
            bg.start_time
  FROM (mimic2v26.temperature tem
             RIGHT JOIN begintime bg ON (((bg.subject_id = tem.subject_id) AND ((tem.charttime >= bg.pointtime) AND (tem.charttime <= (bg.pointtime + '10:00:00'::interval))))))
),eigen_tem AS (
         SELECT full_tem.subject_id,
            full_tem.pointtime,
           full_tem.start_time,
           -- full_value.icustay_id,
            min(full_tem.value1num) OVER (PARTITION BY full_tem.subject_id ORDER BY full_tem.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_tem,
            max(full_tem.value1num) OVER (PARTITION BY full_tem.subject_id ORDER BY full_tem.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_tem,
            avg(full_tem.value1num) OVER (PARTITION BY full_tem.subject_id  ORDER BY full_tem.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS mean_tem
           FROM full_tem
        ) ,addtem AS
(
  SELECT DISTINCT
    eigen_tem.pointtime,
   yt.*,
    eigen_tem.min_tem,
    eigen_tem.max_tem,
    eigen_tem.mean_tem
   FROM eigen_tem
RIGHT JOIN  yj_timepoint yt
ON yt.subject_id=eigen_tem.subject_id AND yt.start_time=eigen_tem.start_time
), full_value AS (--提取出十小时（pointtime到之后的10小时内）的全部GCS数据
         SELECT bg.subject_id,
           -- gcs.icustay_id,
            gcs.charttime,
            gcs.value1num,
            bg.pointtime,
           bg.start_time
           FROM (mimic2v26.gcs
             RIGHT JOIN begintime bg ON (((bg.subject_id = gcs.subject_id) AND ((gcs.charttime >= bg.pointtime) AND (gcs.charttime <= (bg.pointtime + '10:00:00'::interval))))))
        ), eigen AS (
         SELECT full_value.subject_id,
            full_value.pointtime,
           full_value.start_time,
           -- full_value.icustay_id,
            min(full_value.value1num) OVER (PARTITION BY full_value.subject_id ORDER BY full_value.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_gcs,
            max(full_value.value1num) OVER (PARTITION BY full_value.subject_id ORDER BY full_value.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_gcs,
            avg(full_value.value1num) OVER (PARTITION BY full_value.subject_id  ORDER BY full_value.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS mean_gcs
           FROM full_value
        ) ,addgcs AS
(
   SELECT DISTINCT
   addtem.*,
    eigen.min_gcs,
    eigen.max_gcs,
    eigen.mean_gcs
   FROM eigen
RIGHT JOIN  addtem
ON addtem.subject_id=eigen.subject_id AND addtem.start_time=eigen.start_time
)
  ,addheightweight AS
(
  SELECT DISTINCT
 addgcs. *,
    height,
    weight_first,
    weight_min,
    weight_max
FROM yj_heightweight yhw
RIGHT JOIN  addgcs
  ON addgcs.subject_id=yhw.subject_id
)
SELECT
  *,
rank() OVER (PARTITION BY ahw.subject_id ORDER BY ahw.pointtime) AS subject_id_order
FROM  addheightweight   ahw



SELECT  DISTINCT  subject_id
FROM yj_finaleigen