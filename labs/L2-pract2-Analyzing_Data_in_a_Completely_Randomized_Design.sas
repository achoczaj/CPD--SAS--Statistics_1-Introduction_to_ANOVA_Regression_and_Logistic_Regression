/*
 * Practice 2: Analyzing Data in a Completely Randomized Design
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
Using the BodyFat2 data set, produce a simple linear regression model 
with confidence and prediction intervals around the observations. 
Then produce predicted values.
Reminder: Make sure you've defined the Statdata library.

1. Perform a simple linear regression model with PctBodyFat2 
as the response variable and Weight as the predictor.
- What is the value of the F statistic and the associated p-value? How would you interpret this with regards to the null hypothesis?
- Write out the predicted regression equation.
- What is the value of the R2 statistic? How would you interpret this?
2. Produce confidence and prediction intervals around the observations.
3. Produce predicted values for PctBodyFat2 when Weight is 125, 150, 175, 200, and 225.
- What are the predicted values?
- Is it appropriate to predict PctBodyFat2 when Weight is 100?
- What is the predicted value for PctBodyFat2 when Weight is 150?
*/

/* 1.*/
proc reg data=statdata.bodyfat2;
   /*specify response (or dependent) variable = predictor (or regressor) variable*/
   model PctBodyFat2 = Weight;
   
   title "Regression of % Body Fat on Weight";
run;
quit;
title;
/*
- What is the value of the F statistic and the associated p-value? 
How would you interpret this with regards to the null hypothesis?
F value is 150.03	
p-value is <.0001
I can reject the null hypothesis of no relationship between PctBodyFat2 and Weight.

- Write out the predicted regression equation.
betha_0 = -12.05158, betha_1 = 0.17439
PctBodyFat2 = -12.05158 + ( 0.17439 * Weight)

- What is the value of the R2 statistic?
R-Square value ia 0.3751
 
How would you interpret this?
Only 37.51% of the variability in PctBodyFat2 can be explained by Weight.
 */


/*2.*/
proc reg data=statdata.bodyfat2;
   /*specify response (or dependent) variable = predictor (or regressor) variable*/
   model PctBodyFat2 = Weight / clm cli;
   
   title1 "Regression of % Body Fat on Weight";
   title2 "with confidence and prediction intervals around the observations";
run;
quit;
title;


/*3.*/
proc reg data=statdata.bodyfat2 
			/*suppress the normal display of regression results*/
			/* noprint */
			/*specify an output data set from the regression model*/
			outest=estimates;
   /*specify response (or dependent) variable = predictor (or regressor) variable*/
   model PctBodyFat2 = Weight;
   title "Regression of % Body Fat on Weight";
run;

data Weights_to_Score;
   input Weight @@;
   datalines;
125 150 175 200 225
;
run;

proc score 
		   /*specify the data set containing the observations to score*/
		   data=Weights_to_Score 
		   /*specify the data set containing the parameter estimates*/
		   score=estimates
           /*specify the data set that PROC SCORE creates*/
           out=scored 
           /*declare what type of data the SCORE=... data set contains*/
           type=parms;
   
   /*specify the numeric variables to use in computing scores*/
   var Weight;
run;

proc print data=scored;
   title "Predicted % Body Fat for Weights: 125, 150, 175, 200, 225";
run;
title;
/*
- What are the predicted values?

See the results in the in the MODEL1 column.
Obs	Weight	MODEL1
1	125		9.7470
2	150		14.1067
3	175		18.4664
4	200		22.8261
5	225		27.1859

- Is it appropriate to predict PctBodyFat2 when Weight is 100?
It is not appropriate to predict PctBodyFat2 when Weight is 100 
because no value less than 120 for Weight occurs in the model data set.

- What is the predicted value for PctBodyFat2 when Weight is 150?
PctBodyFat2 is 14.1067.
 */

