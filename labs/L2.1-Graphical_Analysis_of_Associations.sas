/*
 * Lab 2.1: Graphical Analysis of Associations
 *
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Part of knowing your data is to get a general idea of any associations 
between predictor variables and the response variable. 

You can do this by conducting a graphical analysis of your data using box plots.

To graphically explore associations between a categorical predictor variable 
and a continuous response variable, you can use the SGPLOT procedure to produce box plots. 
*/

/*
Scenario: Getting to Know the Ames Housing Data
Suppose you are a data analyst who is studying data 
about the sale of residential properties in Ames, Iowa from 2006 to 2010. 

The variable that you are interested in is SalePrice. 
So, SalePrice is the response variable. 

The categorical predictor variables in the datas set 
include house style, overall quality, overall condition, central air, and many more. 

The original Ames housing data set contains 2,930 observations. 
You work primarily with a sample of 300 houses in the data set AmesHousing3, 
which is a subset of the full data set, AmesHousing. 
 */

/*
An association exists between two variables 
when the expected value of one variable 
differs at different levels of the other variable. 

For instance, suppose the average sale price of homes with central air conditioning 
is markedly different than that of homes without central air. 
This would imply that there could be an association, 
or relationship, between sale price and central air.

A simple way to look for possible associations in your data is to create box plots. 
In a box plot, the response variable (Y) is typically on the Y axis 
and the categorical predictor variable (X_1) is on the X axis.

The diamond within each box is the mean of Y. 
(The horizontal line in each box represents the median.) 
There is a box for each value of X. 
So, if there are two X values, the plot contains two boxes. 

Extending from the top and bottom of each box are whiskers 
that represent the spread of the data points. 
For this reason, some people refer to box plots as box-and-whisker plots.

>> regression line 
You can include a regression line on your box plot to connect the means of Y 
at each value of X. 

If the regression line is not horizontal, then there might be an association between X and Y. 
In other words, the value of Y differs at different levels of X.

A horizontal regression line indicates that there is no association between X and Y. 
In other words, knowing the value of X does not tell you anything about the value of Y. 
So for each value of X, your best guess as to the value of Y would simply be the mean of Y, or Y-bar.
 */


/*
Use PROC SGPLOT to explore the statdata.ameshousing3 data set 
for associations between categorical predictor variables 
and the continuous response variable. 
*/

proc sgplot data=statdata.ameshousing3;
   vbox SalePrice;
   title "Sale Price";
run;

/* Use PROC SGPLOT to create comparative box plots */
proc sgplot data=statdata.ameshousing3;
   vbox SalePrice / category=Central_Air
                    connect=mean;
   title "Sale Price Differences across Central Air";
run;
 
proc sgplot data=statdata.ameshousing3;
   vbox SalePrice / category=Fireplaces
                    connect=mean;
   title "Sale Price Differences across Fireplaces";
run;
 
proc sgplot data=statdata.ameshousing3;
   vbox SalePrice / category=Heating_QC
                    connect=mean;
   title "Sale Price Differences across Heating Quality";
run;

/*
This program contains three SGPLOT steps.

In the SGPLOT statement, we specify the statdata.ameshousing3 data set. 
The VBOX statement creates a vertical box plot that shows the distribution of your data. 
After the keyword VBOX, specify the variable for the Y axis. 
The response variable is typically on the Y axis, so we specify SalePrice here, 
followed by a forward slash (for options).
 
The CATEGORY= option creates different box-and-whisker plots 
for each level of the category variable. 
We want to see if there is an association between sale price 
and whether the home has central air conditioning, so we specify Central_Air. 

We also want SAS to include a straight regression line 
that joins the means of Y from group to group. 
So, we include the CONNECT= option and specify mean. 

Finally, we include a TITLE statement and a RUN statement. 


The second SGPLOT step specifies Fireplaces as the category variable 
and the third specifies Heating_QC.
 */