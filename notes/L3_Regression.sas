/*******************************************************************************

Regression - a collection of snippets

from Summary of Lesson3: Regression
SAS Statistics I: Introduction to ANOVA, Regression, and Logistic Regression

*******************************************************************************/


/*******************************************************************************
1. Exploratory Data Analysis
*******************************************************************************/
/*
To analyze continuous variables, you can use linear regression.

To investigate your data before performing linear regression, you can use techniques for exploratory data analysis, including scatter plots and correlation analysis. In exploratory data analysis, you're simply trying to explore the relationships between variables and to screen for outliers.

Scatter plots are an important tool for describing the relationship between continuous variables. Plot your data! You can use scatter plots to examine the relationship between two continuous variables, to detect outliers, to identify trends in your data, to identify the range of X and Y values, and to communicate the results of a data analysis.

You can also use correlation analysis to quantify the relationship between two variables. Correlation statistics measure the strength of the linear relationship between two continuous variables. Two variables are correlated if there is a linear association between them. A common correlation statistic used for continuous variables is the Pearson correlation coefficient, which ranges from –1 to +1.

The population parameter that represents a correlation is ρ. The null hypothesis for a test of a correlation coefficient is that ρ equals 0, and the alternative hypothesis is that ρ is not 0. Rejecting the null hypothesis means only that you can be confident that the true population correlation is not exactly 0. You need to avoid common mistakes when interpreting the correlation between variables.

To produce correlation statistics and scatter plots for your data, you use CORR procedure. To rank-order the absolute value of the correlations from highest to lowest, you add the RANK option to the PROC CORR statement. To produce scatter plots, you add the PLOTS= option in the PROC CORR statement. You can also add context-specific options in parentheses following the main option keyword, such as PLOTS or SCATTER.

To examine the correlations between the potential predictor variables, you produce a correlation matrix and scatter plot matrix by using the NOSIMPLE, PLOTS=MATRIX, and HISTOGRAM options. You can specify tooltips that display detailed information about observations when you place your mouse pointer on a data point To specify these tooltips, you use the IMAGEMAP=ON option in the ODS GRAPHICS statement and an ID statement in the PROC CORR step.
*/
/*******************************************************************************
2. Simple Linear Regression
*******************************************************************************/
/*
In correlation analysis, you determine the strength of the linear relationships between continuous response variables. In simple linear regression, you use the simple linear regression model to determine the equation for the straight line that defines the linear relationship between the response variable and the predictor variable.

To determine how much better the model that takes the predictor variable into account is than a model that ignores the predictor variable, you can compare the simple linear regression model to a baseline model. For your comparison, you calculate the explained, unexplained, and total variability in the simple linear regression model.

The null hypothesis for linear regression is that the regression model does not fit the data better than the baseline model.The alternative hypothesis is that the regression model does fit the data better than the baseline model. In other words, the slope of the regression line is not equal to 0, or the parameter estimate of the predictor variable is not equal to 0.

Before performing simple linear regression, you need to verify the four assumptions for linear regression: that the mean of the response variable is linearly related to the value of the predictor variable, that the error terms are normally distributed, that the error terms have equal variances, and that the error terms are independent at each value of the predictor variable.

To fit regression models to your data, you use PROC REG. The MODEL statement specifies the response variable and the predictor variable. To evaluate your model, you typically examine the p-value for the overall model, the R-square value, and the parameter estimates.

To assess the level of precision around the mean estimates of the response variable, you can produce confidence intervals around the means and construct prediction intervals for a single observation. To display confidence and prediction intervals, you can specify the CLM and CLI options in the MODEL statement.

To produce predicted values for small data sets using PROC REG, you create a new data set containing the values of the independent variable for which you want to make predictions, concatenate the new data set with the original data set, and fit a simple linear regression model to the new data set.

To produce predicted values for large data sets, using PROC REG and PROC SCORE is more efficient. You can use the NOPRINT and OUTEST= options in a PROC REG statement to write the parameter estimates from PROC REG to an output data set. Then you score the new observations using PROC SCORE, with the SCORE= option specifying the data set containing the parameter estimates, the OUT= option specifying the data set that PROC SCORE creates, and the TYPE= option specifying what type of data the SCORE= data set contains.
*/
/*******************************************************************************
3. Multiple Regression
*******************************************************************************/
/*
Multiple Regression
In multiple regression, you can model the relationship between the response variable and more than one predictor variable. In a model with two predictor variables, you can model the relationship of the three variables—three dimensions—with a two-dimensional plane.

Multiple linear regression has advantages and disadvantages. Its biggest advantage is that it's more powerful than simple linear regression. That is, you can determine whether a relationship exists between the response variable and several predictor variables at the same time. The disadvantages of multiple linear regression are that you have to decide which model to use, and that when you have more predictors, interpreting the model becomes more complicated.

You can use multiple regression in two ways: for analytical or explanatory analysis and for prediction. If you specify many terms, the model for multiple regression can become very complex.

The hypotheses for multiple regression are similar to those for simple linear regression. The null hypothesis is that the multiple regression model does not fit the data better than the baseline model. (All the slopes or parameter estimates are equal to 0.) The alternative hypothesis is that the regression model does fit the data better than the baseline model.

For multiple linear regression, the same four assumptions as for simple linear regression apply: that the mean of the response variable is linearly related to the value of the predictor variables, that the error terms are normally distributed, that the error terms have equal variances, and that the error terms are independent at each value of the predictor variable.

To compare multiple linear regression models, you typically examine the p-value for the overall models, the adjusted R-square values, and the parameter estimates. The adjusted R-square value takes into account the number of terms in the model and increases only if new terms significantly improve the model.
*/
/*******************************************************************************
4. Lesson Review
*******************************************************************************/
/*
Your first decision in model selection is whether to use a manual or automated approach. Automated model selection techniques in SAS fall into two general categories: the all-possible regressions method and stepwise selection methods. For a large number of potential predictor variables, the stepwise regression methods might be a better option. The all-possible regressions method produces more candidate models, which requires you to use your expertise to select a model.

In the all-possible regressions method, SAS calculates all possible regression models. To describe your model, you can add an optional label to the MODEL statement. You can reduce the number of models in the output by specifying the BEST= option in the MODEL statement. To help evaluate the models you produce, you can request Mallows' Cp statistic in the PLOTS= option in the PROC REG statement and in the SELECTION= option in the MODEL statement. To request statistics for each model, you can specify them in the SELECTION= option. To select the best model for prediction,you should use Mallows' criterion for Cp. To select the best model for parameter estimation, you should use Hocking's criterion for Cp.

Stepwise selection methods are another, less computer-intensive way to find good candidate models without having to generate all possible models. You can specify forward, backward, and stepwise methods in the SELECTION= option in the MODEL statement. Each method selects variables based on their p-values. To change the default p-values that PROC REG uses to select variables, you can use the SLENTRY= and SLSTAY= options in the MODEL statement. It's a good idea to always run all three stepwise selection methods and look for commonalities among the final models for all three methods.
*/
/*******************************************************************************
5. Model Building and Interpretation
*******************************************************************************/
/*
There are other selection criteria that you can use to select variables for a model as well as evaluate competing models. These statistics are collectively referred to as information criteria. Four types of information criteria are available in the GLMSELECT procedure: Akaike’s information criterion (AIC), corrected Akaike’s information criterion (AICC), Sawa Bayesian information criterion (BIC), and Schwarz Bayesian information criterion (SBC).

Other selection criteria that you can use with PROC GLMSELECT are the adjusted R-square and Mallows’ Cp.
*/

