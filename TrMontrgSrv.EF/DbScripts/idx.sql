CREATE INDEX IF NOT EXISTS frame_device_id_capture_dt_idx ON frame USING btree(device_id, capture_dt);

CREATE INDEX IF NOT EXISTS roi_device_id_roi_id_capture_dt_idx ON roi USING btree(device_id, roi_id, capture_dt);