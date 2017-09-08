/*
 * Practice 1: Examining Residuals
 * Lesson 4: Model Post-Fitting for Inference
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
Assess the model from the final forward stepwise selection of predictors 
for the Statdata.BodyFat2 data set.
Reminder: Make sure you've defined the Statdata library.
1. Run a regression of PctBodyFat2 on Abdomen, Weight, Wrist, and Forearm. 
Create the following plots:
- a plot of the residuals by the four regressors
- a plot of the residuals by the predicted values
- a normal quantile-quantile plot.

2. Do the residual plots indicate any problems with the equal variance assumption?

3. Does the quantile-quantile plot indicate any problems with the normality assumption?
*/

/* 1.*/
/*Assess the model from the final forward stepwise selection of predictors
for FORWARD Model of PctBodyFat2*/
proc reg data=statdata.bodyfat2 
			plots(only)=
              (RESIDUALS RESIDUALBYPREDICTED QQ); 
   FORWARD: model PctBodyFat2 = 
                  Abdomen Weight Wrist Forearm;
   id Case;
   title 'FORWARD Model of PctBodyFat2 - Plots of Diagnostic Statistics';
run;
quit;

title;

/*
2.Do the residual plots indicate any problems 
with the equal variance assumption?
It does not appear that the data violates the assumption of constant variance.


3. Does the quantile-quantile plot indicate any problems 
with the normality assumption?
The normality assumption seems to be met.
 */