/*******************************************************************************
  Syntax
*******************************************************************************/

PROC CORR DATA=SAS-data-set <options>;
  VAR variable(s);
  WITH variable(s);
RUN;

Selected Options in PROC CORR
Statement	    Option
PROC CORR	    RANK
              PLOTS=<(context-specific options)>
              NOSIMPLE

Selected ODS  Option
Statement	    Option
ODS GRAPHICS	IMAGEMAP=ON

..............................
PROC REG DATA=SAS-data-set <options>;
  MODEL dependent-regressor <options>;
  WITH variable(s);
  ID variable(s);
RUN;

Selected Options in PROC REG
Statement	    Option
PROC REG	    NOPRINT
              OUTEST=
MODEL	        CLM
              CLI
              P

...................................
PROC SCORE DATA=SAS-data-set
                       SCORE=SAS-data-set
                       OUT=SAS-data-set
                       TYPE=name
                       <options>;
VAR variable(s);
RUN;
QUIT;

.................................................
PROC GLMSELECT DATA=SAS-data-set <options>;
CLASS variables;
<label: > MODEL dependent(s)=regressor(s) </ options>;
RUN;

Selected Options in PROC GLMSELECT
Statement	    Option
MODEL	        SELECTION=
              SELECT=
*/

/*******************************************************************************
  Sample Programs
*******************************************************************************/
/* 1. Exploring Associations with Scatter Plots */
proc sgscatter data=statdata.ameshousing3;
   plot SalePrice*Gr_Liv_Area / reg;
   title "Associations of Above Grade Living Area with Sale Price";
run;

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

options nolabel;
proc sgscatter data=statdata.ameshousing3;
   plot SalePrice*(&interval) / reg;
   title "Associations of Interval Variables with Sale Price";
run;

/* 2. Producing Correlation Statistics and Scatter Plots */
proc corr data=statdata.fitness rank
               plots(only)=scatter(nvar=all ellipse=none);
   var RunTime Age Weight Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   with Oxygen_Consumption;
   title "Correlations and Scatter Plots with Oxygen_Consumption";
run;
title;

