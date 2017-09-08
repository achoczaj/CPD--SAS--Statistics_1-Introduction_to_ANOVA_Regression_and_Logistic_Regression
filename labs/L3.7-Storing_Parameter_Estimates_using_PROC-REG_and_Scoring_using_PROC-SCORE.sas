/*
 * Lab 3.7: Storing Parameter Estimates using PROC REG and Scoring using PROC SCORE
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
1. The SCORE Procedure: Scoring Predicted Values Using Parameter Estimates
 */

/*
In the previous demonstration, you learned how to predict values 
of the response variable using the DATA step and PROC REG. 
In that example, the data set was very small.

A temporary data set 'Need_Predictions', 
contains the values of the independent variable RunTime. 

These are the values, 9 through 13, at which we want to make predictions for Oxygen_Consumption. 
*/

data need_predictions;
   input RunTime @@;
   datalines;
9 10 11 12 13 
;
run;

/* 
For large data sets, a different method is more efficient. 

If you have a large data set and have already fitted the regression model, 
you can predict values more efficiently by using PROC REG and PROC SCORE. 

You can write the parameter estimates from PROC REG to an output data set, 
and then score the new observations using PROC SCORE. 
Let's see what all this means. 

Here's a PROC REG step similar to the previous one.
*/
proc reg data=statdata.fitness 
			/*suppress the normal display of regression results*/
			noprint 
			/*specify an output data set from the regression model*/
			outest = estimates;
   
   /*specify response (or dependent) variable = predictor (or regressor) variable*/
   model Oxygen_Consumption = RunTime;
   
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
/* 
It reads the Statdata.Fitness data set and fits a model. 
But this time, instead of producing the usual results tables and graphs, 
you want to store your results in a new data set. 
To do this, you add two options to the PROC REG statement. 

The NOPRINT option suppresses the normal display of regression results. 
The OUTEST= option specifies an output data set 
containing parameter estimates and other summary statistics 
from the regression model. 
Name the output data set Estimates.
*/
/*
Add a PROC PRINT step to display the output data set.
*/
proc print data=estimates;
   title "OUTEST= Data Set from PROC REG";
run;
title;
/* Results:
When we submit the program and check the log, 
we see that SAS wrote 1 observation and 7 variables 
to the data set Work.Estimates. 

Look at the new data set. 
The variable _MODEL_ provides a SAS name for the new score variable. 
The variable _TYPE_ identifies the observations 
that contain scoring coefficients, 
in this case PARMS for the parameter estimates from PROC REG. 
The dependent variable (_DEPVAR_) is Oxygen_Consumption. 
The root mean squared error (_RMSE_) is the same 
as in the regression model. 
The parameter estimate for the intercept ( β_0 ) is 82.42. 
The parameter estimate for the slope (of RunTime var) β_1 is -3.31. 
 */


/*
After storing the parameter estimates, you can use PROC SCORE 
to multiply values from two SAS data sets. 
The data set Estimates contains the parameter estimates from the model. 
The other data set contains the observations you want to score. 

To illustrate, let's score the Need_Predictions data set, 
even though it's small. 

Here's the syntax for PROC SCORE. 
*/
proc score 
		   /*specify the data set containing the observations to score*/
		   data=need_predictions 
		   /*specify the data set containing the parameter estimates*/
		   score=estimates
           /*specify the data set that PROC SCORE creates*/
           out=scored 
           /*declare what type of data the SCORE=... data set contains*/
           type=parms;
   
   /*specify the numeric variables to use in computing scores*/
   var RunTime;
run;
/*
In the PROC SCORE statement, the DATA= option specifies 
the data set containing the observations to score, 
which is 'Need_Predictions'. 
The SCORE= option specifies the data set containing the parameter estimates, 
which is 'Estimates'. 
The OUT= option specifies the data set that PROC SCORE creates. 
Let's call this data set 'Scored'. 
Finally, the TYPE= option tells PROC SCORE what type of data 
the SCORE= data set contains. 
In this case, specifying TYPE=PARMS tells SAS 
to use the parameter estimates in the Estimates data set.
 
The VAR statement specifies the numeric variables 
to use in computing scores. 
These variables must appear in both the DATA= and SCORE= input data sets. 

If you don't specify a VAR statement, 
PROC SCORE uses all the numeric variables in the SCORE= data set. 
So it's important to specify a VAR statement with PROC SCORE, 
because you rarely use all the numeric variables 
in your data set to compute scores. 

Use RunTime as the numeric variable to multiply with the parameter estimates.
*/


/* Print the Scored data set*/
proc print data=Scored;
   title "Scored New Observations";
run;

title;
 */

/*
When we submit the program and check the log, we see that SAS read 5 observations from Work.Need_Predictions and 1 observation from Work.Estimates, and then wrote 5 observations and 2 variables to Work.Scored. Here's the scored data. The variable MODEL1 contains the predicted values of Oxygen_Consumption when RunTime is equal to 9, 10, 11, 12, and 13 minutes. If you recall, these values are exactly the same as the ones we produced using PROC REG. 

Remember the guideline about predicting only values within or near the range of the predictor variable? This is true with PROC SCORE, just as with PROC REG. However, we know we're trying to predict values of Oxygen_Consumption based on the same values of RunTime as before, 9 through 13. So, are we following our guideline? Yes, we are. We're predicting only values within or near the range of the predictor variable.
 */