/*
 * Lab 6.2: Building and Selecting the Best Predictive Model using PROC GLMSELECT
 
 * Lesson 6: Model Building and Scoring for Prediction
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* 
Scenario: Building a Predictive Model

Suppose you want to build a linear regression model that predicts sale prices for homes 
in Ames, Iowa, based on various home characteristics. 

The data is already partitioned into two non-overlapping data sets: 
Statdata.AmesHousing3 and Statdata.AmesHousing4. 
Both data sets contain cases for houses that are 1500 square feet or less. 

The AmesHousing3 data set can be used for training 
and the AmesHousing4 data set can be used for validation. 

In the model, the target is SalePrice, and unlike previous analyses, 
you want the model to include both categorical predictors, 
such as Season_Sold, and continuous predictors, such as Lot_Area.
*/

/*create two macro variables for predictor variables*/
%let interval_vars=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical_vars=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
                 Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
                 Masonry_Veneer Lot_Shape_2 Central_Air;

/*display ODS plots*/
ods graphics;

proc glmselect data=statdata.ameshousing3 /*training data set*/
               plots=all /*display all ODS plots*/
               valdata=statdata.ameshousing4; /*validation data set*/
   
   /* specifies the categorical variables */
   class &categorical_vars / 
   				/*use GLM parameterization method*/
   				param=glm 
   				/*compare the output at the current level with the first level*/
   				ref=FIRST; /*ref=LAST is default option*/
   
   /*specify the variables to include in the model*/
   /*(predictive) target variable is SalePrice*/
   /*(predictors) inputs are specified using the Categorical_vars and Interval_vars macro variables*/
   model SalePrice = &categorical_vars &interval_vars / 
                  /*use backward selection model*/
                  selection = backward
                  
                  /*use Schwarz-Bayesian criterion to determine 
                    which variables remain in the model. */
                  select = sbc
                  
                  /*select the best model based on the validation data*/
                  choose = validate;
   				  /*proc glmselect select the model that has 
   				    the smallest overall validation error
   				    (calculates the average squared error, 
					 which is the sum of the squared differences 
					 between the observed value and the predicted value using the model)*/
   
   /*write the item store to the temporary WORK library*/
   store out = work.amesstore;
   /*However, if you were doing this on the job, 
     you would want to write the item store to a permanent library.*/

title "Selecting the Best Model using Honest Assessment";
run;

title;
/*
At the top of the SAS program, we use two %LET statements 
to create two macro variables named interval and categorical. 
Each macro variable stores the names of the predictor variables in that category.

Next is an ODS GRAPHICS statement, which ensures 
that any requested ODS graphs are included in the results. 

In the PROC GLMSELECT statement, the DATA= option specifies Statdata.AmesHousing3 
as the training data set. 

We use PLOTS=ALL to display all ODS plots that PROC GLMSELECT produces. 

The VALDATA= option specifies Statdata.AmesHousing4 as the validation data set, 
which is our holdout sample. 

The CLASS statement specifies the categorical variables. 
The PARAM= option specifies the parameterization method. 
In this case, GLM parameterization is used, which is the same method 
that is used in PROC GLM. With GLM parameterization, 
one design variable is produced per level of each CLASS variable. 

We specify REF=FIRST so that, for each design variable, 
we can compare the output at the current level with the first level. 
By default, the reference level is the last level. 

Now let's look at the MODEL statement. 
SalePrice is the target. 
The predictors are specified using the Categorical and Interval macro variables,
created above. The macro variables hold the variable names. 

The SELECTION= option specifies the backward selection model of variable selection. 
SELECT=SBC indicates that the Schwarz-Bayesian criterion will be used 
to determine which variables remain in the model. 

CHOOSE=VALIDATE specifies that PROC GLMSELECT will select the best model 
based on the validation data. 

PROC GLMSELECT selects the model 
that has the smallest overall validation error. 

Specifically, PROC GLMSELECT calculates the average squared error, 
which is the sum of the squared differences 
between the observed value and the predicted value using the model. 

The STORE statement saves the context and results of the statistical analysis 
in a file called an item store. 
It is convenient to create an item store because you can reference it 
in later programs and avoid having to rebuild the model. 
For example, you can use the item store to score new data 
in the next step of predictive modeling. 

Notice that, in this demonstration, the SCORE statement writes the item store 
to the temporary Work library. 
However, if you were doing this on the job, 
you would want to write the item store to a permanent library.
*/

