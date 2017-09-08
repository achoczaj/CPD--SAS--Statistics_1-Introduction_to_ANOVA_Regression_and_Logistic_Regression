/*
 * Practice 1: Building and Selecting the Best Predictive Model
 * Lesson 6: Model Building and Scoring for Prediction
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
You want to build a model that predicts the sales price of homes in Ames, Iowa, 
that are 1500 square feet or below, based on various home characteristics. 
You start with the data set Statdata.AmesHousing3.
Reminder: Make sure you've defined the Statdata library.
1. Submit the following code to create two macro variables, Interval and Categorical, 
that store the names of the interval and continuous inputs for the analysis, respectively. 
Note: This practice uses the same inputs and the same two macro variables 
that were created in the previous demonstration. If you ran the code for the previous demonstration and you have not closed your SAS software, you can skip this step.
	%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
	              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
	%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
	                 Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
	                 Masonry_Veneer Lot_Shape_2 Central_Air;

2. Write a PROC GLMSELECT step that predicts the values of SalePrice. 
To specify the inputs, reference the Interval and Categorical macro variables that you created previously. 
Partition the AmesHousing3 data set into a training data set of approximately 2/3 
and a validation data set of approximately 1/3. 
Specify the seed 8675309. 
Use stepwise selection with AIC as the selection criterion 
and validation average squared error for the model choice criterion. 

To produce graphical results, add an ODS GRAPHICS statement before the PROC GLMSELECT step. 
Submit the code and examine the results.

3. Which model did PROC GLMSELECT choose?

4. Resubmit the PROC GLMSELECT step without making any changes to it. Does it produce the same results as before?


In the PROC GLMSELECT statement, change the value of SEED= and submit the modified code. Does it produce the same results as before?
*/

/* 1.*/
/*create two macro variables for predictor variables*/
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
                 Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
                 Masonry_Veneer Lot_Shape_2 Central_Air;

/*2*/
/*display ODS plots*/
ods graphics;

proc glmselect data=statdata.ameshousing3 /*input data set*/
               plots=all /*display all ODS plots*/
               seed=8675309;/*set a seed*/
   
   /* specifies the categorical variables */
      class &categorical /  
   				/*use ref parameterization method*/
   				param=reference 
   				/*compare the output at the current level with the first level*/
   				ref=FIRST; /*ref=LAST is default option*/
   
   /*specify the variables to include in the model*/
   /*(predictive) target variable is SalePrice*/
   /*(predictors) inputs are specified using the Categorical_vars and Interval_vars macro variables*/
   model SalePrice = &categorical &interval / 
                  /*use stepwise selection model*/
                  selection = stepwise
                  
                  /*use aic criterion to determine 
                    which variables remain in the model. */
                  select = aic
                  
                  /*select the best model based on the validation data*/
                  choose = validate;
   				  /*proc glmselect select the model that has 
   				    the smallest overall validation error
   				    (calculates the average squared error, 
					 which is the sum of the squared differences 
					 between the observed value and the predicted value using the model)*/
   
   /*partitions the cases in the input data set for test and validate data sets.
     the rest cases stay as training data set*/
   partition fraction(test=0 validate=0.3333);
   
title "Selecting the Best Model using Honest Assessment";
run;
title;

/*
 * 3.
 */
Which model did PROC GLMSELECT choose?

PROC GLMSELECT chose the model at Step 10.
It has the following effects: Intercept, House_Style2, Overall_Qual2, Overall_Cond2, 
Fireplaces, Heating_QC, Gr_Liv_Area, Basement_Area, Garage_Area, Deck_Porch_Area, and Age_Sold.

4.
Resubmit the PROC GLMSELECT step without making any changes to it. Does it produce the same results as before?

The results are the same. 
Every time you run a specific PROC GLMSELECT step using the same seed value, 
the pseudo-random selection process is replicated and you get the same results.

5.
In the PROC GLMSELECT statement, change the value of SEED= and submit the modified code. 
Does it produce the same results as before?
*/
Because you used a different seed, the results are almost certainly different from the previous results.
