-- Updated 03-Oct-2026
-- =====================================================
-- Hotel Revenue & Booking Intelligence Project
-- Step 1: Data Cleaning & Preparation
-- ============================================================
-- This script takes the raw hotel bookings data and produces
-- a clean, analysis-ready table (hotel_bookings_clean) with
-- derived columns needed for ADR, RevPAR, occupancy,
-- cancellation loss, and customer segmentation analysis.
-- ============================================================

USE hotelanalytics;

-- ------------------------------------------------------------
-- 1. Remove duplicate rows from raw data
-- ------------------------------------------------------------
-- hotel_bookings_raw may contain exact duplicate rows.
-- SELECT DISTINCT removes them while creating the clean table.

CREATE TABLE hotel_bookings_clean AS
SELECT DISTINCT *
FROM hotel_bookings_raw;


-- ------------------------------------------------------------
-- 2. Build a proper arrival_date column
-- ------------------------------------------------------------
-- Raw data stores year, month (as text), and day separately.
-- Combine them into a single DATE column for time-based analysis.

ALTER TABLE hotel_bookings_clean ADD COLUMN arrival_date DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE hotel_bookings_clean
SET arrival_date = STR_TO_DATE(
    CONCAT(arrival_date_year, '-', arrival_date_month, '-', arrival_date_day_of_month),
    '%Y-%M-%d'
);


-- ------------------------------------------------------------
-- 3. Add total_nights and revenue columns
-- ------------------------------------------------------------
-- total_nights = weekend nights + week nights
-- revenue = adr (average daily rate) x total_nights
-- These are the base columns for ADR, RevPAR, and revenue KPIs.

ALTER TABLE hotel_bookings_clean
  ADD COLUMN total_nights INT,
  ADD COLUMN revenue DECIMAL(10,2);

UPDATE hotel_bookings_clean
SET total_nights = stays_in_weekend_nights + stays_in_week_nights,
    revenue = adr * (stays_in_weekend_nights + stays_in_week_nights);


-- ------------------------------------------------------------
-- 4. Add lead_time_bucket column
-- ------------------------------------------------------------
-- Groups bookings by how far in advance they were made.
-- Used for cancellation-by-lead-time analysis (Page 3).

ALTER TABLE hotel_bookings_clean ADD COLUMN lead_time_bucket VARCHAR(20);

UPDATE hotel_bookings_clean
SET lead_time_bucket = CASE
    WHEN lead_time <= 7  THEN '0-7 days'
    WHEN lead_time <= 30 THEN '8-30 days'
    WHEN lead_time <= 90 THEN '31-90 days'
    ELSE '90+ days'
END;


-- ------------------------------------------------------------
-- 5. Remove invalid rows (no guests at all)
-- ------------------------------------------------------------
-- A booking with zero adults, children, and babies is not a
-- valid reservation and would distort occupancy/revenue metrics.

DELETE FROM hotel_bookings_clean
WHERE adults = 0 AND children = 0 AND babies = 0;


-- ------------------------------------------------------------
-- 6. Handle NULLs in children column
-- ------------------------------------------------------------
-- NULL children values are treated as 0 (no children on booking).

UPDATE hotel_bookings_clean
SET children = 0
WHERE children IS NULL;


-- ------------------------------------------------------------
-- 7. Add customer_segment column
-- ------------------------------------------------------------
-- Business-driven segmentation used for Page 4 (Customer &
-- Booking Channel Analytics). Thresholds were chosen based on
-- the dataset's own ADR/revenue distribution (25th percentile
-- ADR ~ 98.75, used to define "Price Sensitive").

ALTER TABLE hotel_bookings_clean ADD COLUMN customer_segment VARCHAR(30);

UPDATE hotel_bookings_clean
SET customer_segment = CASE
    WHEN is_canceled = 1 AND lead_time > 90 THEN 'High Cancellation Risk'
    WHEN revenue >= 500 AND total_nights >= 5 THEN 'VIP / High Value'
    WHEN adr <= 60 THEN 'Price Sensitive'
    ELSE 'Regular'
END;

-- Refinement: widen the Price Sensitive threshold closer to the
-- dataset's 25th percentile ADR value (~98.75) so the segment
-- isn't underrepresented.
UPDATE hotel_bookings_clean
SET customer_segment = 'Price Sensitive'
WHERE adr <= 100 AND customer_segment = 'Regular';


-- ------------------------------------------------------------
-- 8. Verification checks
-- ------------------------------------------------------------

-- Confirm derived columns populated correctly
SELECT arrival_date, total_nights, revenue, lead_time_bucket, customer_segment
FROM hotel_bookings_clean
LIMIT 10;

-- Confirm segment distribution looks reasonable
SELECT customer_segment, COUNT(*) AS bookings, AVG(revenue) AS avg_revenue
FROM hotel_bookings_clean
GROUP BY customer_segment;

-- Final row count of the cleaned table
SELECT COUNT(*) AS total_rows FROM hotel_bookings_clean;