/* Results:
The first table summarizes model information, including the data sets, 
variables, selection method, and criteria 
that are used to select the variables and the final model. 
The last row of this table refers to effect hierarchy. 
You don't need to be concerned with this now; 
you can learn more about model hierarchy in the next lesson.

In the two Observation Profile for Analysis tables, 
one for the analysis (that is, training) data and the other for the validation data, 
notice that the validation data set used one less observation for the analysis. 
This indicates that the validation data set has one more missing value than the training data set.

The Class Level Information table shows that the analysis has 11 categorical variables. 
However, the total degrees of freedom are much higher than 11 
because most categorical variables have more than one level, 
which results in more than one design variable. 
For example, House_Style2 has five levels, so it has four non-redundant design variables 
and four degrees of freedom. 
In the Dimensions table, you can see that the analysis has 20 effects, but 43 parameters. 
The number of parameters is higher than the number of effects 
because some of the effects have multiple parameters. 
Back in the Class Level Information table, you can count the parameters. 
However, each of these variables has one redundant design variable. 
For example, Central_Air has two design variables. 
One design variable tells you whether there is central air, 
and the other tells you whether there is not central air, so these are redundant.


Now let's look at the model selection information. 
In the Backward Selection Summary table, the Step 0 row shows that we start with 20 effects. 

The number of parameters in the model shown here is 32. 
This is the number of non-redundant parameters, so it is smaller 
than the number of parameters that is shown in the Dimensions table above. 
The difference is eleven because there is one redundant design variable 
for each categorical variable that is listed above.

The SBC is assessed on the training data. 
In the Step 1 row, you can see why Season_Sold was removed. 
It produced a reduction in the SBC. 
Moving down the SBC column, we see that variables continue to be removed 
as long as the value of SBC continues to decrease. 
In the last row, for Step 8, the SBC value is followed by an asterisk 
that means Optimal Value of Criterion. 

Remember that the SBC is also the stopping criterion 
because we didn't specify a different criterion. 
So, based on the SBC for the training data, the model at Step 8
--where Lot_Shape_2 was removed--is the best model.


The next column reports the training average squared error, 
but this is not used to select the model. 
A smaller average squared error is better. 
It seems contradictory that, as you remove variables from the model, 
the training average squared error tends to increase. 
However, this is not true for the validation data set, 
so the validation data set gives a better idea of 
how the model performs on data that was not used to build the model. 
Remember that the model is chosen based on the validation average squared error. 

Going down the column for the validation average squared error, 
we see that the validation average squared error continues to decrease 
until we get to Step 6, when Heating_QC is removed. 
At that point, the validation average squared error starts to increase. 
The model in Step 5, when Central_Air is removed, is marked with an asterisk. 

The asterisk indicates that this is the best model based on the validation data.

Let's move farther down in the results, past a table that summarizes the information that we just discussed. 
In the first plot, Coefficient Progression for SalePrice, 
the lower section shows the performance of the eight models based on the validation average squared error. 

In the top section, you can compare the models and see how the parameters changed 
as variables were removed from the model. 
A vertical line extends up through the point for the selected model at Step 5. 
The validation average squared error values at Step 4 and Step 5 are relatively close to each other. 
However, the model at Step 5 has one less predictor variable so it is a more parsimonious model. 
The parameter estimates on this vertical line are of interest to us.

We'll skip over the next few plots, which were discussed in a previous demonstration. 
Let's look at the plot called Progression of Average Squared Errors by Role for SalePrice. 
The ASE for the validation data is plotted on the top line and the training data on the bottom line. 

You saw the validation data plot in the graph that we looked at previously. 
Looking at the training data plot, notice that the ASE cannot go down; 
it can only go up because the backwards elimination criterion is used to remove variables from the model. 
For the training data, the ASE can go down only if variables are added.

In the Analysis of Variance table, we see some summary information. 
The number of degrees of freedom in the selected model is 19. 
Remember that this doesn't mean 19 variables. 
We already saw the SBC and ASE values earlier in the results.

Next is the Parameter Estimates table. 
Let's look at the set of variables for Overall-Qual2: Overall-Qual2-5, -6, and -4. 

For this variable, level 4 is below average, 5 is average, and 6 is above average. 

Remember that the CLASS statement has the option REF=FIRST. 
This means that the first level of each categorical variable
—in this case, level 4—is always set to zero with zero degrees of freedom. 
Level 4 is the reference level, which makes it the redundant design variable. 

Overall_Qual2_5 is a design variable that compares level 5 to the reference level (level 4). 
Likewise, Overall_Qual2_6 is a design variable that compares level 6 to level 4. 

So the Estimate value for Overall_Qual2_5 is the amount of change 
in the response variable when all other predictor variables are held constant, 
and Overall_Qual2 is changed from level 4 to level 5. 
This table also shows t-values. 

We could also get p-values, but that's not useful 
because this model was already selected. 
Notice that this table lists all the categorical variables before the continuous variables. 

We have now completed the tour of our predictive model!
 */
