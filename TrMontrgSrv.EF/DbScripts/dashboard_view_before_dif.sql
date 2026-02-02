-- Device Summary Info View.
CREATE OR REPLACE VIEW public.fact_device
AS
SELECT device.device_id,
       device.loc_id,
       device.plant_id,
       device.desn
FROM device
ORDER BY device.device_id;

-- Current Frame Temperature View.
CREATE VIEW public.dim_cur_frame AS
WITH recent_frames AS (
  SELECT
    device_id,
    ROW_NUMBER() OVER (PARTITION BY device_id ORDER BY capture_dt DESC) AS rn,
    t_avg,
    t_max,
    t_min,
    t_diff
  FROM frame
)
SELECT
  a.device_id,
  0 AS id,
  a.t_avg AS avg,
  a.t_max AS max,
  a.t_min AS min,
  a.t_diff AS dif,
  ROUND(a.t_avg::numeric - b.t_avg::numeric, 2) AS dif_avg,
  ROUND(a.t_max::numeric - b.t_max::numeric, 2) AS dif_max,
  ROUND(a.t_min::numeric - b.t_min::numeric, 2) AS dif_min,
  ROUND(a.t_diff::numeric - b.t_diff::numeric, 2) AS dif_dif
FROM recent_frames a
JOIN recent_frames b ON a.device_id = b.device_id
AND a.rn = 1 AND b.rn = 2
ORDER BY a.device_id;

-- Current Box Temperature View.
CREATE OR REPLACE VIEW public.dim_cur_box AS
WITH recent_boxes AS (
  SELECT
    device_id,
    box_id,
    ROW_NUMBER() OVER (PARTITION BY device_id, box_id ORDER BY capture_dt DESC) AS rn,
    t_avg,
    t_max,
    t_min,
    t_diff,
    capture_dt
  FROM box
)
SELECT
  a.device_id,
  b.box_id AS id,
  a.t_avg AS avg,
  a.t_max AS max,
  a.t_min AS min,
  a.t_diff AS dif,
  ROUND(a.t_avg::numeric - b.t_avg::numeric, 2) AS dif_avg,
  ROUND(a.t_max::numeric - b.t_max::numeric, 2) AS dif_max,
  ROUND(a.t_min::numeric - b.t_min::numeric, 2) AS dif_min,
  ROUND(a.t_diff::numeric - b.t_diff::numeric, 2) AS dif_dif
FROM recent_boxes a
JOIN recent_boxes b ON a.device_id = b.device_id and a.box_id = b.box_id
WHERE a.rn = 1 AND b.rn = 2
  AND DATE_TRUNC('day', a.capture_dt) = DATE_TRUNC('day', CURRENT_DATE)
  AND DATE_TRUNC('day', b.capture_dt) = DATE_TRUNC('day', CURRENT_DATE)
ORDER BY a.device_id, a.box_id;


-- Current Roi Temperature View.
CREATE OR REPLACE VIEW public.dim_cur_roi AS
WITH recent_boxes AS (
  SELECT
    device_id,
    roi_id,
    ROW_NUMBER() OVER (PARTITION BY device_id, roi_id ORDER BY capture_dt DESC) AS rn,
    t_avg,
    t_max,
    t_min,
    t_diff,
    capture_dt
  FROM roi
)
SELECT
  a.device_id,
  b.roi_id AS id,
  a.t_avg AS avg,
  a.t_max AS max,
  a.t_min AS min,
  a.t_diff AS dif,
  ROUND(a.t_avg::numeric - b.t_avg::numeric, 2) AS dif_avg,
  ROUND(a.t_max::numeric - b.t_max::numeric, 2) AS dif_max,
  ROUND(a.t_min::numeric - b.t_min::numeric, 2) AS dif_min,
  ROUND(a.t_diff::numeric - b.t_diff::numeric, 2) AS dif_dif
FROM recent_boxes a
JOIN recent_boxes b ON a.device_id = b.device_id and a.roi_id = b.roi_id
WHERE a.rn = 1 AND b.rn = 2
  AND DATE_TRUNC('day', a.capture_dt) = DATE_TRUNC('day', CURRENT_DATE)
  AND DATE_TRUNC('day', b.capture_dt) = DATE_TRUNC('day', CURRENT_DATE)
ORDER BY a.device_id, a.roi_id;