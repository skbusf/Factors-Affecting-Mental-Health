setwd("C:/Users/batch_2kjxgc7/Desktop/USF/Courses/SDM/Project/Coding/")
rm(list = ls())
library(readxl)
library(dplyr)
library(corrplot)
library(lme4)
library(MASS)
library(AER)
library(stargazer)
library(ggplot2)
library(lattice)
library(PerformanceAnalytics)

df = read_xlsx("dataset.xlsx")

colnames(df) = tolower(colnames(df))
colnames(df)

#------------------------------------------------------
# Visualizations
#------------------------------------------------------
# Box plots

# by state
ggplot(df, aes(x=state, y=bad_mental_health_days)) +  coord_flip()+
  geom_boxplot(fatten = NULL, fill="cyan", alpha=0.1) +
  ggtitle("Boxplot by State") +
  stat_summary(fun=mean, geom='point', size = 1.5) 

# by health condition
ggplot(df, aes(x=general_health, y=bad_mental_health_days)) +  coord_flip()+
  geom_boxplot(fatten = NULL, fill="cyan", alpha=0.1) +
  ggtitle("Boxplot by General Health Condition") +
  stat_summary(fun=mean, geom='point', size = 3)

#by race
ggplot(df, aes(x=race, y=bad_mental_health_days)) +  coord_flip()+
  geom_boxplot(fatten = NULL, fill="cyan", alpha=0.1) +
  ggtitle("Boxplot by Race") +
  stat_summary(fun=mean, geom='point', size = 3)

# by sex
ggplot(df, aes(x=sex, y=bad_mental_health_days)) +  coord_flip()+
  geom_boxplot(fatten = NULL, fill="cyan", alpha=0.1) +
  ggtitle("Boxplot by Sex") +
  stat_summary(fun=mean, geom='point', size = 3)

# by exercise
ggplot(df, aes(x=exercise, y=bad_mental_health_days)) +  coord_flip()+
  geom_boxplot(fatten = NULL, fill="cyan", alpha=0.1) +
  ggtitle("Boxplot by Exercise") +
  stat_summary(fun=mean, geom='point', size = 3)

# Histogram
ggplot(df, aes(x=bad_mental_health_days)) + 
  geom_histogram(color="darkblue", fill="cyan", alpha =0.25) +
  ggtitle("Histogram of Bad Mental Health days")

# Correlation plot
dtemp = df[c(3 , 14, 15, 18 )]
chart.Correlation(dtemp)


#------------------------------------------------------
# Converting to factor variables and releveling the data
#------------------------------------------------------
df$general_health = factor(df$general_health)
df$general_health = relevel(df$general_health, "poor")

df$routine_checkup = factor(df$routine_checkup)
df$routine_checkup = relevel(df$routine_checkup, "Never")

df$marital_status = factor(df$marital_status)
df$marital_status = relevel(df$marital_status, "Unmarried")

df$education_level = factor(df$education_level)
df$education_level = relevel(df$education_level, "Kindergarten school")

df$house = factor(df$house)
df$house = relevel(df$house, "Rent")

df$employment_status = factor(df$employment_status)
df$employment_status = relevel(df$employment_status, "Unemployed")

df$children = factor(df$children)
df$children = relevel(df$children, "None")

df$bmi = factor(df$bmi)
df$bmi = relevel(df$bmi, "NormalWeight")

df$smoking = factor(df$smoking)
df$smoking = relevel(df$smoking, "no")

df$income_level = factor(df$income_level)
df$income_level = relevel(df$income_level, "less than 25k")

df$race = factor(df$race)
df$race = relevel(df$race, "White")

df$age = factor(df$age)
df$age = relevel(df$age, "18-24")

df$diet = factor(df$diet)
df$diet = relevel(df$diet, "mixed diet")

str(df)
attach(df)

#------------------------------------------------------
# Models
#------------------------------------------------------
# Poisson model
poisson <- glm(bad_mental_health_days ~ state + general_health + routine_checkup + cholesterol + chronic_bronchitis + diabetes +
            marital_status + house + employment_status + height_inch + bmi + bad_physical_health_days + personal_health_care_provider + heart_diseases + income_level + difficulty_hearing + difficulty_concentrating + difficulty_doing_errands + 
            difficulty_seeing + county_type + age + diet + sex + exercise + asthma + kidney_disease + arthritis + education_level + 
            veteran + children + weight_kg + smoking + health_insurance + afford_to_see_doctor + cancer + flushot + race + binge_drinking , family = "poisson" (link=log), data = df)

summary(poisson)


# QuasiPoisson model to control over dispersion
quasipoisson <- glm(bad_mental_health_days ~ state + general_health + routine_checkup + cholesterol + chronic_bronchitis + diabetes +
            marital_status + house + employment_status + height_inch + bmi + bad_physical_health_days + personal_health_care_provider + heart_diseases + income_level + difficulty_hearing + difficulty_concentrating + difficulty_doing_errands + 
            difficulty_seeing + county_type + age + diet + sex + exercise + asthma + kidney_disease + arthritis + education_level + 
            veteran + children + weight_kg + smoking + health_insurance + afford_to_see_doctor + cancer + flushot + race + binge_drinking , family = "quasipoisson" (link=log), data = df)

summary(quasipoisson)

# NegativeBinomial Model to control overdispersion
negativeBinomial = glm.nb(bad_mental_health_days ~ state + general_health + routine_checkup + cholesterol + chronic_bronchitis + diabetes +
               marital_status + house + employment_status + height_inch + bmi + bad_physical_health_days + personal_health_care_provider + heart_diseases + income_level + difficulty_hearing + difficulty_concentrating + difficulty_doing_errands +
               difficulty_seeing + county_type + age + diet + sex + exercise + asthma + kidney_disease + arthritis + education_level +
               veteran + children + weight_kg + smoking + health_insurance + afford_to_see_doctor + cancer + flushot + race + binge_drinking , data = df)

summary(negativeBinomial)

#------------------------------------------------------
#Stargazer Output of the models
#------------------------------------------------------
stargazer(poisson, quasipoisson, negativeBinomial, single.row=TRUE, type="text")

#------------------------------------------------------
#Quality checks 
#------------------------------------------------------
# Dispersion Test for poisson model
dispersiontest(poisson)

# for Negative Binomial Models
# Durbin Watson test for autocorrelation
dwtest(negativeBinomial)

# VIF test for independence
vif(negativeBinomial)


