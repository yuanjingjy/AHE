CREATE MATERIALIZED VIEW baseinfo AS SELECT DISTINCT id.subject_id,
    id.gender,
    avg(id.height) OVER (PARTITION BY id.subject_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS height,
    avg(id.icustay_admit_age) OVER (PARTITION BY id.subject_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS age,
    avg(id.weight_first) OVER (PARTITION BY id.subject_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS weight_first,
    avg(id.weight_max) OVER (PARTITION BY id.subject_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS weight_max,
    avg(id.weight_min) OVER (PARTITION BY id.subject_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS weight_min
   FROM (mimic2v26.icustay_detail id
     RIGHT JOIN mimic2v26.eigen ON ((id.subject_id = eigen.subject_id)));
