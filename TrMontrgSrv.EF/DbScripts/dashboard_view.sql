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
CREATE OR REPLACE VIEW public.dim_cur_frame AS
SELECT d.device_id,
       COALESCE(f.id, 0) AS id,
       COALESCE(f.t_avg, 0::real) AS avg,
       COALESCE(f.t_max, 0::real) AS max,
       COALESCE(f.t_min, 0::real) AS min,
       COALESCE(f.t_diff, 0::real) AS dif
FROM device d
LEFT JOIN LATERAL (
         SELECT 0 AS id,
                frame.t_avg,
                frame.t_max,
                frame.t_min,
                frame.t_diff
           FROM frame
          WHERE frame.device_id::text = d.device_id::text
            AND to_char(frame.capture_dt, 'YYYYMMDD'::text) = to_char(CURRENT_DATE::timestamp with time zone, 'YYYYMMDD'::text)
          ORDER BY frame.capture_dt DESC
         LIMIT 1
     ) f ON true
ORDER BY d.device_id;

-- Current Box Temperature View.
CREATE OR REPLACE VIEW public.dim_cur_box AS
SELECT a.device_id,
    b.box_id AS id,
    COALESCE(b.t_avg, 0::real) AS avg,
    COALESCE(b.t_max, 0::real) AS max,
    COALESCE(b.t_min, 0::real) AS min,
    COALESCE(b.t_diff, 0::real) AS dif
FROM device a
LEFT JOIN ( SELECT box.device_id,
            box.box_id,
            box.t_avg,
            box.t_max,
            box.t_min,
            box.t_diff
           FROM box
          WHERE ((box.device_id::text, box.capture_dt) IN ( SELECT sub.device_id,
                    max(sub.capture_dt) AS max
                   FROM box sub
                  GROUP BY sub.device_id
                 HAVING to_char(max(sub.capture_dt), 'YYYYMMDD'::text) = to_char(CURRENT_DATE::timestamp with time zone, 'YYYYMMDD'::text)))
          ORDER BY box.device_id) b ON a.device_id::text = b.device_id::text
  ORDER BY a.device_id, b.box_id;

-- Current Roi Temperature View.
CREATE OR REPLACE VIEW public.dim_cur_roi AS
 SELECT a.device_id,
    b.roi_id AS id,
    COALESCE(b.t_avg, 0::real) AS avg,
    COALESCE(b.t_max, 0::real) AS max,
    COALESCE(b.t_min, 0::real) AS min,
    COALESCE(b.t_diff, 0::real) AS dif
   FROM device a
     LEFT JOIN ( SELECT roi.device_id,
            roi.roi_id,
            roi.t_avg,
            roi.t_max,
            roi.t_min,
            roi.t_diff
           FROM roi
          WHERE ((roi.device_id::text, roi.capture_dt) IN ( SELECT sub.device_id,
                    max(sub.capture_dt) AS max
                   FROM roi sub
                  GROUP BY sub.device_id
                 HAVING to_char(max(sub.capture_dt), 'YYYYMMDD'::text) = to_char(CURRENT_DATE::timestamp with time zone, 'YYYYMMDD'::text)))
          ORDER BY roi.device_id) b ON a.device_id::text = b.device_id::text
  ORDER BY a.device_id, b.roi_id;