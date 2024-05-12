
Select *
From BankCustomer.dbo.Customer

-- Change 1 or 0 to Yes or No


Select churn
, CASE When churn = '1' THEN 'Yes'
	   When churn = '0' THEN 'No'
	   ELSE churn
	   END
From BankCustomer.dbo.Customer

ALTER TABLE Customer
ALTER COLUMN churn VARCHAR(3)

UPDATE Customer
SET churn = CASE 
    WHEN churn = '1' THEN 'Yes'
    WHEN churn = '0' THEN 'No'
    ELSE 'Unknown'
END;

-- Costumer Credit card

Select credit_card
, CASE When credit_card = '1' THEN 'Yes'
	   When credit_card = '0' THEN 'No'
	   ELSE 'Unknown'
	   END
From BankCustomer.dbo.Customer


ALTER TABLE Customer
ALTER COLUMN credit_card VARCHAR(3)

UPDATE Customer
SET credit_card = CASE 
    WHEN credit_card = '1' THEN 'Yes'
    WHEN credit_card = '0' THEN 'No'
    ELSE 'Unknown'
END;
	

-- check any duplicate

SELECT customer_id, COUNT(*) AS duplicate_count
FROM BankCustomer.dbo.Customer
GROUP BY customer_id
HAVING COUNT(*) > 1;



-- Check Bank Tenure

SELECT 
    CAST(tenure AS varchar(2)) + ' Years' AS tenure_years, 
    COUNT(*) AS customer_count
FROM 
    BankCustomer.dbo.Customer
GROUP BY 
    tenure
ORDER BY 
    CAST(tenure AS INT) ASC;


-- Churn by Gender

SELECT gender, COUNT(*) AS left_bank
FROM BankCustomer.dbo.Customer
WHERE churn = 'Yes'
GROUP BY gender;

SELECT COUNT(*) AS total_customers
FROM BankCustomer.dbo.Customer;


--credit score

SELECT
    CASE 
        WHEN credit_score >= 800 THEN 'Excellent (800-850)'
        WHEN credit_score >= 740 THEN 'Very Good (740-799)'
        WHEN credit_score >= 670 THEN 'Good (670-739)'
        WHEN credit_score >= 580 THEN 'Fair (580-669)'
        ELSE 'Poor (300-579)'
    END AS credit_score_range,
    COUNT(*) AS churn_count
FROM
    BankCustomer.dbo.Customer
WHERE
    churn = 'Yes'
GROUP BY
    CASE 
        WHEN credit_score >= 800 THEN 'Excellent (800-850)'
        WHEN credit_score >= 740 THEN 'Very Good (740-799)'
        WHEN credit_score >= 670 THEN 'Good (670-739)'
        WHEN credit_score >= 580 THEN 'Fair (580-669)'
        ELSE 'Poor (300-579)'
    END
ORDER BY
    MIN(credit_score) ASC;





-- Customer per Country


select country, COUNT(*) AS Customer
from BankCustomer.dbo.Customer
Group by country

-- Churn by active/unactive member

SELECT
    CASE active_member
        WHEN 1 THEN 'Active'
        WHEN 0 THEN 'Inactive'
        ELSE 'Unknown'
    END AS member_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS churn_rate
FROM
    BankCustomer.dbo.Customer
GROUP BY
    active_member;


-- Customer Age

Select 
	MIN(age) AS min_age,
	MAX(age) AS max_age
From BankCustomer.dbo.Customer



SELECT 
    age_group,
    total_customers,
    churned_customers,
    churn_rate
FROM (
    SELECT 
        CASE
            WHEN age BETWEEN 18 AND 35 THEN 'Young (18-35)'
            WHEN age BETWEEN 36 AND 55 THEN 'Middle-aged (36-55)'
            WHEN age BETWEEN 56 AND 75 THEN 'Older (56-75)'
            ELSE 'Unknown'
        END AS age_group,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS churn_rate
    FROM 
        BankCustomer.dbo.Customer
    GROUP BY 
        CASE
            WHEN age BETWEEN 18 AND 35 THEN 'Young (18-35)'
            WHEN age BETWEEN 36 AND 55 THEN 'Middle-aged (36-55)'
            WHEN age BETWEEN 56 AND 75 THEN 'Older (56-75)'
            ELSE 'Unknown'
        END
) AS age_groups
WHERE 
    age_group <> 'Unknown'
ORDER BY 
    CASE age_group
        WHEN 'Young (18-35)' THEN 1
        WHEN 'Middle-aged (36-55)' THEN 2
        WHEN 'Older (56-75)' THEN 3
        ELSE 4
    END;
