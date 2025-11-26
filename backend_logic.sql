-- View: Flight Summary
CREATE VIEW View_Flight_Summary AS
SELECT 
    f.flight_id,
    f.fl_date,
    c.carrier_name,
    f.origin_airport,
    f.dest_airport,
    ft.dep_delay,
    CASE 
        WHEN can.is_cancelled = 1 THEN 'Cancelled'
        WHEN ft.dep_delay > 15 THEN 'Delayed'
        ELSE 'On Time'
    END AS flight_status
FROM flights f
JOIN carriers c ON f.carrier_code = c.carrier_code
JOIN flight_timings ft ON f.flight_id = ft.flight_id
LEFT JOIN cancellations can ON f.flight_id = can.flight_id;

-- Stored Procedure: AnalyzeFlightDelay
DELIMITER //

CREATE PROCEDURE AnalyzeFlightDelay(
    IN p_flight_id INT,
    OUT p_total_delay FLOAT,
    INOUT p_status_msg VARCHAR(100)
)
BEGIN
    -- Calculate total delay
    SELECT (COALESCE(dep_delay, 0) + COALESCE(arr_delay, 0)) 
    INTO p_total_delay
    FROM flight_timings
    WHERE flight_id = p_flight_id;

    -- Determine Status
    IF p_total_delay > 30 THEN
        SET p_status_msg = CONCAT(p_status_msg, ' - STATUS: CRITICAL DELAY');
    ELSEIF p_total_delay > 0 THEN
        SET p_status_msg = CONCAT(p_status_msg, ' - STATUS: MINOR DELAY');
    ELSE
        SET p_status_msg = CONCAT(p_status_msg, ' - STATUS: ON TIME/EARLY');
    END IF;
END //

DELIMITER ;