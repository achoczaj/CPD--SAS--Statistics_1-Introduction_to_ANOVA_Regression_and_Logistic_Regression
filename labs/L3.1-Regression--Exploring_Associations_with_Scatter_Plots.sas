/*
 * Lab 3.1: Exploring Associations with Scatter Plots
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
In this demonstration, we want to get a general idea of 
where there are associations 
between the response variable SalePrice 
and predictor variables in the statdata.ameshousing3 data set. 

We also want to see the general shape of each association. 
To do this, we use PROC SGSCATTER to produce a number of scatter plots.

We’ll start by generating a scatter plot to see 
if there is an association between sale price 
and above grade living area. Here’s our program.
*/

proc sgscatter data=statdata.ameshousing3;
   /*plot Y_axis-response_variable * X_axis-predictor_variable*/	
   plot SalePrice*Gr_Liv_Area / reg;
   								/*use REG Option - include a regression line fit to the scatter plot*/
  
   title "Associations of Above Grade Living Area with Sale Price";
run;

/*
In the PROC SGSCATTER statement, we specify the statdata.ameshousing3 data set. 
In the PLOT statement, we specify the Y axis variable, an asterisk, and then the X axis variable. 
We’ll put the response variable on the Y axis and the predictor variable on the X axis. 
We’ll add reg after the forward slash, which tells SAS to include a regression line fit to the scatter plot. 
We’ll add a title and end the step with a RUN statement. Let’s run the code and take a look at the scatter plot.

It looks like a reasonably straight line can be drawn through the points on the plot, 
so there seems to be a linear association between above grade living area and sale price. 

Notice that there seems to be more variability in sale price at higher living area values. 
This could lead to a problem called heteroscedasticity. 
This topic is discussed in detail in the SAS course Statistics 2: ANOVA and Regression.
*/

/*
Create scatter plots using several other predictor variables with MACRO
*/

/*
One benefit of using PROC SGSCATTER is that you can run it once 
to create a panel of multiple scatter plots. 

We’ll start with a %LET statement that creates the interval macro variable 
containing the list of interval variables, which could be discrete or continuous. 
This allows us to reference the interval macro variable in our program code 
rather than listing all of the predictor variables. 
So, if we ever wanted to change the list of predictor variables, 
we could simply change them in the %LET statement. 

In the PROC SGCATTER step we reference the interval macro variable in parentheses. 
This will produce a scatter plot of SalePrice on the Y axis by all of the interval variables on the X axis. 
(Note that if we wanted to, we could list multiple variables on the Y axis 
by putting them in parentheses as well.) 
The OPTIONS NOLABEL statement tells SAS not to use labels for the variables.
*/

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
 
options nolabel;
proc sgscatter data=statdata.ameshousing3;
   /*plot Y_axis-response_variable * X_axis-predictor_variable*/
   plot SalePrice * (&interval) / reg;
   								  /*use REG Option - include a regression line fit to the scatter plot*/
   title "Associations of Interval Variables with Sale Price";
run;
title;
/*Results:
Here is the panel of scatter plots that we requested. 
All of the plots have a non-horizontal straight-line shape, 
so there seems to be some association between each of the predictor variables and SalePrice. 
Note that this data set contains only 300 observations. 

Obviously, if you had thousands of observations it might be difficult to see the shape of the plot. 
In that case, you might run PROC SGSCATTER on a random sample of observations.
 */
