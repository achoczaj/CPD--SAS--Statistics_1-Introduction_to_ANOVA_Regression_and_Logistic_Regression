/*******************************************************************************

Model Post-Fitting for Inference - a collection of snippets

from Summary of Lesson 4: Model Post-Fitting for Inference
SAS Statistics I: Introduction to ANOVA, Regression, and Logistic Regression

*******************************************************************************/


/*******************************************************************************
1. Examining Residuals
*******************************************************************************/
/*
Verifying the first assumption of linear regression, that the linear model fits the data adequately, is critical. You should always plot your data before producing a model.

The remaining three assumptions of linear regression relate to error terms, so you check these assumptions in terms of errors, not in terms of the values of the response variable.
To verify these assumptions, you can use several different residual plots to check your regression assumptions. You can plot the residuals versus the predicted values, plot the residuals versus the values of the independent variables, and produce a histogram or a normal probability plot of the residuals. To verify that model assumptions are valid, you can analyze the shape of the residual values to ensure that they display a random scatter of the residual values above and below the reference line at 0. If you see patterns or trends in the residual values, the assumptions might not be valid and the models might have problems. You can also use residual plots to detect outliers.

To create residual plots and other diagnostic plots, you use the REG procedure, which creates a number of default plots. Specifying an identifier variable in the ID statement shows you that information when you place your mouse pointer on the data points in the graph. You can also request specific plots with the PLOTS= option in the PROC REG statement.
*/

/*******************************************************************************
2. Identifying Influential Observations
*******************************************************************************/
/*
You should also identify any influential observations that strongly affect the linear model's fit to the data. To identify outliers and influential observations in your data, you can use several diagnostic statistics in PROC REG. To detect outliers, you can use STUDENT residuals. To detect influential observations, you can use Cook’s D statistics, RSTUDENT residuals, and DFFITS statistics. Cook’s D statistic is most useful for explanatory or analytic models, and DFFITS is most useful for predictive models. If you detect an influential observation, you can identify which parameter the observation is influencing most by using DFBETAS.

When you run the GLMSELECT procedure, it automatically creates the macro variable _GLSIND. The _GLSIND macro variable stores the list of effects that are in the selected model. If you don't need to see the output, you can add the statement ods select none before the PROC GLMSELECT step to supress output. You add ods select all after the step to make sure that you get output from the next step that you run. To detect influential observations in your model, you can reference the _GLSIND macro variable in PROC REG to generate influence statistics and plots for the selected model. PROC REG automatically saves the plot data to output data sets.

You can review the output data sets by using PROC PRINT. For very large data sets, viewing or printing all residuals and influence statistics quickly becomes unwieldy. To reduce the amount of output, you can merge the data sets into a single data set with only observations that exceed the suggested cutoffs of the influence statistics.

You can handle influential observations in several ways. You can recheck for data entry errors, determine whether you have an adequate model, and determine whether the observation is valid but unusual. If you choose to exclude some observations in your analysis, include in your report a description of the types of observations that you excluded and why. As part of your report or presentation, you should discuss the limitation of your conclusions, given the exclusions.
*/

/*******************************************************************************
3. Detecting Collinearity
*******************************************************************************/
/*
Collinearity, also called multicollinearity, occurs in multiple regression when two or more predictor variables are highly correlated with each other. Collinearity doesn't violate the assumptions of multiple regression, but it leads to instability in the regression model.

To detect collinearity, you can check your PROC REG output. To measure the magnitude of collinearity in a model, you can use the VIF option in the MODEL statement. If you detect collinearity, you can determine how to proceed and which model to select.

To review, effective modeling includes performing preliminary analyses, selecting candidate models, validating assumptions, detecting influential observations and collinearity, revising your model, and performing prediction testing.
*/

/*******************************************************************************
  Sample Programs
*******************************************************************************/
/* 1. Producing Default Diagnostic Plots */
ods graphics / imagemap=on;

proc reg data=statdata.fitness;
   PREDICT: model Oxygen_Consumption=
                  RunTime Age Run_Pulse Maximum_Pulse;
   id Name;
   title 'PREDICT Model - Plots of Diagnostic Statistics';
