# Hotel Revenue and Booking Intelligence

An end-to-end hotel analytics project: SQL analysis plus a 5-page Power BI dashboard that covers revenue, occupancy, cancellations, customers, booking channels, and room-level pricing.

## Project goals
- Track revenue, ADR, RevPAR, and occupancy over time
- Find out why bookings get cancelled and how much revenue is lost
- Compare customer segments and booking channels
- Spot underperforming room types and test price changes with a What-If simulation

## Dashboard walkthrough

### Page 1: Hotel Revenue & Booking Intelligence
An executive summary with 8 KPIs: total bookings (2K), cancellation rate (36.13%), total revenue (1.22M), average daily rate (130.76), average lead time (64.88 days), booking-to-room ratio (20.51), RevPAR (93.36), and total available rooms (90). It also has monthly revenue and occupancy trends, revenue by room type, booking channel performance, and an executive insights box.

![Page 1](Page%201.png)

### Page 2: Revenue & Occupancy Analysis
ADR (130.76), RevPAR (93.36), and occupancy (71.40%), with monthly trends for revenue, ADR, occupancy, and RevPAR from July to September. A Peak vs Off-Peak table compares the three periods:

| Period | Occupancy | ADR | RevPAR |
|---|---|---|---|
| Peak | 53.98% | 158.83 | 85.73 |
| Off-Peak | 62.04% | 101.49 | 62.96 |
| Normal | 98.17% | 125.35 | 123.06 |

![Page 2](Page%202.png)

### Page 3: Booking & Cancellation Analysis
Cancellation rate (36.13%), cancellation revenue loss (481.86K), average lead time, and total bookings. Charts show cancellations by month, and cancellation rate by room type, booking channel, and lead time.

![Page 3](Page%203.png)

### Page 4: Customer & Channel Analysis
Total revenue (1.22M), total bookings, and average revenue per booking (661.55). Charts show revenue by customer segment (VIP / High Value, Regular, High Cancellation Risk, Price Sensitive), bookings by customer type, and revenue by booking channel (TA/TO, Direct, Corporate).

![Page 4](Page%204.png)

### Page 5: Room Performance & Pricing
A room-level performance table (revenue, cancellation rate, ADR), a Revenue vs Cancellation Rate chart by room type, and a What-If slider that adjusts prices from -20% to +20% and shows the simulated revenue.

Simulated Revenue = Total Revenue x (1 + Price Adjustment %)

This is a simple simulation. It assumes the number of bookings stays the same when prices change.

![Page 5](Page%205.png)

## Key insights
- TA/TO drives most revenue; Direct is a distant second.
- Room type A earns the most revenue (about 4.73 lakh) but has the lowest ADR (114.01), which makes it the best candidate for a price increase.
- Room type G has the highest cancellation rate (41.49%) and a high ADR (186.84), so premium pricing there comes with higher cancellation risk.
- August has the highest rates but the lowest occupancy, which points to a pricing gap.
- Peak periods have the highest ADR (158.83) but lower occupancy (53.98%).
- Cancellations cost about 481.86K in revenue.

## Metric definitions
- **ADR:** average revenue per room sold
- **RevPAR:** ADR x occupancy
- **Cancellation rate:** cancelled bookings / total bookings
- **Lead time:** days between booking and arrival

## Repository structure
- `sql/`: SQL queries
- `Hotel_Booking_Analytics_Dashboard.pbix`: Power BI report
- `Page 1.png` to `Page 5.png`: dashboard screenshots

## How to open the dashboard
1. Download `Hotel_Booking_Analytics_Dashboard.pbix`.
2. Open it in Power BI Desktop (free to download from Microsoft).

## Tools
Power BI, DAX, SQL
