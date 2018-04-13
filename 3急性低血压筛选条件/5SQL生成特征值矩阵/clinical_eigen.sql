CREATE MATERIALIZED VIEW clinical_eigen AS SELECT gcs_ahe.subject_id,
    gcs_ahe.pointtime,
    gcs_ahe.icustay_id,
    gcs_ahe.min_gcs,
    gcs_ahe.max_gcs,
    gcs_ahe.mean_gcs
   FROM mimic2v26.gcs_ahe
UNION ALL
 SELECT gcs_nonahe.subject_id,
    gcs_nonahe.pointtime,
    gcs_nonahe.icustay_id,
    gcs_nonahe.min_gcs,
    gcs_nonahe.max_gcs,
    gcs_nonahe.mean_gcs
   FROM mimic2v26.gcs_nonahe;
