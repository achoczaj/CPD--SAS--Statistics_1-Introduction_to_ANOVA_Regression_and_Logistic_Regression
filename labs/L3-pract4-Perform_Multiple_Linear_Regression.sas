/*
 * Practice 4: Perform Multiple Linear Regression
 * Lesson 3: Accessing Observations Directly
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
Using the BodyFat2 data set, perform linear regression using multiple predictor variables. Reminder: Make sure you've defined the Statdata library.
1. Run a regression of PctBodyFat2 on the variables Age, Weight, Height, Neck, Chest, Abdomen, Hip, Thigh, Knee, Ankle, Biceps, Forearm, and Wrist.
- Compare the ANOVA table with this one from the model with only Weight.

Analysis of Variance
Source		DF	Sum of		Mean
				Squares		Square		F Value		Pr > F
							
Model		1	6593.01614	6593.01614	150.03		<.0001
Error		250	10986		43.94389	 	 
Corrected 
Total		251	17579	 	 	 
What is different?

- How do the R2 and the adjusted R2 compare with these statistics for the Weight regression?
Root MSE		6.62902		R-Square	0.3751
Dependent Mean	19.15079	Adj R-Sq	0.3726
Coeff Var		34.61485	 	 
- Did the estimate for the intercept change? Did the estimate for the coefficient of Weight change?

2. To simplify the model, rerun the model from step 1, 
but eliminate the variable with the highest p-value. 
Compare the output	with the model from step 1.
- Did the p-value for the model change?
- Did the R2 and the adjusted R2 values change?
- Did the parameter estimates and their p-values change?

3. To simplify the model further, rerun the model from step 2, 
but eliminate the variable with the highest p-value. 
- How did the output change from the previous model?
- Did the number of parameters with p-values less than 0.05 change?

*/

/* 1.*/
proc reg data=statdata.bodyfat2;
   
   /*specify response (or dependent) variable = predictor (or regressor) variables*/
   model PctBodyFat2 = Age Weight Height
         Neck Chest Abdomen Hip Thigh
         Knee Ankle Biceps Forearm Wrist;
   title 'Regression of PctBodyFat2 on All Predictors';
run;
quit;
title;
/*
There are key differences between the ANOVA table for this model 
and the one for the simple linear regression model. 
The degrees of freedom for the model are much higher, 13 versus 1. 
Also, the Mean Square Model (1012.22506) and the F ratio (54.50) are much smaller.

Both the R2 (0.7486) and adjusted R2 (0.7348) for the full models are larger 
than the simple linear regression. 
The multiple regression model explains almost 75 percent of the variation 
in the PctBodyFat2 variable, versus only about 37.5 percent 
explained by the simple linear regression model.

Yes, including the other variables in the model 
changed both the estimate of the intercept and the slope for Weight. 
Also, the p-values for both changed dramatically. 
The slope of Weight is now not significantly different from zero.
 */

/*2.*/
proc reg data=statdata.bodyfat2;
   
   /*specify response (or dependent) variable = predictor (or regressor) variables*/
   model PctBodyFat2 = Age Weight Height
         Neck Chest Abdomen Hip Thigh
         Ankle Biceps Forearm Wrist;
   
   title 'Model W/O Knee var';
run;
quit;
title;

/*
This program reruns the regression with Knee removed because it has the largest p-value (0.9552). 

The p-value for the model did not change out to four decimal places.

The R2 showed essentially no change. The adjusted R2 increased from .7348 to .7359. 
When an adjusted R2 increases by removing a variable from the models, 
it strongly implies that the removed variable was not necessary.

Some the parameter estimates and their p-values changed slightly, 
but none to any large degree.
 */

/*3.*/
proc reg data=statdata.bodyfat2;
   
   /*specify response (or dependent) variable = predictor (or regressor) variables*/
   model PctBodyFat2 = Age Weight Height
         Neck Abdomen Hip Thigh
         Ankle Biceps Forearm Wrist;
   title 'Model W/O Knee and Chest';
run;
quit;
title;
/*
This program reruns the regression with Chest removed (and w/o Knee)
because it is the variable with the highest p-value in the previous model. 

The ANOVA table did not change significantly. 
The R2 remained essentially unchanged. 
The adjusted R2 increased again, confirming that the variable Chest 
did not contribute to explaining the variation in PctBodyFat2 
when the other variables were in the model.

The p-value for Weight changed more than any other (0.0618)
and is now just above 0.05. 
The p-values and parameter estimates for other variables changed much less. 
 */