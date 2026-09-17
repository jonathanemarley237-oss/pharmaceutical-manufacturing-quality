/*
============================================================================================================================
============================================================================================================================
Pharmaceutical Manufacturing Quality Analytics
SQL Analysis
============================================================================================================================
============================================================================================================================

Purpose: 
Analyse historical manufacturing batch data to identify patterns associaed with batch failure, product performance,
manufacturing line performance, process deviations, and temporal variation

Dataset:
Synthetic pharmaceutical manufacturing dataset created for educational and portfolio purposes. Results do not
represent real products, manufacturing processes, or validated pharmaceutical specifications.

============================================================================================================================
============================================================================================================================
*/

/*
============================================================================================================================
============================================================================================================================
1. DATA VALIDATION
============================================================================================================================
============================================================================================================================
*/

/* The first task was to conduct basic validation on the cleaned data set imported as a CSV file  
the total number of rows and number of unique rows was determined to ensure duplicate data was not present*/

SELECT
	COUNT(*) AS total_records,
	COUNT(DISTINCT Batch_ID) AS unique_batches
FROM [Cleaned Data];

/* The resulting query confirmed total_records = unqiue_batches = 3000 */

/* To ensure all batches assessed were within the 2024 - 2025 timeframe, the earliest and latest batches in the dataset 
were identified */ 

SELECT
	MIN(Batch_Date) AS earliest_batch_date,
	MAX(Batch_Date) AS latest_batch_date
FROM [Cleaned Data];

/* The resulting query confirmed the earliest batch date to be 01-01-2024 and the latest batch date to be 31-12-2025 */

/* Queries were then run to confirm the distinct products and manufacturing lines present in the data set as expected */

SELECT DISTINCT Product
FROM [Cleaned Data]
ORDER BY Product;

SELECT DISTINCT Manufacturing_Line
FROM [Cleaned Data]
ORDER BY Manufacturing_Line;

/* The resulting queries confirmed the presence of four unique products and three manufacturing lines in the dataset */

/* A similar query was created to confirm the values observed for Batch_Status, Deviation_Flag, Deviation_Type and 
Deviation_Severity */

SELECT DISTINCT Batch_Status
FROM [Cleaned Data];

SELECT DISTINCT Deviation_Flag
FROM [Cleaned Data];

SELECT DISTINCT Deviation_Type
FROM [Cleaned Data];

SELECT DISTINCT Deviation_Severity
FROM [Cleaned Data];

/* The resulting queries confirmed Batch_Status as a Pass/Failed Boolean string, Deviation_Type and Deviation_Severity as 
the expected categories and Deviation_Flag as a numeric Boolean recoded from a string Boolean (Yes/No) to calculate 
Deviation rate where 0 = no deviation and 1 = deviation raised */

/*
============================================================================================================================
============================================================================================================================
2. OVERALL MANUFACTURING KPIs
============================================================================================================================
============================================================================================================================
*/

/* The next task was to aggregate the dataset and summarise overall manufacturing KPIs by year, assessing both the number 
of failed batches and the number of deviations and subsequently calculating the rate in which both occured in the total 
dataset. Also calculated were the average yield and production time */

