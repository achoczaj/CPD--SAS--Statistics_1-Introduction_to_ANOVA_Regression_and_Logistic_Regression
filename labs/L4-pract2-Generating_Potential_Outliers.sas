/*
 * Practice 2: Generating Potential Outliers
 * Lesson 4: Model Post-Fitting for Inference
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
Generate statistics for potential outliers in the the Statdata.BodyFat2 data set, write this data to an output data set, and print your results.
Reminder: Make sure you've defined the Statdata library.
1. Using Statdata.BodyFat2, run a regression model of PctBodyFat2 
on Abdomen, Weight, Wrist, and Forearm. 
Use plots to identify potential influential observations 
based on the suggested cutoff values.

2.Output residuals to a data set named Influential, 
subset the data set to select only observations 
that are potentially influential outliers, and print your results. 
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