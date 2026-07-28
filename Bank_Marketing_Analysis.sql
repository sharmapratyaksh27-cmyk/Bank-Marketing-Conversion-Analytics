CREATE DATABASE bank_marketing_portfolio;
USE bank_marketing_portfolio;

CREATE TABLE campaign_data (
    age INT,
    job VARCHAR(50),
    marital VARCHAR(20),
    education VARCHAR(50),
    default_status VARCHAR(10),
    balance INT,
    housing VARCHAR(10),
    loan VARCHAR(10),
    contact VARCHAR(20),
    day INT,
    month VARCHAR(10),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(20),
    subscribed VARCHAR(10)
);

SELECT COUNT(*) FROM campaign_data;

-- Query 1: Conversion Rate by Job Sector
-- Identify which professions are most likely to subscribe to the term deposit.

SELECT 
    job, 
    COUNT(*) AS total_contacted,
    SUM(CASE WHEN subscribed = 'yes' THEN 1 ELSE 0 END) AS total_subscribed,
    ROUND((SUM(CASE WHEN subscribed = 'yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS conversion_rate_pct
FROM campaign_data
GROUP BY job
ORDER BY conversion_rate_pct DESC;

-- Query 2: The Impact of Previous Campaign Success
-- Does a previously successful interaction guarantee future success?

SELECT 
    poutcome AS previous_campaign_outcome,
    COUNT(*) AS total_customers,
    ROUND((SUM(CASE WHEN subscribed = 'yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS current_conversion_rate
FROM campaign_data
GROUP BY poutcome;

-- Query 3: Customer Segmentation by Wealth (Using Window Functions)
-- Rank different marital and education segments by their average bank balances.

SELECT 
    marital,
    education,
    ROUND(AVG(balance), 2) AS avg_balance,
    RANK() OVER(ORDER BY AVG(balance) DESC) as wealth_rank
FROM campaign_data
GROUP BY marital, education;