/* 3. Examining Correlations between Predictor Variables */
ods graphics on / imagemap=on;
proc corr data=statdata.fitness nosimple
          plots=matrix(nvar=all histogram);
   var RunTime Age Weight Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   id name;
   title "Correlations with Oxygen_Consumption";
run;
title;

/* 4. Performing Simple Linear Regression */
proc reg data=statdata.fitness;
   model Oxygen_Consumption=RunTime;
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
title;

/* 5. Viewing and Printing Confidence Intervals and Prediction Intervals */
proc reg data=statdata.fitness;
   model Oxygen_Consumption=RunTime / clm cli;
   id name runtime;
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
title;

/* 6. Producing Predicted Values of the Response Variable */
data need_predictions;
   input RunTime @@;
   datalines;
9 10 11 12 13
;
run;

data predoxy;
   set need_predictions
       statdata.fitness;
run;

proc reg data=predoxy;
   model Oxygen_Consumption=RunTime / p;
   id RunTime;
   title 'Oxygen_Consumption=RunTime with Predicted Values';
run;
quit;
title;

/* 7. Storing Parameter Estimates and Scoring */
proc reg data=statdata.fitness noprint outest=estimates;
   model Oxygen_Consumption=RunTime;
run;
quit;

proc print data=estimates;
   title "OUTEST= Data Set from PROC REG";
run;
title;

proc score data=need_predictions score=estimates
           out=scored type=parms;
   var RunTime;
run;

proc print data=Scored;
   title "Scored New Observations";
run;
title;

/* 8. Fitting a Multiple Linear Regression Model */
ods graphics on;

proc reg data=statdata.ameshousing3;
    model SalePrice=Basement_Area Lot_Area;
    title "Model with Basement Area and Lot Area";
run;
quit;

proc glm data=statdata.ameshousing3
         plots(only)=(contourfit);
    model SalePrice=Basement_Area Lot_Area;
    store out=multiple;
    title "Model with Basement Area and Gross Living Area";
run;
quit;

proc plm restore=multiple plots=all;
    effectplot contour (y=Basement_Area x=Lot_Area);
    effectplot slicefit(x=Lot_Area sliceby=Basement_Area=250 to 1000 by 250);
run;

title;

/* 9. Using Automatic Model Selection */
ods graphics / imagemap=on;
proc reg data=statdata.fitness plots(only)=(cp);
   ALL_REG: model Oxygen_Consumption=
   Performance RunTime Age Weight
   Run_Pulse Rest_Pulse Maximum_Pulse
   / selection=cp rsquare adjrsq best=20;
title 'Best Models Using All-Regression Option';
run;
quit;
title;

/* 10. Estimating and Testing Coefficients for Selected Models */
proc reg data=statdata.fitness;
   PREDICT: model Oxygen_Consumption=
                  RunTime Age Run_Pulse Maximum_Pulse;
   EXPLAIN: model Oxygen_Consumption=
                  RunTime Age Weight Run_Pulse Maximum_Pulse;
   title 'Check "Best" Two Candidate Models';
run;
quit;
title;

/* 11. Performing Stepwise Regression */
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom ;

ods graphics on;

proc glmselect data=statdata.ameshousing3 plots=all;
   STEPWISE: model SalePrice=&interval / selection=stepwise
                   details=steps select=SL slstay=0.05 slentry=0.05;
   title "Stepwise Model Selection for SalePrice - SL 0.05";
run;

/*Optional code that will execute forward and backward selection,
each with slentry and slstay = 0.05.
proc glmselect data=statdata.ameshousing3 plots=all;
   FORWARD: model SalePrice=&interval / selection=forward details=steps select=SL slentry=0.05;
   title "Forward Model Selection for SalePrice - SL 0.05";
run;

proc glmselect data=statdata.ameshousing3 plots=all;
   BACKWARD: model SalePrice=&interval / selection=backward details=steps select=SL slstay=0.05;
   title "Backward Model Selection for SalePrice - SL 0.05";
run;
*/

/* 12. More Model Selection Using PROC GLMSELECT */
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom ;

ods graphics on;
proc glmselect data=statdata.ameshousing3 plots=all;
   STEPWISEAIC: model SalePrice = &interval / selection=stepwise details=steps select=AIC;
   title "Stepwise Model Selection for SalePrice - AIC";
run;

proc glmselect data=statdata.ameshousing3 plots=all;
   STEPWISEBIC: model SalePrice = &interval / selection=stepwise details=steps select=BIC;
   title "Stepwise Model Selection for SalePrice - BIC";
run;

proc glmselect data=statdata.ameshousing3 plots=all;
   STEPWISEAICC: model SalePrice = &interval / selection=stepwise details=steps select=AICC;
   title "Stepwise Model Selection for SalePrice - AICC";
run;

proc glmselect data=statdata.ameshousing3 plots=all;
   STEPWISESBC: model SalePrice = &interval / selection=stepwise details=steps select=SBC;
   title "Stepwise Model Selection for SalePrice - SBC";
run;