SELECT
	YEAR(Batch_Date) AS production_year,

	  COUNT(*) AS total_batches,

    SUM(
        CASE
            WHEN Batch_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_batches,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate_pct,

    SUM(CAST(Deviation_Flag AS INT)) AS deviation_batches,

    ROUND(
        100.0 * SUM(CAST(Deviation_Flag AS INT)) / COUNT(*),
        2
    ) AS deviation_rate_pct,

    ROUND(AVG(Yield_Percent), 2) AS avg_yield_pct,

    ROUND(AVG(Production_Time_Hours), 2) AS avg_production_time_hours

FROM [Cleaned Data]
GROUP BY YEAR(Batch_Date)
ORDER BY production_year

/*
============================================================================================================================
============================================================================================================================
3. PRODUCT PERFORMANCE
============================================================================================================================
============================================================================================================================
*/

/* Addressing the business question "Which products have the least favourable manufacturing performance?", 
a query was written to assess failure rate and deviation rate by grouping the data per product */

SELECT 
	Product AS Product,

    COUNT(*) AS total_batches,

    SUM(
        CASE
            WHEN Batch_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_batches,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate_pct,

    SUM(CAST(Deviation_Flag AS INT)) AS deviation_batches,

    ROUND(
        100.0 * SUM(CAST(Deviation_Flag AS INT)) / COUNT(*),
        2
    ) AS deviation_rate_pct,

    ROUND(AVG(Yield_Percent), 2) AS avg_yield_pct,

    ROUND(AVG(Production_Time_Hours), 2) AS avg_production_time_hours

FROM [Cleaned Data]
GROUP BY Product
ORDER BY failure_rate_pct DESC;

/*
============================================================================================================================
============================================================================================================================
4. MANUFACTURING LINE PERFORMANCE
============================================================================================================================
============================================================================================================================
*/

/* A similar query was conducted to assess which manufacturing line had the least favourable performance */

SELECT 
	Manufacturing_Line AS Manufacturing_Line,

    COUNT(*) AS total_batches,

    SUM(
        CASE
            WHEN Batch_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_batches,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate_pct,

    SUM(CAST(Deviation_Flag AS INT)) AS deviation_batches,

    ROUND(
        100.0 * SUM(CAST(Deviation_Flag AS INT)) / COUNT(*),
        2
    ) AS deviation_rate_pct,

    ROUND(AVG(Yield_Percent), 2) AS avg_yield_pct,

    ROUND(AVG(Production_Time_Hours), 2) AS avg_production_time_hours

FROM [Cleaned Data]
GROUP BY Manufacturing_Line
ORDER BY failure_rate_pct DESC;

/*
============================================================================================================================
============================================================================================================================
5. PRODUCT x MANUFACTURING LINE PERFORMANCE
============================================================================================================================
============================================================================================================================
*/

/* Following this, a query was written to assess if poorer product performance persists across manufacturing lines, or is 
it concentrated on particular lines */

SELECT
    Product AS product,

    Manufacturing_Line AS manufacturing_line,

    COUNT(*) AS total_batches,

    SUM(
        CASE
            WHEN Batch_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_batches,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate_pct

FROM [Cleaned Data]
GROUP BY Product, Manufacturing_Line
ORDER BY failure_rate_pct DESC;

/* A CTE was created to investigate which product-line failure rates above the overall manufacturing failure rate 
of 3.37% */

WITH OverallPerformance AS (
    SELECT
        ROUND(
            100.0 * SUM(
                CASE
                    WHEN Batch_Status = 'Failed' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS overall_failure_rate
    FROM [Cleaned Data]
),

ProductLinePerformance AS (
    SELECT
        Product,
        Manufacturing_Line,
        COUNT(*) AS batch_count,

        SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) AS failed_batches,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN Batch_Status = 'Failed' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS failure_rate_pct

    FROM [Cleaned Data]
    GROUP BY Product, Manufacturing_Line
)

SELECT
    Product,
    Manufacturing_Line,
    batch_count,
    failure_rate_pct,
    overall_failure_rate
FROM ProductLinePerformance
CROSS JOIN OverallPerformance
WHERE failure_rate_pct > overall_failure_rate
ORDER BY failure_rate_pct DESC; 

/*
============================================================================================================================
============================================================================================================================
6. PRODUCT RANKING WITHIN MANUFACTURING LINE 
============================================================================================================================
============================================================================================================================
*/

/* It was then time to query the data to understand for each manufacturing line, which product has the highest failure rate? */

WITH ProductLinePerformance AS (
    SELECT
        Product,
        Manufacturing_Line,
        COUNT(*) AS batch_count,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN Batch_Status = 'Failed' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS failure_rate_pct
 FROM [Cleaned Data]
 GROUP BY Product, Manufacturing_Line )

 SELECT
    Product,
    Manufacturing_Line,
    batch_count,
    failure_rate_pct,

    RANK() OVER (
    PARTITION BY Manufacturing_Line
    ORDER BY failure_rate_pct DESC
    ) AS failure_rank

FROM ProductLinePerformance

ORDER BY
    Manufacturing_Line,
    failure_rank;

/*
============================================================================================================================
============================================================================================================================
7. DEVIATION TYPE ANALYSIS 
============================================================================================================================
============================================================================================================================
*/

/* Which deviation types are associated with the highest observed failure rates? To simplify the resulting table instances 
of no deviations raised were filtered out */

SELECT
	Deviation_Type,

	SUM(CAST(Deviation_Flag AS INT)) AS deviation_count,

	    SUM(
        CASE
            WHEN Batch_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_batches,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate_pct
FROM [Cleaned Data]

WHERE CAST(Deviation_Flag AS INT) = 1

GROUP BY Deviation_Type

ORDER BY failure_rate_pct DESC;

/*
============================================================================================================================
============================================================================================================================
8. DEVIATION SEVERITY ANALYSIS 
============================================================================================================================
============================================================================================================================
*/


/* How does batch failure rate vary by deviation severity? */

SELECT
	Deviation_Severity,

	SUM(CAST(Deviation_Flag AS INT)) AS deviation_count,

	    SUM(
        CASE
            WHEN Batch_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_batches,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate_pct
FROM [Cleaned Data]

WHERE CAST(Deviation_Flag AS INT) = 1

GROUP BY Deviation_Severity

ORDER BY failure_rate_pct DESC;

/*
============================================================================================================================
============================================================================================================================
9. MANUFACTURING LINE x DEVIATION TYPE 
============================================================================================================================
============================================================================================================================
*/

/* How do deviation patterns and associated failure rates differ between manufacturing lines? To simplfy the dataset and 
ensure reliability deviation counts lower than 10 were filtered out */

SELECT
    Manufacturing_Line,

    Deviation_Type,

    SUM(CAST(Deviation_Flag AS INT)) AS deviation_count,

	SUM(
        CASE
            WHEN Batch_Status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_batches,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate_pct

FROM [Cleaned Data]

WHERE CAST(Deviation_Flag AS INT) = 1

GROUP BY
    Manufacturing_Line, Deviation_Type

HAVING COUNT(*)>=10

ORDER BY failure_rate_pct DESC;

/*
============================================================================================================================
============================================================================================================================
10. MONTHLY PERFORMANCE TRENDS 
============================================================================================================================
============================================================================================================================
*/

/* Did batch failure and deviation performance show any meaningful monthly trends or periods of deterioration? */

SELECT
	Year(Batch_Date) AS production_year,

	Month(Batch_Date) AS production_month,

	COUNT(*) AS batch_count,

	SUM(
		CASE
			WHEN Batch_Status = 'Failed' THEN 1
			ELSE 0
		END
		) AS failed_batches,

	ROUND(
		100 * SUM(
			CASE
				WHEN Batch_Status = 'Failed' THEN 1
				ELSE 0
			END
		) / COUNT(*) , 2
		) AS failure_rate_pct,

	SUM(CAST(Deviation_Flag AS INT)) AS deviation_count,

	ROUND(
		100 * SUM(CAST(Deviation_Flag AS INT)) / COUNT(*) , 2
		) AS deviation_rate_pct

	FROM [Cleaned Data]

	GROUP BY
		YEAR(Batch_Date),
		MONTH(Batch_Date)

	ORDER BY
		production_year,
		production_month;

/*
============================================================================================================================
============================================================================================================================
11. THREE-MONTH ROLLING FAILURE RATE 
============================================================================================================================
============================================================================================================================
*/

/* Next, it was time to create a 3-month rolling failure rate */

WITH MonthlyPerformance AS (
    SELECT
        YEAR(Batch_Date) AS production_year,

        MONTH(Batch_Date) AS production_month,

        COUNT(*) AS batch_count,

        SUM(
            CASE
                WHEN Batch_Status = 'Failed' THEN 1
                ELSE 0
            END
        ) AS failed_batches,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN Batch_Status = 'Failed' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS failure_rate_pct

    FROM [Cleaned Data]

    GROUP BY
        YEAR(Batch_Date),

        MONTH(Batch_Date)
)

SELECT
    production_year,
    production_month,
    batch_count,
    failed_batches,
    failure_rate_pct,

    ROUND(
        AVG(failure_rate_pct) OVER (
            ORDER BY production_year, production_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_3_month_failure_rate

FROM MonthlyPerformance

ORDER BY
    production_year,
    production_month;

/*
============================================================================================================================
============================================================================================================================
12. INVESTIGATION OF FAILURE-RATE SPIKES 
============================================================================================================================
============================================================================================================================
*/

/* Were the high failure months driven disproportionately by Line 3? */

SELECT
	Year(Batch_Date) AS production_year,

	Month(Batch_Date) AS production_month,
    
    Manufacturing_Line,

    COUNT(*) AS batch_count,

	SUM(
		CASE
			WHEN Batch_Status = 'Failed' THEN 1
			ELSE 0
		END
		) AS failed_batches,

	ROUND(
		100 * SUM(
			CASE
				WHEN Batch_Status = 'Failed' THEN 1
				ELSE 0
			END
		) / COUNT(*) , 2
		) AS failure_rate_pct

FROM [Cleaned Data]

GROUP BY
	YEAR(Batch_Date),
	MONTH(Batch_Date),
	Manufacturing_Line

ORDER BY
	production_month,
	production_year;

/*
============================================================================================================================
============================================================================================================================
END OF ANALYSIS
============================================================================================================================
============================================================================================================================
*/