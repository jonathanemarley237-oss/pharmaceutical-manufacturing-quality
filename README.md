PHARMACEUTICAL MANUFACTURING QUALITY ANALYTICS

-------------------------------------------------------------------------------------------------------
1. PROJECT OVERVIEW

This project analyses historical pharmaceutical manufacturing batch data to identify patterns associated with batch failures, process deviations, yield performance and production efficiency.

The project follows an end-to-end data analytics workflow using Excel, SQL Server, Python and Power BI, progressing from data cleaning and validation through exploratory and statistical analysis to an interactive management dashboard.

The objective is not to establish the root causes of manufacturing failures, but to identify patterns and associations that can support the prioritisation of further investigation and process improvement activities.

«Dataset disclaimer: This project uses a synthetic dataset created for educational and portfolio purposes. It does not contain real manufacturer data, represent real pharmaceutical products or validated manufacturing processes, and the relationships identified should not be interpreted as real pharmaceutical process relationships or causal evidence.»

-------------------------------------------------------------------------------------------------------
2. EXECUTIVE SUMMARY

Analysis of 3,000 manufacturing batches identified several areas warranting further investigation. The GLP-1 Agonist product showed the weakest overall product KPI profile, while Manufacturing Line 3 recorded the highest observed failure rate and longest average production time.

