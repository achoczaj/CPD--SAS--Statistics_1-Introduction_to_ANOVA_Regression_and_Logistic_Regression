/*
 * Lab 5.9: Generating Best Predictions Using PROC PLM
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
*** Comparing the Multiple Logistic Regression Models ***

Let's compare the last multiple logistic regression model that has main effects and a two-way interaction with the earlier model that has only the main effects. We'll look at the fit statistics AIC and SC, which are reported in the Model Fit Statistics table, and the c statistic in the Association of Predicted Probabilities and Observed Responses table.

When you compare Model Fit Statistics like AIC and SC, in general, smaller values are better. Note that the SC value increased with the addition of the interaction. SC selects more parsimonious models by imposing a more severe penalty for increasing the number of parameters. When you include the interaction term, there's not enough improvement over the main effects model.

Now look at the AIC. Its value decreased in the model that includes the interaction. This indicates a better model fit, but recall that the AIC has a less severe penalty than the SC. Comparing the c statistic values, you see that the interaction model is larger. This indicates that the interaction model is a better predictive model than the main effects-only model.


*** Interaction Plots ***

To visualize the interaction between Gender and IncLevel, you can produce an interaction plot. 

This plot explains more of the story behind the significant interaction in the output in the previous demonstration. This plot shows two slopes for IncLevel, one for males and one for females. If there is no interaction between two variables, the slopes should be relatively parallel. However, the slopes shown here are not parallel. You can see how the logit of the predicted probability of spending $100 or more is affected by low, medium, and high incomes for males and females. The probability of females spending $100 or more barely increases as the income level increases. The probability of males spending $100 or more barely increases from low to medium incomes, but it significantly increases from medium to high incomes. So, the probability of spending $100 or more is highly related to income for men, but it is weakly related to income for women. 

Interaction Plot

To visualize the interaction between two predictors, you can produce an interaction plot. The following interaction plot shows the interaction between the variables Gender and IncLevel (income level) on the logit of the predicted probability of spending $100 or more on merchandise from a catalog store.

This plot shows two slopes for IncLevel, one for males and one for females. If there is no interaction between two variables, the slopes should be relatively parallel. However, the slopes shown here are not parallel. You can see how the logit of the predicted probability of spending $100 or more is affected by low, medium, and high incomes for males and females. The probability of females spending $100 or more barely increases as the income level increases.  The probability of males spending $100 or more barely increases from low to medium incomes, but significantly increases from medium to high incomes. So, the probability of spending $100 or more is highly related to income for men, but is weakly related to income for women.

The following code creates this interaction plot:


proc means data=statdata.sales_inc noprint nway;
   class IncLevel Gender;
   var Purchase;
   output out=bins sum(Purchase)=Purchase n(Purchase)=BinSize;
run;

data bins;
   set bins;
      Logit=log((Purchase+1)/(BinSize-Purchase+1));
run;

proc sgscatter data=bins;
   plot Logit*IncLevel /group=Gender markerattrs=(size=15)
                        join;
   format IncLevel incfmt.;
   label IncLevel='Income Level';
   title;
run;
quit;

Note: The user-defined format INCFMT. is stored as a permanent format in the same location as the data files for this course.


*** Saving Analysis Results with the STORE Statement ***

Recall that you can use the STORE statement with PROC GLM to save your analysis results as an item store for later processing and analysis using PROC PLM.

You can also use the STORE statement with PROC LOGISTIC.

Here's the STORE statement in a PROC LOGISTIC program that uses the ameshousing3 data set. Following the keyword STORE, you use the OUT= option to specify the name of your item store, in this case isbonus.
*/

/*************************************
Generating Best Predictions Using PROC PLM 
*************************************/
/*
Let's fit a multiple logistic regression model that includes main effects and an interaction effect, using the ameshousing3 data set. We'll save the analysis results in an item store and then use that data to generate predictions for bonus eligibility for new data.
*/
ods select none;
proc logistic data=statdata.ameshousing3;
   class Fireplaces (ref='0') Lot_Shape_2 (ref='Regular') / param=ref;
   model Bonus(event='1')=Basement_Area|Lot_Shape_2 Fireplaces;
   units Basement_Area=100;
   store out=isbonus;
run;
ods select all;

data newhouses;
   length Lot_Shape_2 $9;
   input Fireplaces Lot_Shape_2 $ Basement_Area;
   datalines;
   0 Regular 1060
   2 Regular 775
   2 Irregular 1100
   1 Irregular 975
   1 Regular 800
   ;
run;

proc plm restore=isbonus;
   score data=newhouses out=scored_houses / ILINK;
   title 'Predictions using PROC PLM';
run;

proc print data=scored_houses;
run;
/*The code for the logistic procedure is in the editor. In the STORE statement, we specify that SAS should store the results of the procedure in the item store named isbonus. We indicate that we do not wish to view any results by preceding the program with an ODS SELECT NONE statement. Following the procedure, we use the ODS SELECT ALL statement to indicate that from this point forward we would like to have results displayed.

Next we'll create a data set named newhouses that contains the data for generating predictions. 

Finally, we'll use the PLM procedure to generate predictions for the newhouses data set.

In the PROC PLM statement, the RESTORE option specifies that the predictions will be based on the analysis results saved in the item store isbonus.

The SCORE statement specifies that SAS will score the data set named newhouses and will output the results into a new data set called scored_houses. The ILINK option requests that SAS provide the predictions in the form of predicted probabilities in lieu of logits where covariate effects are additive.

We'll close our program with a PRINT procedure so that we can view the new data set.

Let's run the code and review the results from PROC PLM.
*/
/* Results:
The table produced by PROC PLM shows that the house with the highest predicted probability of being bonus eligible (0.306) has an irregular lot shape, 1 fireplace, and a basement area of 975 square feet. The house with the lowest predicted probability (0.0004) has a regular lot shape, 2 fireplaces, and a basement area of 775.

Be sure that you generate predictions only for new data records that fall within the range of the training data. If not, predictions could be invalid due to extrapolation. We assume that the modeled relationship between predictors and responses holds across the span of the observed data. We should not assume that this relationship holds everywhere.
*/