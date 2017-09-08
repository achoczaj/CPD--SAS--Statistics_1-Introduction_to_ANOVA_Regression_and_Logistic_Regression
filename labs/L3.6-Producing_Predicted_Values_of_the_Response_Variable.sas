/*
 * Lab 3.6: Producing Predicted Values of the Response Variable
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Producing Predicted Values of the Response Variable
 */

/*
The REG Procedure: Producing Predicted Values

You've seen the prediction interval for values that already occurred in your data, 
such as Donna's RunTime value of 8.17. 
But what's the value of Oxygen_Consumption for a different value of RunTime, 
such as 9, 10, 11, 12, or 13 minutes? 
You can use the estimated regression equation to produce predicted values. 
But if you want to predict a large number of values, this approach is cumbersome. 

You're in luck, though. Guess which software produces these predicted values for you? 

In the upcoming demonstration, you'll see exactly how to produce predicted values in PROC REG. 
For now, here are the general steps to follow: 
1. First, create a data set containing the values of the independent variable 
for which you want to make predictions. 
2. Concatenate the new data set with the original data set. 
3. Fit a simple linear regression model to the new data set 
and specify the P option in the MODEL statement. 

Because the concatenated observations contain missing values for the response variable, 
PROC REG doesn't include these observations when fitting the regression model. 
However, PROC REG does produce predicted values for these observations.
*/
/*
Produce predicted values of Oxygen_Consumption when RunTime is 9, 10, 11, 12, and 13 minutes. 

Use DATA steps for the first two steps of the process, then PROC REG for the final step.
*/

/* 1.  
Create a temporary data set - Need_Predictions, to contain the values of the independent variable RunTime. 
These are the values, 9 through 13, at which we want to make predictions for Oxygen_Consumption. 
Submit the DATA step and check the log.*/
data need_predictions;
   input RunTime @@;
   datalines;
9 10 11 12 13
;
run;
/*
The new data set contains five observations. Here's the data. 

2. Concatenate the data set Need_Predictions with the original Fitness data set 
to create a new data set, PredOxy.
*/
data predoxy;
   set need_predictions 
       statdata.fitness;
run;
/*
The log indicates that the new data set contains 36 observations. Here's the new data set. 
Notice that the observations from the Need_Predictions data set contain missing values for Oxygen_Consumption. 

3. Fit a simple linear regression model to the new data set, PredOxy.
Add the P option to the MODEL statement. 
Specifying the P option prints the values of the response variable, 
the predicted values, and the residual values. 
Add an ID statement to display values of RunTime, the independent variable we used for our predictions. 
Submit the program.
*/
proc reg data=predoxy;

   /*specify response (or dependent) variable = predictor (or regressor) variable*/	
   model Oxygen_Consumption=RunTime / p;
   id RunTime;

   title 'Oxygen_Consumption=RunTime with Predicted Values';
run;
quit;
title;
/*Results:
When we view the results, we see that PROC REG read 36 observations. 
Here's a question: How many observations did PROC REG use 
when fitting the regression model? Only 31. 
And here's another question: How many observations had missing values? 5. 
Because the 5 newly added observations contain missing values for Oxygen_Consumption,
PROC REG doesn't use these observations when fitting the regression model, 
only when producing predicted values. 
 
How does this portion of the output compare to our previous model? 
The output for this regression model is identical to the earlier model. 
Due to the missing values for Oxygen_Consumption, the new values of RunTime weren't used in any model calculations and so didn't affect the model.

Now let's view the Output Statistics table to see the predicted values of Oxygen_Consumption that we requested. The RunTime column appears in the output because we specified this variable in the ID statement. 

So, when RunTime is 9 minutes, what's the estimated or predicted value of Oxygen_Consumption? It's 52.63. One more: when RunTime is 13 minutes, what's the predicted value of Oxygen_Consumption? Right—it's 39.38.

Here's an important reminder. When you use a model to predict future values of the response variable given certain values of the predictor variable, you must stay within the range of values for the predictor variable used to create the model. For example, in the original Fitness data set, values of RunTime range from a little over 8 minutes to a little over 14 minutes. Based on that data, you shouldn't try to predict what Oxygen_Consumption would be for a RunTime value outside that range. The relationship between the predictor variable and the response variable might be different beyond the range of the data.
 */

