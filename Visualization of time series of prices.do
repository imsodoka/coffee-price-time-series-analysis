
********************************************************************************
*                                                                              *
*                 AMSODO RESEARCH & DATA ANALYTICS                            *
*                    RESEARCH. DATA. INSIGHTS. IMPACT.                        *
*                                                                              *
********************************************************************************
*
* PROJECT TITLE : Coffee Price Time Series Analysis
* PROJECT TYPE  : Time Series Analysis
* AUTHOR        : Issah Msodoka
* INSTITUTION   : Lilongwe University of Agriculture and Natural Resources
* COURSE        : Market and Price Analysis
* DATE          : 29 January 2026
*
* -------------------------------------------------------------------------------
* PROJECT DESCRIPTION
* -------------------------------------------------------------------------------
* This do-file analyses monthly coffee prices from 2011 to 2016.
*
* The analysis covers:
*   1. Data cleaning and time-series preparation
*   2. Linear trend estimation
*   3. Seasonal index estimation using the ratio-to-trend method
*   4. Seasonal index estimation using the average percentage method
*   5. Seasonal index estimation using the ratio-to-moving-average method
*   6. Deseasonalization of the price series
*   7. Trend-cycle and irregular component estimation
*   8. Cycle analysis and autocorrelation
*   9. Comparison of seasonal indices
*
* SOFTWARE      : Stata
* -------------------------------------------------------------------------------

*===============================================================================
* 0. INITIALIZATION AND DATA IMPORT
*===============================================================================

* Start analysis log
capture log close
log using "D:\Desktop\ISSA MODELLING\Issa_Msodoka_AAE324_Run2.log", replace text

* Import coffee price dataset
import excel ///
    "D:\Desktop\MZIMU UPITE!\Year 3 sem 2\Market and Price analysis\Analysis of time series of prices Class Example 2023.xlsx", ///
    sheet("Question 1") cellrange(A16:G28) firstrow


*===============================================================================
* 1. DATA CLEANING AND TIME-SERIES PREPARATION
*===============================================================================

*-------------------------------------------------------------------------------
* 1.1 Rename annual price variables
*-------------------------------------------------------------------------------

rename B year2011
rename C year2012
rename D year2013
rename E year2014
rename F year2015
rename G year2016

*-------------------------------------------------------------------------------
* 1.2 Reshape data from wide to long format
*-------------------------------------------------------------------------------

reshape long year, i(Month) j(Year)
rename year price

*-------------------------------------------------------------------------------
* 1.3 Generate monthly time index (t = 1,...,72)
*-------------------------------------------------------------------------------

gen t = .

replace t = (Year-2011)*12 + 1  if Month == "Jan"
replace t = (Year-2011)*12 + 2  if Month == "Feb"
replace t = (Year-2011)*12 + 3  if Month == "Mar"
replace t = (Year-2011)*12 + 4  if Month == "Apr"
replace t = (Year-2011)*12 + 5  if Month == "May"
replace t = (Year-2011)*12 + 6  if Month == "Jun"
replace t = (Year-2011)*12 + 7  if Month == "Jul"
replace t = (Year-2011)*12 + 8  if Month == "Aug"
replace t = (Year-2011)*12 + 9  if Month == "Sep"
replace t = (Year-2011)*12 + 10 if Month == "Oct"
replace t = (Year-2011)*12 + 11 if Month == "Nov"
replace t = (Year-2011)*12 + 12 if Month == "Dec"

*-------------------------------------------------------------------------------
* 1.4 Generate numeric month identifier
*-------------------------------------------------------------------------------

encode Month, gen(month_num)

*-------------------------------------------------------------------------------
* 1.5 Declare time-series structure
*-------------------------------------------------------------------------------

drop Year
sort t
tsset t

*-------------------------------------------------------------------------------
* 1.6 Apply variable labels
*-------------------------------------------------------------------------------

label variable t        "Time Period"
label variable price    "Coffee Price"
label variable month_num "Month Number"

*-------------------------------------------------------------------------------
* 1.7 Verify prepared dataset
*-------------------------------------------------------------------------------

list t Month month_num price in 1/12


*===============================================================================
* 2. LINEAR TREND ESTIMATION
*===============================================================================

* Estimate linear time trend
regress price t

* Generate predicted trend values
predict trend, xb

* Visualize actual prices against estimated trend
twoway ///
    (line price t) ///
    (line trend t), ///
    title("Coffee Price Trend") ///
    legend(label(1 "Actual Price") label(2 "Trend"))


*===============================================================================
* 3. SEASONAL INDEX: RATIO-TO-TREND METHOD
*===============================================================================

* Calculate price-to-trend ratios
gen si_rt = price / trend

* Estimate monthly mean and median seasonal ratios
bysort month_num: egen mean_si_rt   = mean(si_rt)
bysort month_num: egen median_si_rt = median(si_rt)

