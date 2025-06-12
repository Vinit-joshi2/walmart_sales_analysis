# Walmart Data Analysis: SQL + Python 

## Project Overview

![Project Pipeline](https://github.com/Vinit-joshi2/walmart_sales_analysis/blob/main/walmart_project-piplelines.png)


This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. We utilize Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. The project is ideal for data analysts looking to develop skills in data manipulation, SQL querying, and data pipeline creation.

---

## Project Steps

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, SQL (PostgreSQL)
   - **Goal**: Create a structured workspace within VS Code and organize project folders for smooth development and data handling.

### 2. Set Up Kaggle API
   - **API Setup**: Obtain your Kaggle API token from [Kaggle](https://www.kaggle.com/) by navigating to your profile settings and downloading the JSON file.
   - **Configure Kaggle**: 
      - Place the downloaded `kaggle.json` file in your local `.kaggle` folder.
      - Use the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into your project.

### 3. Download Walmart Sales Data
   - **Data Source**: Use the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://github.com/Vinit-joshi2/walmart_sales_analysis/blob/main/Walmart.csv)
   - **Storage**: Save the data in the `data/` folder for easy reference and access.

### 4. Install Required Libraries and Load Data
   - **Libraries**: Install necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python psycopg2
     ```
   - **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Explore the Data
   - **Goal**: Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
   - **Analysis**: Use functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Remove Duplicates**: Identify and remove duplicate entries to avoid skewed results.
   - **Handle Missing Values**: Drop rows or columns with missing values if they are insignificant; fill values where essential.
   - **Fix Data Types**: Ensure all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Use `.replace()` to handle and format currency values for analysis.
   - **Validation**: Check for any remaining inconsistencies and verify the cleaned data.

### 7. Feature Engineering
   - **Create New Columns**: Calculate the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
   - **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into MySQL and PostgreSQL
   - **Set Up Connections**: Connect to  PostgreSQL using `sqlalchemy` and load the cleaned data into each database.
   - **Table Creation**: Set up tables in  PostgreSQL using Python SQLAlchemy to automate table creation and data insertion.
   - **Verification**: Run initial SQL queries to confirm that the data has been loaded accurately.

### 9. SQL Analysis: Complex Queries and Business Problem Solving
   - **Business Problem-Solving**: Write and execute complex SQL queries to answer critical business questions, such as:
     - Revenue trends across branches and categories.
     - Identifying best-selling product categories.
     - Sales performance by time, city, and payment method.
     - Analyzing peak sales periods and customer buying patterns.
     - Profit margin analysis by branch and category.
   

---

## Requirements

- **Python 3.8+**
- **SQL Databases**:  PostgreSQL
- **Python Libraries**:
  - `pandas`, `numpy`, `sqlalchemy`, `psycopg2`
- **Kaggle API Key** (for data downloading)

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repo-url>
   ```
2. Install Python libraries:
   ```bash
   pip install -r requirements.txt
   ```
3. Set up your Kaggle API, download the data, and follow the steps to load and analyze.

---

## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```
---

## Results and Insights

<h3> Q. 1
 Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
</h3>

```
select payment_method , sum(quantity) as quantity_sold from walmart_clean_data
group by 1

```
<img src = "https://github.com/Vinit-joshi2/walmart_sales_analysis/blob/main/patment_method.png">

- Credit Card is the most preferred payment method with 9,567 transactions, indicating strong customer trust in card-based payments.

- E-Wallet follows closely with 8,932 transactions, showing the growing adoption of digital payment solutions.

- Cash was used in only 4,984 transactions, suggesting that traditional payment methods are being phased out in favor of more convenient, cashless options.

<h3>  Q.2
 Calculate the total profit for each category by considering total_profit as
(unit_price * quantity * profit_margin). 
List category and total_profit, ordered from highest to lowest profit.

</h3>

```
select category , sum(total * profit_margin) as total_profit
from walmart_clean_data
group by 1
order by 1 , 2 desc
```

<img src = "https://github.com/Vinit-joshi2/walmart_sales_analysis/blob/main/category.png">

- Fashion Accessories and Home & Lifestyle are the top-performing categories, generating sales of $192,314.89 and $192,213.64 respectively. These two categories dominate the revenue landscape, indicating strong customer interest and demand.

- Sports and Travel ranks third with $20,613.81 in total sales, followed closely by Food and Beverages at $21,552.86, suggesting moderate performance in these categories.

- Electronic Accessories and Health & Beauty show relatively lower sales at $30,772.49 and $18,671.73, indicating potential areas for growth through targeted marketing or product bundling.



<h3>  Q.9 Identify 5 branch with highest decrese ratio in 
revevenue compare to last year(current year 2023 and last year 2022)
rdr == last_rev-cr_rev/ls_rev*100

</h3>

```
-- 2022 sales
with  revenue_2022
AS
(
	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart_clean_data
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022 -- psql
	-- WHERE YEAR(TO_DATE(date, 'DD/MM/YY')) = 2022 -- mysql
	GROUP BY 1
),

revenue_2023
AS
(

	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart_clean_data
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
	GROUP BY 1
)

SELECT 
	ls.branch,
	ls.revenue as last_year_revenue,
	cs.revenue as cr_year_revenue,
	ROUND(
		(ls.revenue - cs.revenue)::numeric/
		ls.revenue::numeric * 100, 
		2) as rev_dec_ratio
FROM revenue_2022 as ls
JOIN
revenue_2023 as cs
ON ls.branch = cs.branch
WHERE 
	ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5


```

<img src = "https://github.com/Vinit-joshi2/walmart_sales_analysis/blob/main/revenue_by_year.png">


<h4>   
A comparison of revenues across Walmart branches between 2022 and 2023 reveals a significant decline in earnings:
</h4>

| Branch  | 2022 Revenue | 2023 Revenue | Decrease (%)  |
| ------- | ------------ | ------------ | ------------- |
| WALM045 | 1,731        | 647          | **62.62%** ⬇️ |
| WALM047 | 2,581        | 1,069        | **58.58%** ⬇️ |
| WALM098 | 2,446        | 1,030        | **57.89%** ⬇️ |
| WALM033 | 2,099        | 931          | **55.65%** ⬇️ |
| WALM081 | 1,723        | 850          | **50.67%** ⬇️ |

- All listed branches experienced a revenue drop of over 50%, with WALM045 seeing the steepest decline of 62.62%.

- This sharp drop may be attributed to factors like reduced footfall, competition, stock issues, or pricing strategy mismatches.



---

## License

This project is licensed under the MIT License. 

---

## Acknowledgments

- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Walmart’s business case studies on sales and supply chain optimization.

---
