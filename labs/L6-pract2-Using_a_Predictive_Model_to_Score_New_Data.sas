/*
 * Practice 2: Using a Predictive Model to Score New Data
 * Lesson 6: Model Building and Scoring for Prediction
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
You want to re-create the model that was built in the previous practice (based on Statdata.AmesHousing3), create an item store, and then use the item store to score the new cases in Statdata.AmesHousing4. You will score the data in two different ways—using PROC GLMSELECT and PROC PLM—and compare the results.
Reminder: Make sure you've defined the Statdata library.
1. Submit the following code to create two macro variables, Interval and Continuous, that store the names of the interval and continuous inputs for the analysis, respectively. Note: This practice uses the same inputs and the same two macro variables that were created in the previous demonstration. If you ran the code for the previous demonstration and you have not closed your SAS software, you can skip this step.
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
                 Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
                 Masonry_Veneer Lot_Shape_2 Central_Air;

2. Copy and paste the following code (a slightly modified version of code from the previous practice) into the editor:
proc glmselect data=statdata.ameshousing3
               seed=8675309
               noprint;
   class &categorical / param=reference ref=first;
   model SalePrice=&categorical &interval / 
               selection=stepwise
               select=aic 
               choose=validate;
   partition fraction(validate=0.3333);
   title "Selecting the Best Model using Honest Assessment";
run;
Note: You do not need to examine the PROC GLMSELECT results in this practice, so the following changes were made to the PROC GLMSELECT statement: the PLOTS= option was removed and the NOPRINT option was added.


In the PROC GLMSELECT step, add the following statements:
a STORE statement to create an item store
a SCORE statement to score the data in Statdata.AmesHousing4

Add a PROC PLM step that scores the data in Statdata.AmesHousing4. Note: Be sure to use different names for the two scored data sets. 

Add a PROC COMPARE step to compare the scoring results from PROC GLMSELECT and PROC PLM.

Submit the code and examine the results.


Does the PROC COMPARE output indicate any differences between the predictions produced by the two scoring methods?
*/

/* 1.*/
/*create two macro variables for predictor variables*/
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
                 Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
                 Masonry_Veneer Lot_Shape_2 Central_Air;

/*2*/
proc glmselect data=statdata.ameshousing3 /*input data set*/
               seed=8675309 /*set a seed*/
               noprint;
   /* specifies the categorical variables */
   class &categorical / param=reference ref=first;
   
   /*specify the variables to include in the model*/
   model SalePrice=&categorical &interval / 
               selection=stepwise
               select=aic 
               choose=validate;
   
   /*partitions the cases in the input data set for test and validate data sets.
     the rest cases stay as training data set*/
   partition fraction(test=0 validate=0.3333);
  
   title "Selecting the Best Model using Honest Assessment";
run;

title;

/* 3. */
proc glmselect data=statdata.ameshousing3 /*input data set*/
               seed=8675309 /*set a seed*/
               noprint;
   /* specifies the categorical variables */
   class &categorical / param=reference ref=first;
   
   /*specify the variables to include in the model*/
   model SalePrice=&categorical &interval / 
               selection=stepwise
               select=aic 
               choose=validate;
   
   /*partitions the cases in the input data set for test and validate data sets.
     the rest cases stay as training data set*/
   partition fraction(test=0 validate=0.3333);
   
   score data=statdata.ameshousing4 out=score1;
   
   store out=store1;
   
   title "Selecting the Best Model using Honest Assessment";
run;

title;


proc plm restore=store1;
   score data=statdata.ameshousing4 out=score2;
run;

proc compare base=score1 compare=score2 criterion=0.0001;
   var P_SalePrice;
   with Predicted;
run;

/*4.*/
Does the PROC COMPARE output indicate any differences 
between the predictions produced by the two scoring methods?

As shown in this output, the two scoring methods produce the same predictions. 

NOTE: Depending on the version of SAS and SAS/STAT that you are using, 
your results may look somewhat different from the output shown here, 
however the results should indicate that these data sets do not differ.
