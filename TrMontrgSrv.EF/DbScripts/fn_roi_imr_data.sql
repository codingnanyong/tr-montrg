CREATE OR REPLACE FUNCTION fn_roi_imr_data(
	device_id VARCHAR,
	roi_id INTEGER,
	start_ymd VARCHAR,
	start_hms VARCHAR,
	end_ymd VARCHAR,
	end_hms VARCHAR
)
RETURNS TABLE (
			dt TIMESTAMP,
			tmax FLOAT,
			tmin FLOAT,
			tmin_frame FLOAT,
			diff FLOAT,
			mr_max FLOAT,
			mr_sign_max FLOAT,
			xbar_max FLOAT,
			mr_bar_max FLOAT,
			ucl_i_max FLOAT,
			lcl_i_max FLOAT,
			ucl_mr_max FLOAT,
			lcl_mr_max FLOAT,
			mr_diff FLOAT,
			mr_sign_diff FLOAT,
			xbar_diff FLOAT,
			mr_bar_diff FLOAT,
			ucl_i_diff FLOAT,
			lcl_i_diff FLOAT,
			ucl_mr_diff FLOAT,
			lcl_mr_diff FLOAT
)
LANGUAGE plpgsql
AS $BODY$
	DECLARE const_n INTEGER = 2;
	DECLARE const_e2 NUMERIC = 2.66;
	DECLARE const_d3 NUMERIC = 0;
	DECLARE const_d4 NUMERIC = 3.27;
BEGIN
	RETURN query
		WITH stats AS (
			SELECT
				ROUND(AVG(roi.t_max)::NUMERIC, 2) AS xbar_max,
				ROUND(AVG(roi.t_diff)::NUMERIC, 2) AS xbar_diff,
				COUNT(*) AS k,
				const_n AS n,
				const_e2 AS e2,
				const_d3 AS d3,
				const_d4 AS d4
			FROM
				roi
			WHERE 1=1
				AND roi.device_id = fn_roi_imr_data.device_id
				AND roi.roi_id = fn_roi_imr_data.roi_id
				AND roi.capture_dt >= TO_TIMESTAMP(start_ymd || start_hms, 'YYYYMMDDHH24MISS')
				AND roi.capture_dt <= TO_TIMESTAMP(end_ymd || end_hms, 'YYYYMMDDHH24MISS')
		)
		, stats_mr AS (
			SELECT
				roi.capture_dt AS dt,
				ROUND(roi.t_max::NUMERIC, 1) AS tmax,
				ROUND(roi.t_min::NUMERIC, 1) AS tmin,
				ROUND(frame.t_min::NUMERIC, 1) AS tmin_frame,
				ROUND((roi.t_diff)::NUMERIC, 1) AS diff,
				ABS(ROUND((roi.t_max - LAG(roi.t_max) OVER (ORDER BY roi.capture_dt))::NUMERIC, 2)) AS mr_max,
				ROUND((roi.t_max - LAG(roi.t_max) OVER (ORDER BY roi.capture_dt))::NUMERIC, 2) AS mr_sign_max,
				ABS(ROUND((roi.t_diff - LAG(roi.t_diff) OVER (ORDER BY roi.capture_dt))::NUMERIC, 2)) AS mr_diff,
				ROUND((roi.t_diff - LAG(roi.t_diff) OVER (ORDER BY roi.capture_dt))::NUMERIC, 2) AS mr_sign_diff,
				stats.xbar_max,
				stats.xbar_diff,
				k,
				n,
				e2,
				d3,
				d4
			FROM
				roi LEFT OUTER JOIN frame ON (roi.ymd = frame.ymd AND roi.hms = frame.hms AND roi.device_id = frame.device_id),
				stats
			WHERE 1=1
				AND roi.device_id = fn_roi_imr_data.device_id
				AND roi.roi_id = fn_roi_imr_data.roi_id
				AND roi.capture_dt >= TO_TIMESTAMP(start_ymd || start_hms, 'YYYYMMDDHH24MISS')
				AND roi.capture_dt <= TO_TIMESTAMP(end_ymd || end_hms, 'YYYYMMDDHH24MISS')
		)
		, stats_mr_sum AS (
			SELECT
				SUM(stats_mr.mr_max) AS mr_max_sum,
				SUM(stats_mr.mr_diff) AS mr_diff_sum
			FROM stats_mr
		)
		SELECT
			stats_mr.dt,
			stats_mr.tmax::FLOAT,
			stats_mr.tmin::FLOAT,
			stats_mr.tmin_frame::FLOAT,
			stats_mr.diff::FLOAT,
			stats_mr.mr_max::FLOAT,
			stats_mr.mr_sign_max::FLOAT,
			stats_mr.xbar_max::FLOAT,
			ROUND(stats_mr_sum.mr_diff_sum / (stats_mr.k - 1)::NUMERIC, 2)::FLOAT AS mr_bar_max,
			ROUND(stats_mr.xbar_max + e2 * ROUND((stats_mr_sum.mr_max_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS ucl_i_max,
			ROUND(stats_mr.xbar_max - e2 * ROUND((stats_mr_sum.mr_max_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS lcl_i_max,
			ROUND(stats_mr.d4 * ROUND((stats_mr_sum.mr_max_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS ucl_mr_max,
			ROUND(stats_mr.d3 * ROUND((stats_mr_sum.mr_max_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS lcl_mr_max,
			stats_mr.mr_diff::FLOAT,
			stats_mr.mr_sign_diff::FLOAT,
			stats_mr.xbar_diff::FLOAT,
			ROUND(stats_mr_sum.mr_diff_sum / (stats_mr.k - 1)::NUMERIC, 2)::FLOAT AS mr_bar_diff,
			ROUND(stats_mr.xbar_diff + e2 * ROUND((stats_mr_sum.mr_diff_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS ucl_i_diff,
			ROUND(stats_mr.xbar_diff - e2 * ROUND((stats_mr_sum.mr_diff_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS lcl_i_diff,
			ROUND(stats_mr.d4 * ROUND((stats_mr_sum.mr_diff_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS ucl_mr_diff,
			ROUND(stats_mr.d3 * ROUND((stats_mr_sum.mr_diff_sum / (k - 1))::NUMERIC, 2)::NUMERIC, 2)::FLOAT AS lcl_mr_diff
		FROM stats_mr, stats_mr_sum;
END;
$BODY$
