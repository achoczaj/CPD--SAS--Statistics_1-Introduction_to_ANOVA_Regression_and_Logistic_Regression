/*
 * Practice 1: Describe Relationships between Continuous Variables
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
The BodyFat data set records the percentage of body fat, age, weight, height, and ten body circumference measurements (for example, abdomen) for 252 men. Body fat, one measure of health, has been accurately estimated by an underwater weighing technique. The BodyFat data set contains two measures of percentage of body fat. Reminder: Make sure you've defined the Statdata library.
1. Use the UNIVARIATE procedure to examine the distribution of the variables PctBodyFat2, Age, Weight, Height and the circumference measures (Neck, Chest, Abdomen, Hip, Thigh, Knee, Ankle, Biceps, Forearm, and Wrist).
- What conclusions can you draw about the distribution of these variables?
- Do there appear to be any unusual observations?
- One observation was miscoded. 
Find an observation where the value of Height is less than 30 inches, 
then add 40 inches to the height. 
Create a new data set, rather than overwriting the old one. 
Make any other modifications you deem appropriate for other outliers.
2. Generate scatter plots and correlations for the VAR variables Age, Weight, Height and the circumference measures versus the WITH variable, PctBodyFat2.
Caution	Important! For PROC CORR, ODS Graphics limits you to 10 VAR variables at a time. For this exercise, look at the relationships with Age, Weight, and Height separately from those of the other variables. (With ODS Graphics disabled, you can create correlation tables using more than 10 VAR variables at a time.)
- Can straight lines adequately describe the relationships?
- Are there any outliers you should investigate?
- Which variable has the highest correlation with PctBodyFat2?
- What is the p-value for the coefficient?
- Is it statistically significant at the 0.05 level?

3. 
Generate 
a) a correlation table and scatter plot matrix 
for the VAR variables Age, Weight, Height, 
b) a correlation table for the circumference measures, and 
c) a correlation table and scatter plot matrix 
for the VAR variables with the circumference measures. 
Note: In the code for part c, omit the NVAR=ALL option 
to produce a partial scatter plot matrix. 
By default, NVAR=5 so the dimensions of the scatter plot matrix 
will be 3 by 5 instead of 3 by 10. 

- Are there any notable relationships?
*/

/* 1.*/
ods select histogram probplot;

proc univariate data=statdata.BodyFat;
   var PctBodyFat2 Age Weight Height
       Neck Chest Abdomen Hip Thigh
       Knee Ankle Biceps Forearm Wrist;
       histogram / normal (mu=est sigma=est);
   probplot / normal (mu=est sigma=est);
   inset skewness kurtosis;
   title "Predictors of % Body Fat";
run;
title;
/*
Weight, Height, and other measures seem to show high skewness and kurtosis. 
This might be due to a large outlier. 

One participant seems to be much heavier than the rest (> 300 pounds). 
Another — presumably not the same — seems to be abnormally short (about 30 inches). 


1.3 Recode the miscoded observationin new data set
*/
data statdata.BodyFat_corrected;
   set statdata.BodyFat;
   if Height=29.5 then Height=69.5;
run;
/*
The Weight outlier is not miscoded. 
As the investigator, you must decide whether or not to delete 
that observation. 
If you delete the observation, you should note this 
in all reports of analyses involving this data set. 
 */


/*2.*/
proc corr data=statdata.BodyFat_corrected rank
          plots(only)=scatter(nvar=all ellipse=none);
   /*specify the continuous predictor variables*/
   var Age Weight Height;
   /*specify the continuous response variable*/
   with PctBodyFat2;
   title "Correlations and Scatter Plots with Body Fat %";
run;

proc corr data=statdata.BodyFat_corrected rank
     plots(only)=scatter(nvar=all ellipse=none);
   var Neck Chest Abdomen Hip Thigh
       Knee Ankle Biceps Forearm Wrist;
   with PctBodyFat2;
   title "Correlations and Scatter Plots with Body Fat %";
run;

title;
/*
- Can straight lines adequately describe the relationships?
Height seems to be the only variable that shows no real linear relationship. 
Age and Ankle show little linear trend.

- Are there any outliers you should investigate?
The Weight outlier is present again, as well 
as Neck, Abdomen, Hip, Knee, and Biceps. 
There are two outliers for Ankle.

- Which variable has the highest correlation with PctBodyFat2?
Abdomen, with 0.81343 is the variable 
with the highest correlation with PctBodyFat2.

- What is the p-value for the coefficient?
The p-value for the coefficient of Abdomen is <.0001. 

- Is it statistically significant at the 0.05 level?
Yes, it is statistically significant at this level.
 */

/* 3. */
/*3.1 Generate a correlation table and scatter plot matrix
for the VAR variables Age, Weight, Height*/
proc corr data=statdata.bodyfat2 nosimple
     plots=matrix(histogram);
   /*specify the continuous predictor variables*/
   var Age Weight Height;
   
   title "Correlations and Scatter Plot Matrix for Age, Weight, Height";
run;

/*3.2 Generate a correlation table for the circumference measures*/
proc corr data=statdata.bodyfat2 nosimple;
   /*specify the continuous predictor variables*/
   var Neck Chest Abdomen Hip Thigh
       Knee Ankle Biceps Forearm Wrist;
   title "Correlations of Circumferences";
run;

/* 3.3 Generate a correlation table and scatter plot matrix 
for the VAR variables 
with the circumference measures*/
proc corr data=statdata.bodyfat2 nosimple
     plots=matrix;
   /*specify the continuous predictor variables*/
   var Neck Chest Abdomen Hip Thigh
       Knee Ankle Biceps Forearm Wrist;
   /*specify the continuous response variables*/
   with Age Weight Height;
   
   title "Correlations and Scatter Plot Matrix between";
   title2 "Basic Measures and Circumferences";
run;

title;
/*
Several relationships appear to have high correlations 
(such as those among Hip, Thigh, and Knee). 

Weight seems to correlate highly with all circumference variables.
 */