run;
quit;
title;

/* 2. Requesting Specific Diagnostic Plots */
ods graphics / imagemap=on;

proc reg data=statdata.fitness
         plots(only)=(QQ RESIDUALBYPREDICTED RESIDUALS);
   PREDICT: model Oxygen_Consumption=
                  RunTime Age Run_Pulse Maximum_Pulse;
   id Name;
   title 'PREDICT Model - Plots of Diagnostic Statistics';
run;
quit;
title;

/* 3. Looking for Influential Observations, Part 1 */
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom ;

ods select none;
proc glmselect data=statdata.ameshousing3 plots=all;
   STEPWISE: model SalePrice = &interval / selection=stepwise
                   details=steps select=SL slentry=0.05 slstay=0.05;
   title "Stepwise Model Selection for SalePrice - SL 0.05";
run;
quit;
ods select all;

ods graphics on;
ods output RSTUDENTBYPREDICTED=Rstud
           COOKSDPLOT=Cook
           DFFITSPLOT=Dffits
           DFBETASPANEL=Dfbs;
proc reg data=statdata.ameshousing3
         plots(only label)=
              (RSTUDENTBYPREDICTED
               COOKSD
               DFFITS
               DFBETAS);
   SigLimit: model SalePrice = &_GLSIND;
   title 'SigLimit Model - Plots of Diagnostic Statistics';
run;
quit;

/* 4. Looking for Influential Observations, Part 2 */
 /* Before running the code below,*/
 /* run the code from the previous demo,
 /* Looking for Influential Observations, Part 1.*/
 /* Run both programs in the same SAS session.*/

title;
proc print data=Rstud;
run;

proc print data=Cook;
run;

proc print data=Dffits;
run;

proc print data=Dfbs;
run;

data Dfbs01;
   set Dfbs (obs=300);
run;

data Dfbs02;
   set Dfbs (firstobs=301);
run;

data Dfbs2;
   update Dfbs01 Dfbs02;
   by Observation;
run;

data influential;
/*  Merge data sets from above.*/
    merge Rstud
          Cook
          Dffits
		  Dfbs2;
    by observation;

/*  Flag observations that have exceeded at least one cutpoint;*/
   if (ABS(Rstudent)>3) or (Cooksdlabel ne ' ') or Dffitsout then flag=1;
   array dfbetas{*} _dfbetasout: ;
   do i=2 to dim(dfbetas);
      if dfbetas{i} then flag=1;
   end;

/*  Set to missing values of influence statistics for those*/
/*  that have not exceeded cutpoints;*/
   if ABS(Rstudent)<=3 then RStudent=.;
   if Cooksdlabel eq ' ' then CooksD=.;

/*  Subset only observations that have been flagged.*/
   if flag=1;
   drop i flag;
run;

title;
proc print data=influential;
   id observation;
   var Rstudent CooksD Dffitsout _dfbetasout:;
run;

/* 5. Detecting Collinearity */
proc reg data=statdata.fitness;
   PREDICT: model Oxygen_Consumption=
                  RunTime Age Run_Pulse Maximum_Pulse;
   FULL: model Oxygen_Consumption =
               Performance RunTime Age Weight
               Run_Pulse Rest_Pulse Maximum_Pulse;
   title 'Collinearity: Full Model';
run;
quit;
title;

/* 6. Calculating Collinearity Diagnostics */
proc reg data=statdata.fitness;
   FULL: model Oxygen_Consumption=
               Performance RunTime Age Weight
               Run_Pulse Rest_Pulse Maximum_Pulse
               / vif;
   title 'Collinearity: Full Model with VIF';
run;
quit;
title;

/* 7. Dealing with Collinearity */
proc reg data=statdata.fitness;
   NOPERF: model Oxygen_Consumption=
                 RunTime Age Weight
                 Run_Pulse Rest_Pulse Maximum_Pulse
                 / vif;
   title 'Dealing with Collinearity';
run;
quit;
title;