* Adjust seasonal indices to sum to 1200
sum mean_si_rt, meanonly
gen adj_mean_si_rt = mean_si_rt * (1200 / r(sum))

* Display estimated seasonal indices
list month_num mean_si_rt median_si_rt adj_mean_si_rt in 1/12, ///
    sepby(month_num)


*===============================================================================
* 4. SEASONAL INDEX: AVERAGE PERCENTAGE METHOD
*===============================================================================

*-------------------------------------------------------------------------------
* 4.1 Calculate annual average prices
*-------------------------------------------------------------------------------

gen year = ceil(t/12)
bysort year: egen annual_mean = mean(price)

*-------------------------------------------------------------------------------
* 4.2 Calculate seasonal price ratios
*-------------------------------------------------------------------------------

gen si_avgpct = price / annual_mean
bysort month_num: egen mean_si_avg = mean(si_avgpct)

*-------------------------------------------------------------------------------
* 4.3 Adjust seasonal indices
*-------------------------------------------------------------------------------

sum mean_si_avg, meanonly
gen adj_mean_si_avg = mean_si_avg * (1200 / r(sum))

* Display adjusted seasonal indices
list month_num mean_si_avg adj_mean_si_avg in 1/12, ///
    sepby(month_num)


*===============================================================================
* 5. SEASONAL INDEX: RATIO-TO-MOVING-AVERAGE METHOD
*===============================================================================

*-------------------------------------------------------------------------------
* 5.1 Calculate 12-month moving average
*-------------------------------------------------------------------------------

tssmooth ma ma12 = price, window(12) replace

*-------------------------------------------------------------------------------
* 5.2 Calculate seasonal ratios
*-------------------------------------------------------------------------------

gen si_ma = price / ma12 if !missing(ma12)

* Estimate monthly mean and median seasonal ratios
bysort month_num: egen mean_si_ma   = mean(si_ma)
bysort month_num: egen median_si_ma = median(si_ma)

* Adjust mean seasonal indices
sum mean_si_ma, meanonly
gen adj_mean_si_ma = mean_si_ma * (1200 / r(sum))

*-------------------------------------------------------------------------------
* 5.3 Compare mean and median seasonal indices
*-------------------------------------------------------------------------------

twoway ///
    (bar adj_mean_si_ma month_num, yaxis(1)) ///
    (bar median_si_ma month_num, yaxis(2)), ///
    title("Mean vs Median Seasonal Indices (MA Method)") ///
    legend(off)


*===============================================================================
* 6. DESEASONALIZATION
*===============================================================================

* Deseasonalize prices using average percentage seasonal indices
gen deseas = price / mean_si_avg

* Visualize deseasonalized coffee price series
twoway line deseas t, ///
    title("Deseasonalized Coffee Price Series") ///
    ytitle("Deseasonalized Price")


*===============================================================================
* 7. TREND-CYCLE AND IRREGULAR COMPONENTS
*===============================================================================

*-------------------------------------------------------------------------------
* 7.1 Estimate trend-cycle component using a 3-month moving average
*-------------------------------------------------------------------------------

tssmooth ma maci3 = deseas, window(3) replace

*-------------------------------------------------------------------------------
* 7.2 Extract irregular component
*-------------------------------------------------------------------------------

gen irregular = deseas / maci3

* Compare deseasonalized series with trend-cycle component
twoway ///
    (line deseas t) ///
    (line maci3 t), ///
    title("Trend-Cycle vs Deseasonalized Series") ///
    legend(label(1 "Deseasonalized") label(2 "MACI-3"))


*===============================================================================
* 8. CYCLE ANALYSIS
*===============================================================================

*-------------------------------------------------------------------------------
* 8.1 Estimate cycle component using a 7-month moving average
*-------------------------------------------------------------------------------

tssmooth ma maci7 = irregular, window(7) replace

* Visualize estimated cycle component
twoway line maci7 t, ///
    title("Cycle Estimation: 7-Month Moving Average")

*-------------------------------------------------------------------------------
* 8.2 Autocorrelation analysis for cycle detection
*-------------------------------------------------------------------------------

ac maci7, lags(20)


*===============================================================================
* 9. SUMMARY: SEASONAL INDICES COMPARISON
*===============================================================================

* Preserve the original dataset
preserve

* Retain January observations
keep if mod(t,12) == 1

* Retain seasonal index variables for comparison
keep month_num mean_si_rt adj_mean_si_avg adj_mean_si_ma

* Display comparison table
list, sepby(month_num) noobs clean

* Restore original dataset
restore


*===============================================================================
* 10. END OF ANALYSIS
*===============================================================================

* Close analysis log
log close

********************************************************************************
*                                                                              *
*                         END OF DO-FILE                                      *
*                                                                              *
*                 AMSODO RESEARCH & DATA ANALYTICS                            *
*                    RESEARCH. DATA. INSIGHTS. IMPACT.                        *
*                                                                              *
********************************************************************************
