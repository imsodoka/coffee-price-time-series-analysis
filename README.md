# Coffee Price Time-Series Analysis (2011–2016)

**An applied time-series analysis of monthly coffee prices using Stata.**

## 1. Project Overview

This project examines the behaviour of monthly coffee prices over the period **2011–2016**, applying time-series techniques to identify underlying trends, seasonal patterns and cyclical movements.

The analysis demonstrates the application of time-series methods in understanding price dynamics and extracting meaningful information from historical market data.

## 2. Objectives

The analysis aims to:

- Examine the overall trend in monthly coffee prices.
- Estimate seasonal indices using alternative methodologies.
- Compare seasonal patterns obtained from different estimation methods.
- Deseasonalize the original price series.
- Separate trend-cycle and irregular components.
- Explore cyclical movements using moving averages and autocorrelation.

## 3. Dataset Description

| Attribute | Description |
|---|---|
| Commodity | Coffee |
| Frequency | Monthly |
| Period | 2011–2016 |
| Number of observations | 72 |
| Main variable | Coffee price |
| Software | Stata/SE 17.0 |

*Note: The original Excel dataset is not included in this repository. The analysis uses a locally stored Excel workbook.*

## 4. Methodology

The analysis follows a structured time-series workflow:

### 4.1 Data Preparation
- Importing the original Excel dataset into Stata.
- Renaming variables and restructuring the dataset from wide to long format.
- Generating a monthly time index.
- Declaring the time-series structure using `tsset`.

### 4.2 Trend Estimation
A linear regression model is estimated to examine the general direction of coffee prices over time. Predicted values are used to illustrate the underlying trend.

### 4.3 Seasonal Index Estimation

Three approaches are applied:

1. **Ratio-to-Trend Method** – compares observed prices with estimated trend values.
2. **Average Percentage Method** – compares monthly prices with their respective annual averages.
3. **Ratio-to-Moving-Average Method** – uses moving averages to estimate seasonal variation.

Seasonal indices are adjusted to ensure that their average is consistent with the expected annual seasonal total of 1,200.

### 4.4 Deseasonalization
The average percentage seasonal indices are used to remove seasonal effects from the original price series.

### 4.5 Trend-Cycle and Irregular Components
Moving averages are applied to the deseasonalized series to examine underlying movements and isolate irregular fluctuations.

### 4.6 Cycle Analysis
A seven-month moving average and autocorrelation analysis are used to explore cyclical patterns in the series.

## 5. Tools and Stata Commands

**Software:** Stata/SE 17.0

Key commands used include:

- `import excel`
- `reshape`
- `gen` and `replace`
- `encode`
- `tsset`
- `regress`
- `predict`
- `egen`
- `tssmooth ma`
- `twoway`
- `ac`

## 6. Repository Structure

```text
coffee-price-time-series-analysis/
│
├── README.md
│
└── Visualization of time series of prices.do
```

## 7. How to Run the Analysis

1. Download or clone this repository.
2. Open the `.do` file in Stata.
3. Obtain the original Excel dataset.
4. Update the Excel file path in the import command to match your local directory.
5. Update the log-file directory to a location where you have write permissions.
6. Execute the do-file in Stata.

**Important:** The original Excel workbook is not included. The file paths in the do-file must be adjusted before execution.

## 8. Analytical Scope and Limitations

This project is an applied time-series exercise using historical monthly coffee prices. The analysis focuses on descriptive decomposition and identification of trend, seasonal and cyclical patterns.

The findings should therefore be interpreted within the context of the selected period and dataset. They should not automatically be treated as evidence of causal relationships or as forecasts of future coffee prices.

## 9. Author

**Issah Msodoka**  
Agricultural Economist | Researcher | Data Analyst

Research interests:
- Agricultural and commodity markets
- Applied econometrics
- Time-series analysis
- Agricultural economics
- Data analytics and evidence-based decision-making

**Software:** Stata/SE 17.0

---

*Turning Data into Evidence. Driving Better Decisions.*