Yield showed the clearest association with batch performance: the observed failure rate declined from 6.27% in the lowest-yield quartile to 1.60% in the highest, and failed batches had significantly lower mean yield overall (Welch's t-test, p < 0.001).

Recorded deviations were also associated with elevated failure rates (10.1% with a deviation vs. 2.84% without), although the overall association was weak and most failed batches occurred without a recorded deviation. Process deviations represented the largest deviation category and the greatest number of associated failed batches.

Based on these findings, further investigation should prioritise Line 3 performance, GLP-1 manufacturing performance, lower-yield batches and Process deviations, while recognising that the observed relationships are associative and do not establish root causes. 

-------------------------------------------------------------------------------------------------------
3. BUSINESS PROBLEM

A pharmaceutical manufacturing site has observed variability in batch performance and wants to better understand the factors associated with batch failures and production inefficiencies.

The analysis was designed to address the following questions:

- Which products have the highest observed batch failure rates?
- Are manufacturing problems concentrated on particular production lines?
- Which types of deviations occur most frequently and how are they associated with batch failure?
- Are there meaningful trends in failure and deviation rates over time?
- Which process or performance variables are most strongly associated with failed batches?
- Which areas should management prioritise for further investigation?

-------------------------------------------------------------------------------------------------------

4. DATASET

The cleaned dataset contains 3,000 manufacturing batches covering January 2024 to December 2025.

The data includes:

- Product and manufacturing line
- Batch date and operator team
- Temperature and humidity
- Mixing speed and mixing time
- Production time
- API assay
- pH and viscosity
- Dissolution performance
- Batch yield
- Pass/fail batch status
- Deviation status, type and severity

The raw synthetic dataset also contains intentional data-quality issues, including duplicate records, missing measurements, categorical inconsistencies and statistical outliers, allowing the project to demonstrate a realistic cleaning and validation workflow.

-------------------------------------------------------------------------------------------------------

5. TOOLS & TECHNOLOGIES

Microsoft Excel

- Initial data inspection and cleaning
- Duplicate removal and categorical standardisation
- Missing-value and outlier review
- Pivot-table analysis
- KPI validation
- Cleaning log documentation

SQL Server

- Data validation
- KPI calculation
- Product and manufacturing-line segmentation
- Product × line analysis
- Window functions and rankings
- Deviation analysis
- Monthly trend analysis
- Three-month rolling failure rates
- Investigation of higher-failure periods

Python

- pandas and NumPy for data manipulation
- Matplotlib for exploratory visualisation
- SciPy for statistical testing
- Distribution and outlier analysis
- Correlation analysis
- Standardised Pass/Failed comparisons
- Welch's independent-samples t-tests
- Chi-square testing and effect-size assessment
- Stratified product and manufacturing-line analysis

Power BI

- Data modelling and date-table creation
- DAX measures and calculated columns
- Interactive KPI reporting
- Product and manufacturing-line analysis
- Failure and deviation analysis
- Process-performance reporting
- Synced slicers, tooltips and page navigation

-------------------------------------------------------------------------------------------------------

6. ANALYTICAL WORKFLOW

The project follows a staged analytical workflow:

Raw Data → Excel Cleaning & Validation → SQL Analysis → Python Statistical Analysis → Power BI Reporting → Management Recommendations

Each stage was used for a different analytical purpose rather than reproducing the same analysis in multiple tools.

(1). Excel — Data Cleaning & Initial Exploration

The raw dataset was reviewed for data-quality issues before analysis.

Key activities included:

- Removal of exact duplicate records
- Standardisation of product, manufacturing-line and operator-team categories
- Review of missing process measurements
- Investigation of statistical outliers
- Validation of dates and categorical fields
- Creation and validation of core manufacturing KPIs

Missing measurements were retained as null values rather than automatically imputed or deleted. Statistical outliers were also retained where there was insufficient evidence that they represented data-entry or measurement errors.

(2). SQL — Structured Manufacturing Analysis

SQL was used to investigate manufacturing performance across products, manufacturing lines, deviations and time.

Analysis included:

- Overall and annual KPIs
- Product failure and deviation rates
- Manufacturing-line performance
- Product × manufacturing-line interactions
- Product rankings within manufacturing lines
- Deviation type and severity
- Manufacturing line × deviation type analysis
- Monthly failure and deviation trends
- Three-month rolling failure rates
- Manufacturing-line behaviour during higher-failure months

(3). Python — Statistical & Exploratory Analysis

Python was used to extend the analysis beyond KPI reporting and investigate distributions, relationships and statistical evidence.

Key techniques included:

- Numerical profiling and IQR-based outlier detection
- Distribution comparisons by product, line and batch status
- Pearson correlation analysis
- Stratified correlation analysis
- Standardised mean differences
- Welch's independent-samples t-tests
- Chi-square tests of independence
- Phi effect size
- Yield-quartile analysis

This stage was particularly important for distinguishing visually apparent differences from relationships supported by stronger statistical evidence.

(4). Power BI — Interactive Management Dashboard

The final Power BI report contains three pages:

1. Executive Overview — headline KPIs, product and manufacturing-line failure rates, and monthly performance.
2. Failure & Deviation Analysis — deviation-related failure patterns, deviation categories and manufacturing context.
3. Process Performance Analysis — yield, production time and their relationships with batch performance.

Year, Product and Manufacturing Line slicers are synchronised across the report to allow users to explore different manufacturing contexts.

-------------------------------------------------------------------------------------------------------

7. POWER BI DASHBOARD

### Executive Overview

!["Executive Overview"](7.%20images/executive_overview.png)

### Failure & Deviation Analysis

!["Failure & Deviation Analysis"](7.%20images/failure_deviation_analysis.png)

### Process Performance Analysis

!["Process Performance Analysis"](7.%20images/process_performance.png)

-------------------------------------------------------------------------------------------------------

8. KEY FINDINGS

(1) Product Performance

GLP-1 Agonist showed the weakest overall product KPI profile, recording the highest observed failure rate, highest deviation rate, lowest average yield and longest average production time.

However, deviation rates were relatively comparable across products, indicating that deviation frequency alone does not explain the elevated GLP-1 failure rate.

(2) Manufacturing-Line Performance

Line 3 recorded the highest observed batch failure rate and longest average production time, while Line 1 showed the strongest overall KPI profile.

Line 2 and Line 3 had similar deviation rates despite materially different failure rates. This suggests that recorded deviation frequency alone does not account for Line 3's elevated failure rate.

Product × line analysis also showed that elevated failure performance was not attributable solely to product mix.

(3) Yield & Batch Failure

Yield showed the clearest association with batch status among the variables examined.

Failed batches had significantly lower mean yield overall (Welch's t-test, p < 0.001), with a standardised difference of approximately 0.46 standard deviations.

A graded relationship was also observed across yield quartiles:

- Lowest-yield quartile: 6.27% failure rate
- Q2: 3.42%
- Q3: 2.16%
- Highest-yield quartile: 1.60%

The lowest-yield quartile therefore recorded approximately 3.9 times the observed failure rate of the highest-yield quartile.

This relationship identifies yield as an important batch-performance indicator but does not establish lower yield as the cause of batch failure.

(4) Deviations & Batch Failure

Batches with a recorded deviation had an observed failure rate of 10.1%, compared with 2.84% for batches without a deviation.

The relationship between deviation status and batch status was statistically significant:

χ²(1) = 30.765, p < 0.0001

However, the association strength was weak:

φ = 0.101

Most failed batches also occurred without a recorded deviation, demonstrating that deviation status is a useful indicator of elevated failure risk but is not a complete explanation for batch failure.

(5) Deviation Type

Process deviations represented the largest deviation category and the greatest number of associated failed batches.

Process deviations occurred across all three manufacturing lines rather than being concentrated on Line 3. This indicates that Process deviations should be considered both as a broader manufacturing issue and within line-specific investigations.

(6) Temporal Performance

Monthly failure and deviation rates fluctuated throughout 2024–2025, with no clear sustained upward or downward trend.

Although individual peaks occasionally coincided, failure and deviation rates did not move consistently together over time, providing further evidence that deviation frequency alone does not explain variation in batch failures.

-------------------------------------------------------------------------------------------------------

9. RECOMMENDATIONS

Based on the observed patterns, the following areas warrant further investigation:

- Line 3 performance: investigate factors associated with its elevated failure rate and longer average production time.
- GLP-1 Agonist manufacturing performance: investigate why elevated failure rates and lower average yield persist across manufacturing contexts.
- Lower-yield batches: investigate process characteristics associated with declining yield while recognising that yield may be an indicator rather than an underlying causal driver.
- Process deviations: prioritise review based on their combined frequency, number of associated failures and observed failure rate.
- Failures without recorded deviations: investigate additional factors because most failed batches were not accompanied by a recorded deviation.

These recommendations identify areas for root-cause investigation rather than prescriptive corrective actions, because the observational analysis does not establish causal relationships.

-------------------------------------------------------------------------------------------------------

10. LIMITATIONS

Several limitations should be considered when interpreting the results:

- The dataset is synthetic and does not represent a real pharmaceutical manufacturer or validated manufacturing process.
- The analysis is observational and therefore identifies associations rather than causal relationships.
- Statistical significance does not necessarily imply operational significance.
- Some subgroup analyses contain relatively small numbers of failed batches and should be interpreted cautiously.
- Recorded deviations do not capture every factor that may influence manufacturing performance.
- Formal pharmaceutical process specifications were not provided, so statistical outliers should not be interpreted automatically as specification failures or process excursions.
- Variables such as equipment downtime, maintenance history, raw-material lot characteristics and detailed process-stage information were not available.

-------------------------------------------------------------------------------------------------------

11. REPOSITORY STRUCTURE

pharmaceutical_manufacturing_quality/
README.md

2. Data/
    - cleaned/
        pharma_manufacturing_cleaned.csv
    - raw/
        pharma_manufacturing_raw.csv

3. Excel/
    - pharma_manufacturing_dataset.xlsx

4. SQL/
    - pharmaceutical_manufacturing_analysis.sql

5. Python/
    - pharmaceutical_manufacturing_analysis.ipynb

6. PowerBI/
    - pharmaceutical_manufacturing_quality_dashboard.pbix

7. Images/
    - executive_overview.png
    - failure_deviation_analysis.png
    - process_performance.png

-------------------------------------------------------------------------------------------------------

12. PROJECT OUTCOME

This project demonstrates an end-to-end analytical workflow combining data cleaning, SQL querying, exploratory data analysis, statistical testing, data modelling, DAX and interactive dashboard development.

The analysis progresses from identifying manufacturing performance patterns to testing whether those patterns persist across products, manufacturing lines and other operating contexts. The final dashboard translates the technical analysis into an interactive format designed to support management investigation and prioritisation. 