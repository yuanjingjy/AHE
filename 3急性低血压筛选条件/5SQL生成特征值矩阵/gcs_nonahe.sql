CREATE MATERIALIZED VIEW gcs_nonahe AS WITH converttime AS (
         SELECT (nonahe.startpoint || ' minute'::text) AS intervaltime,
            nonahe.subject_id,
            nonahe.start_time
           FROM mimic2v26.nonahe
        ), begintime AS (
         SELECT (cvt.start_time + (cvt.intervaltime)::interval) AS pointtime,
            cvt.subject_id,
            cvt.start_time
           FROM converttime cvt
        ), full_value AS (
         SELECT bg.subject_id,
            gcs.icustay_id,
            gcs.charttime,
            gcs.value1num,
            bg.pointtime
           FROM (mimic2v26.gcs
             RIGHT JOIN begintime bg ON (((bg.subject_id = gcs.subject_id) AND ((gcs.charttime >= bg.pointtime) AND (gcs.charttime <= (bg.pointtime + '10:00:00'::interval))))))
        ), eigen AS (
         SELECT full_value.subject_id,
            full_value.pointtime,
            full_value.icustay_id,
            min(full_value.value1num) OVER (PARTITION BY full_value.subject_id, full_value.pointtime ORDER BY full_value.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_gcs,
            max(full_value.value1num) OVER (PARTITION BY full_value.subject_id, full_value.pointtime ORDER BY full_value.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_gcs,
            avg(full_value.value1num) OVER (PARTITION BY full_value.subject_id, full_value.pointtime ORDER BY full_value.charttime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS mean_gcs
           FROM full_value
        )
 SELECT DISTINCT eigen.subject_id,
    eigen.pointtime,
    eigen.icustay_id,
    eigen.min_gcs,
    eigen.max_gcs,
    eigen.mean_gcs
   FROM eigen;
