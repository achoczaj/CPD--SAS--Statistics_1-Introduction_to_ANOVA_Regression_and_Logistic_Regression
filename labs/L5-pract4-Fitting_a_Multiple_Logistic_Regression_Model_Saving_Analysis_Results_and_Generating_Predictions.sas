/*
 * Practice 4: Fitting a Multiple Logistic Regression Model, Saving Analysis Results, and Generating Predictions
 * Lesson 5: Categorical Data Analysis
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
The insurance company wants to model the relationship between three of a car's characteristics—weight, size, and region of manufacture—and its safety rating. The Statdata.Safety data set contains the data that you need.
Reminder: Make sure that you have defined the Library and Statdata libraries.
1. Fit a multiple logistic regression model with Unsafe as the outcome variable and Weight, Size, and Region as the predictor variables. Use the EVENT= option to model the probability of below-average safety scores. Apply the SIZEFMT. format to the variable Size. (This format is defined in the setup program for this course.) Specify Region and Size as classification variables using reference cell coding, and specify Asia as the reference level for Region and Small as the reference level for Size. Use a UNITS statement with -1 as the unit for weight so that you can see the odds ratio for lighter cars over heavier cars. Request any relevant plots. Add an appropriate title. Submit the code and view the log.

2. View the results. Which terms appear in the final model?

3. If you compare these results with those from the previous practice (a model fit with just one variable, Region), do you think that this is a better model?

4. Using the final model, chosen by backward elimination, and using the STORE statement, generate predictive probabilities for the cars in the following DATA step.
	data checkSafety;
	   length Region $9.;
	   input Weight Size Region $ 5-13;
	   datalines;
	4 1 N America
	3 1 Asia     
	5 3 Asia     
	5 2 N America
	;
	run;
*/


/* 1.*/
ods graphics on;

proc logistic data=statdata.safety plots(only)=(effect oddsratio);
   class Region (param=ref ref='Asia')
         Size (param=ref ref='Small');
   model Unsafe(event='1')=Weight Region Size / clodds=pl selection=backward;
   units weight=-1;
   store isSafe;
   format Size sizefmt.;
   title 'LOGISTIC MODEL: Backwards Elimination';
run;

title;
/*
2. Which terms appear in the final model?
Only Size appears in the final model.

3. If you compare these results with those from the previous practice (a model fit with just one variable, Region), do you think that this is a better model?
Comparing the model fit statistics, you see that the AIC (92.629) and SC (100.322) are both smaller in the this logistic regression model fit by the backward elimination method. This indicates that the Size-only model is better than the Region-only model. Using the c statistic, you can also see improvement beyond the Region-only model, 0.818 in this model as compared with 0.598 in the previous model.

4. Using the final model, chosen by backward elimination, and using the STORE statement, generate predictive probabilities for the cars in the following DATA step.
*/
data checkSafety;
   length Region $9.;
	 input Weight Size Region $ 5-13;
	 datalines;
4 1 N America
3 1 Asia     
5 3 Asia     
5 2 N America
;
run;

proc plm restore=isSafe;
score data=checkSafety out=scored_cars / ILINK;
title 'Safety Predictions using PROC PLM';
run;

proc print data=scored_cars;
run;

title;