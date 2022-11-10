# Factors Affecting Mental Health

One of the most prevalent medical problems in the US is mental illness.  Mental health includes all aspects of physical, psychological, emotional, and social wellbeing. It influences our thoughts, emotions, and behaviors. It also affects the ability to handle stress, interact with people, and make good decisions. Both mental and physical health are crucial aspects of overall health. For instance, depression raises the chance of developing a wide range of physical health issues, especially chronic diseases like diabetes, heart disease, and stroke. Similarly, having chronic illnesses raises the likelihood of developing a mental disease. 

This analysis assesses the factors contributing to mental health in the US population.  The data was sourced from CDC’s Behavioral Risk Factor Surveillance System (BRFSS), the world’s largest, ongoing telephonic health survey system that monitors health-related risk behaviors, chronic health conditions, and preventive services across the United States. This data consists of 450k records and 303 features, which are survey questions that gather information on perceived health status (physical and mental health), demographics, economic and social factors, and other health behaviors (smoking, drinking, physical activity).  The analysis starts with exploratory data analysis, handling missing values, feature engineering, and reducing the number of features to 39 by performing calculations and combining features to enable complete analysis. Statistical models (Poisson, Quasi Poisson, and negative binomial) were used to estimate the effects of explanatory variables on the number of bad mental health days. The study shows a significant relationship between poor mental health days and general health, difficulty concentrating, age, exercise, and cigarette smoking.

The findings of this study may provide public health officials and populations at risk for mental health with information about the factors contributing to mental illness which will aid them in planning, developing, implementing, and assessing control strategies.

## 1.	Data Source and Preparation 

The Behavioral Risk Factor Surveillance System (BRFSS) is a telephone survey administered in all 50 states, the District of Columbia, Puerto Rico, the US Virgin Islands, and Guam with funding and specifications from the Centers for Disease Control and Prevention (CDC). The BRFSS monitors the prevalence of behavioral risks for the leading causes of disease and death among adults in the United States. 
The dataset for the year 2021 is used in this study. This data consists of 450k records and 303 features, which are essentially survey questions that gather information on perceived health status (physical and mental health), demographics, economic and social factors, and other health behaviors (smoking, drinking, physical activity).

[2021 BRFSS Data (ASCII)](https://www.cdc.gov/brfss/annual_data/2021/files/LLCP2021ASC.zip) - Survey data for the year 2021

[2021 BRFSS Overview CDC](https://www.cdc.gov/brfss/annual_data/2021/pdf/codebook21_llcp-v2-508.pdf) - Data Dictionary

**Data Cleaning:**
<br>
Performed data cleaning in python
<br>
- Considered only the records where mental health was reported
- Removed fields that had more than 70% of the missing data
- For the selected features, rows where the response was missing or refused or don’t know were dropped as it biases the data if any assumption was made about it
- Dropped variables that were calculated from existing fields
- Dropped fields related to interview conditions like interview month, interview day, interview year
- Derived state names from state fips code
<br>
After data cleaning and feature engineering, the final dataset had 39 columns and 57999 rows.


## 2. Predictor Table

After data cleaning and feature engineering we have the following variables and the predictor table of the variables is below

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/predictor_table.png" alt="predictor table" width="80%" height="80%">

## 3. Exploratory Data Analysis

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/histogram_bad_mental_health_days.png" alt="histogram of DV" width="50%" height="50%">

Our dependent variable is bad_mental_health_days. We can observe that the histogram of bad mental health days is right skewed (poisson type) with some peaks at specific intervals. 

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/general_health_box_plot.png" alt="general_health box plot" width="50%" height="50%">

People with poor general health tend to experience more mental illness probably because poor general health condition usually refers to people suffering from any kind of disease or illness.

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/race_box_plot.png" alt="race box plot" width="50%" height="50%">

American Indians and other races have more mental illness days when comparing different races.

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/sex_box_plot.png" alt="sex box plot" width="50%" height="50%">

Females suffer more from mental illness than males as they tend to have more hormonal imbalances.

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/exercise_box_plot.png" alt="exercise box plot" width="50%" height="50%">

It is apparent that exercise improves physical and mental health hence people without exercise have a significant difference in average bad mental health days.


<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/state_box_plot.png" alt="state box plot" width="75%" height="75%">

Alabama, West Virginia, and Arkansas are the top 3 states with the highest average bad mental health days when compared to other states. 

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/correlation_plot.png" alt="correlation plot" width="75%" height="75%">

It is important to check the multicollinearity of the numeric variables as they potentially skew the model outputs. We see that the highest correlation is between height and weight which is inherent. As any of the correlations is not near or beyond 0.7 there shouldn’t be any multicollinearity problem and skewed model outputs.


## 4. Statistical Models

The dependent variable obesity rate has a right skewed distribution and its count data (number of days a person reported sick in the last 30 days) so Poisson models are the appropriate ones to use. Initially Poisson model was used and to overcome the overdispersion problem Quasi Poisson and Negative Binomial models were employed. It was apparent that the negative binomial model performed the best among the three models. 

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/models.png" alt="models" width="80%" height="80%">


## 5. Quality Checks

**Dispersion test for poisson model:**
As poisson regressions are prone over dispersion we conducted dispersion test for poisson model

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/dispersion_test.png" alt="dispersion_test" width="50%" height="50%">

As the dispersion value is 4.81 there is evidence of overdispersion. <br>

**Durbin Watson test for negative binomial model:**

DW test value for negative binomial model is 2.0032 indicates there is no auto correlation between the residuals.

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/dwtest.png" alt="dw_test" width="50%" height="50%">

**VIF test for negative binomial model:**

GVIF test values for negative binomial model are less than 5 indicating that Independence assumption is satisfied.

<img src="https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/vif_output.png" alt="vif_test" width="50%" height="50%">

## 6. Insights

From the beta coefficients of negative binomial model, 

- Wyoming, Alabama, and West Virginia are the top 3 states and South Dakota, Illinois and Alaska are the least 3 states with bad mental health days.
- Adults with good general health tend to be 11.4 % (~ 3.3 days) less mentally ill than adults with bad general health condition. 
- Adults who are physically active i.e., exercise regularly reported 11.6% (~3.4 days) less bad mental health days. 
- Cigarette smoking and e-cigarette smoking increase bad mental health days by 8.7% (~2.5 days) and 11.5 % (~ 3.3 days) respectively. 
- Females are more mentally ill (9.8%) than men. Higher levels of education add 4.6 days additional mental illness days to an individual

## 7. Recommendations

- The states of Wyoming, Alabama, and West Virginia should design better healthcare benefits like affordable insurance for their residents as the affordability to see a therapist has a greater impact on the reduction of mental illnesses
- Create awareness of the benefits of exercise and maintaining good general health conditions
- Adults should consider quitting smoking or binge drinking as it can improve their mental health
- Colleges and high schools can establish and promote the campus health and wellness centers or set up counseling services 

## 8. Stargazer Models Output

https://github.com/skbusf/Factors-Affecting-Mental-Health/blob/main/visualizations/output.jpg