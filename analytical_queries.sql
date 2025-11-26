-- Query 1: Carrier Performance
SELECT 
    c.carrier_name, 
    AVG(ft.dep_delay) AS average_delay_minutes,
    COUNT(f.flight_id) AS total_flights
FROM flights f
JOIN carriers c ON f.carrier_code = c.carrier_code
JOIN flight_timings ft ON f.flight_id = ft.flight_id
GROUP BY c.carrier_name
ORDER BY average_delay_minutes DESC;

-- Query 2: Airport Traffic
SELECT 
    f.origin_airport, 
    ci.city_name,
    COUNT(f.flight_id) AS total_departures
FROM flights f
JOIN airports a ON f.origin_airport = a.airport_code
JOIN cities ci ON a.city_id = ci.city_id
GROUP BY f.origin_airport, ci.city_name
ORDER BY total_departures DESC;

-- Query 3: Cancellation Reasons
SELECT 
    can.cancel_code,
    COUNT(f.flight_id) AS number_of_cancellations
FROM flights f
JOIN cancellations can ON f.flight_id = can.flight_id
WHERE can.is_cancelled = 1
GROUP BY can.cancel_code
ORDER BY number_of_cancellations DESC;

-- Query 4: Top 5 Longest Flights
SELECT 
    f.flight_num, 
    f.origin_airport, 
    f.dest_airport, 
    fo.distance
FROM flights f
JOIN flight_operations fo ON f.flight_id = fo.flight_id
ORDER BY fo.distance DESC
LIMIT 5;

-- Query 5: Weather Delays > 15 Mins
SELECT 
    f.flight_num, 
    f.fl_date, 
    ds.weather_delay
FROM flights f
JOIN delay_stats ds ON f.flight_id = ds.flight_id
WHERE ds.weather_delay > 15;