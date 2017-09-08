/*
 * Lab 3.5: Viewing and Printing Confidence Intervals and Prediction Intervals
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Viewing and Printing Confidence Intervals and Prediction Intervals
 */

/*
Confidence and Prediction Intervals

Your linear regression model predicts or estimates values of Oxygen_Consumption. 
But how precise are your predictions or estimates? 
To assess the level of precision around the mean estimates of Oxygen_Consumption, 
you can produce confidence intervals around the means. 

In this plot, the shaded area represents the confidence intervals around the means.

Suppose you have a 95% confidence interval around the means. How do you interpret it? 
A confidence interval gives an estimated range of values 
which is likely to include an unknown population parameter. 
The level (here, 95%) indicates your degree of confidence. 
So, a 95% confidence interval around the means indicates 
that you are 95% confident that your interval 
contains the true population mean of Y for a particular X. 

Confidence intervals become wider as you move away 
from the mean of the predictor (X) variable. 
The wider the confidence interval, the less precise it is. 


You might also want to construct prediction intervals for a single observation. 

If you sample again at a particular X value, 
then the prediction interval gives you a range 
where you can predict that Y will occur. 

In this plot, the dashed lines represent the prediction intervals 
around the individual observations. 

Try answering this question: 
How do you interpret a 95% prediction interval? 
If you create a 95% prediction interval, 
the interpretation is that you are 95% confident 
that your interval contains the new observation. 

Now take a guess: For a given set of data, why is a prediction interval wider 
than a confidence interval? 
A prediction interval is wider than a confidence interval 
because single observations have more variability than sample means.
*/
/*
Specifying Confidence and Prediction Intervals in SAS

To display confidence and prediction intervals, 
you can specify the CLM and CLI options in the MODEL statement. 

CLI produces confidence limits for an individual predicted value. 

CLM produces confidence limits for a mean predicted value for each observation. 

Let's return to the PROC REG output and view confidence intervals and prediction intervals.
*/
proc reg data=statdata.fitness;
   
   /*specify response (or dependent) variable = predictor (or regressor) variable*/	
   model Oxygen_Consumption = RunTime / clm cli;
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
title;
/*
Let's scroll to the bottom of the output and view the fit plot. 
RunTime is on the horizontal axis, and Oxygen_Consumption is on the vertical axis. 
Notice that by default, PROC REG reports model statistics in the plot. 

The solid line is the regression line running through the observations. 
The shaded area is the confidence intervals around the means. 
The dashed lines are the prediction intervals around the individual observations. 

The shaded area and dashed lines provide a good visual sense of 
the confidence intervals and prediction intervals. 


But suppose we want to print precise tables of this information. 
To produce tables of the confidence intervals and prediction intervals 
at each observed data point, we can add an ID statement 
specifying Name and RunTime, just to clarify the output. 
Then we submit the program and check the log.
*/
proc reg data=statdata.fitness;
   model Oxygen_Consumption = RunTime / clm cli;
   id Name RunTime; 
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
title;
/*Results:
The Output Statistics table displays the printed confidence intervals and prediction intervals. 

The columns labeled 95% CL Mean are the lower and upper confidence limits for the mean. 
These are intervals for the mean of Y at a particular value of X.
 
The columns labeled 95% CL Predict are the lower and upper prediction limits. 
These are intervals for a future value of Y at a particular value of X. 

The residual is the dependent variable minus the predicted variable. 
For example, look at observation 1, for Donna. 
Her running time was 8.17 minutes, her observed value of Oxygen_Consumption was 59.57, 
and her predicted value of Oxygen_Consumption from the model was 55.38. 

Here's a question: 
What are the lower and upper confidence limits for the mean of Oxygen_Consumption 
when RunTime is equal to 8.17 minutes? 
They are 53.33 and 57.43, respectively. 
That is, we are 95% confident that the true mean of Oxygen_Consumption 
for this value of RunTime is in this interval. 

Now suppose that we sample a new value of Oxygen_Consumption, 
when RunTime is equal to 8.17 minutes. 
What are the lower and upper prediction limits for this new value? 
They are 49.4 and 61.35, respectively. 
In other words, we are 95% confident that when RunTime equals 8.17 minutes, 
a newly sampled value of Oxygen_Consumption will fall in this interval.
*/



