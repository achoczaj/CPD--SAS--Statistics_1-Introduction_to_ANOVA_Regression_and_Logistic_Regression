/*
 * Lab 3.8: Fitting a Multiple Linear Regression Model
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Multiple Regression
 */

/*
In simple linear regression, you can model the relationship between the two variables with a line. 
That is, you model the relationship of two dimensions, the two variables, with a one-dimensional line. 
For instance, here's the regression line for the relationship between RunTime and Oxygen_Consumption. 

But suppose you want to model the relationship between the response variable 
and more than one predictor variable. 
For example, what if you want to know the effect of age and weight on oxygen consumption? 

In multiple regression, you can model the relationship between the response variable 
and more than one predictor variable. 

In a model with two predictor variables, you can model the relationship 
of the three variables (three dimensions) with a two-dimensional plane. 

In this topic, you learn how to use multiple regression. 
You learn the mathematical model for multiple regression, 
the advantages and disadvantages of multiple regression over simple linear regression, 
and common pitfalls of multiple regression. 

To perform multiple regression, you use PROC REG, as you do for simple linear regression. 
 */
/*
Advantages and Disadvantages of Multiple Regression

Let's see why you might perform multiple linear regression 
instead of simple linear regression. 

The biggest advantage is simple: multiple linear regression 
is a more powerful tool! 
Using multiple linear regression, you can determine whether 
a relationship exists between the response variable 
and more than one predictor variable at the same time. 

What about the disadvantages of multiple linear regression? 
Think back to the fitness example, where you had one response variable 
and seven potential predictor variables. 
For this number of variables, you have 127 possible models 
with at least one predictor variable. 
How do you decide which model to use? 
You'll learn techniques for selecting candidate models in the next topic, 
but the selection process adds a step to your analysis. 

Another disadvantage is that the more predictors you have, 
the more complicated interpreting the model becomes. 

The advantages definitely outweigh the disadvantages.
 */
/*
Common Applications for Multiple Linear Regression

So, when do you use multiple linear regression? 
Multiple regression is a powerful tool for both analytical 
or explanatory analysis and for prediction. 
In analytical or exploratory analysis, you develop a model 
to help understand the relationships between the response variable 
and predictor variables. 

For example, does increasing the number of police officers 
affect the crime rate? 
In a situation like this, you're not necessarily concerned about 
predicting crime. 
Instead, you're trying to understand what relationship 
certain factors have to the crime rate. 

In prediction, you develop a model to predict future values 
of a response variable based on its relationships with predictor variables. 
For example, suppose you want to estimate, or predict, 
a person's percentage of body fat. 
To do this, you might fit a predictive regression model 
that uses skinfold measurements from different parts of the body 
to predict the true percentage of body fat. 

In this lesson, you use multiple regression 
for both explanatory analysis and predictive analysis.
 */

/*******************************************
The Multiple Regression Model
*********************************************

Here's the model for simple linear regression, which you know. 
Y = β_0 + ( β_1 * X ) + ε

The model for multiple regression is similar. 
Y = β_0 + ( β_1 * X_1 ) + ( β_2 * X_2 ) + ε
For two predictor variables, this is the model. 

Y is the response variable. 
X_1 and X_2 are the predictor variables. 
ε is the error term. 
β_0 is the y-intercept. 
β_1 is the average change in Y for a 1-unit change in X_1, holding X_2 constant. 
β_2 is the average change in Y for a 1-unit change in X_2, holding X_1 constant. 

As you just saw, this model is a plane. 
When no relationship exists between Y, X_1, and X_2, 
the model is a horizontal plane passing through the point where Y equals β_0, 
because β_1 and β_2 equal 0. 

When a linear relationship does exist between Y, X_1, and X_2, 
the model is a sloping plane. 
In this case, X_1, X_2, or both affect Y, so the plane tilts. 


Multiple regression model
In a multiple regression model, you model the response variable Y, 
as a linear function of the k-predictor variables of the all Xs (X_1, X_2, ..., X_k). 
The model has k+1 parameters, the β_0, β_1, ..., β_k, because it includes the intercept. 

When you have many terms in the model, what do you suppose happens? 
As you can imagine, modeling a k-dimensional surface becomes very complex. 

Don't worry, though. In this topic, you model the relationship 
of two predictor variables and the response variable, so your modeling surface is a plane.
 */

/*
Analysis versus Prediction in Multiple Regression

Remember that when you use multiple linear regression for analytical or explanatory analysis, 
you want to understand the relationship between the variables. 
As a result, you test the statistical significance of the parameter coefficients 
to determine whether a relationship exists 
between the response variable and the predictor variables. 

When you interpret the parameters, you take the magnitudes 
and signs of the coefficients (β_0, β_1, ..., β_k) into account. 

In contrast, when you use multiple regression for prediction, 
your focus is the predictive power of the model. 

Remember that you want to predict future values of a response variable 
based on its relationships with the predictor variables. 
For predictive modeling, you are less interested 
in the values of the parameter coefficients (the β_i-s), 
and their statistical significance (the p-values). 

However, you might use these statistics to help choose 
between several candidate models. 
The predictive model you end up with might have terms 
that aren't significant, but it's the model 
that you've determined best predicts future values of the response variable.
 */

/*
Hypothesis Testing for Multiple Regression

As you might expect, the hypotheses for multiple regression 
are similar to those for simple linear regression. 

The null hypothesis is that the multiple regression model 
does not fit the data better than the baseline model. 
In other words, all the slope parameters are equal to 0. 

The alternative hypothesis is that the regression model 
does fit the data better than the baseline model. 
It also indicates that at least one of the slope parameters is not equal to 0.
 */

/*
Assumptions for Multiple Regression

For a multiple regression analysis to be valid, four assumptions need to be met. 

1. A linear function of the Xs accurately models the mean of the Ys.
2. The errors are normally distributed with a mean of 0.
3. The errors have constant variance.
4. The errors are independent.
*/


/*
Scenario: Using Multiple Regression to Explain Sale Price

Suppose you performed a simple linear regression that identified 
the variable Lot_Areas as an important variable 
in explaining the values of SalePrice. 

Now suppose you want to see whether adding the variable Basement_Area 
might produce a significantly better model for explaining SalePrice.

To help you decide whether your new model is better, 
you can compare the adjusted R-square (Adj R-Sq) values for the models.

Try answering this question: 
Why not use the regular R-square values instead of the adjusted R-square values? 
The regular R-square values never decrease when you add more terms to the model. 

But the adjusted R-square value takes into account the number of terms in the model 
by including a penalty for the complexity of the model.

The adjusted R-square value increases only 
if new terms that you add significantly improve the model enough 
to warrant increasing the complexity of the model. 

Example:
In your simple linear regression model, the adjusted R-square value 
with Lot_Area as the only predictor variable was 0.0610. 

What percentage of the variation in SalePrice does Lot_Area alone explain? 
Approximately 6.42%. 
This R-square value suggests that you might be able to explain 
more of the variation in SalePrice 
by adding more variables. 
Remember that the adjusted R-square includes a penalty.
 */


/********************************************
Fitting a Multiple Linear Regression Model
 *********************************************/
/*
In this demonstration, we run a linear regression model 
with two predictor variables using the Ames housing data. 

First, we perform linear regression by using PROC REG. 
Then we fit the same model again, this time using PROG GLM. 
By using PROC GLM, we can also produce a contour plot 
and store our results for later analysis using PROC PLM. 
 */
ods graphics on;

proc reg data=statdata.ameshousing3 ;
    /*specify response (or dependent) variable = predictor (or regressor) variables*/	
    model SalePrice = Basement_Area Lot_Area;
    
    title "Model with Basement Area and Lot Area";
run;
quit;
/*Results:
We start our program with ODS Graphics on to ensure 
that we get all of the graphical output.

In the PROC REG statement, we specify the data set statdata.ameshousing3. 
The MODEL statement specifies the model. 
SalePrice is the response variable and we have 
two predictor variables - Basement_Area and Lot_Area. 

Now we’ll run the code and check the log. No issues here.
Let's look at the results. 
The ANOVA table shows that the model is statistically significant at the 0.05 alpha level.


Suppose you fit another model, this time with just one predictor variable, Lot_Area. */
proc reg data=statdata.ameshousing3 ;
    model SalePrice = Lot_Area;
    title "Model with only Lot Area";
run;
/*
Do you know which statistic you would use to compare the two models? 
That’s right—you compare models using the adjusted R-square values. 


Let's look at the Parameter Estimates table. 
The model that includes only Lot_Area shows 
that the correlation between Lot_Area and SalePrice is statistically significant. 
However, when we add Basement_Area to the model, Lot_Area is no longer significant. 
The reason is that the two-predictor model adjusts 
the p-values of each predictor variable 
to take into account the presence of all other variables 
that are already in the model. 

So, when the model accounts for the effect of Basement_Area, 
the effect of Lot_Area no longer shows statistical significance. 


Next, we look at the graphical output to see 
if our statistical assumptions are met. 
As we would expect, residuals plotted against predicted values 
gives us a relatively random scatter around 0. 
This gives us evidence that we have constant variance, 
at least across all of the predicted values. 

In the Q-Q plot (Residual vs. Quantile), the residuals fall along the diagonal line, 
indicating that there are no problems with an assumption of normally distributed error. 

Also, the residuals look approximately normal in the histogram.


Next, we see the residuals plotted against the predictor variables. 
The residuals show no pattern, although lot size does show some outliers.
*/

/*
Now let’s run the same model in PROC GLM. 
*/
proc glm data=statdata.ameshousing3 
         plots(only)=(contourfit);
    model SalePrice=Basement_Area Lot_Area;
    store out=multiple;
    title "Model with Basement Area and Gross Living Area";
run;
quit;
/*
When you run a linear regression model with only two predictor variables, 
the output includes a contour fit plot by default. 
We specify CONTOURFIT to tell SAS to overlay the contour plot 
with a scatter plot of the observed data.

Following the MODEL statement we add the statement STORE OUT=multiple. 
Later, we can run PROC PLM and reference the item store multiple 
in order to analyze the stored output.

Let’s run the PROC GLM step and check the log.
 */
/* Results:
In the results, we see that the values in the ANOVA table 
are the same as in PROC REG. 
Note that PROC GLM does not give an adjusted R-square value. 

The parameter estimates table here gives the same results (within rounding error) 
as in PROC REG. 

Next is the contour fit plot with the overlaid scatter plot that we requested. 
We can use this plot to see how well your model predicts observed values. 
The plot shows predicted values of SalePrice as gradations of the background color 
from blue, representing low values, to red, representing high values. 
The dots, which are similarly colored, represent the actual data. 
Observations that are perfectly fit would show the same color 
within the circle as outside the circle. 
The lines on the graph help you read the actual predictions at even intervals.

For example, this point near the upper-right represents an observation 
with a basement area of about 1,500 square feet, 
a lot size of about 17,000 square feet, 
and a predicted value of over $180,000 for sale price. 
However, the dot’s color shows that its observed sale price 
is actually closer to about $160,000.

Now, let’s run PROC PLM to get additional plots 
based on the multiple item store that was produced in PROC GLM. 
 */
proc plm restore=multiple plots=all;
    effectplot contour (y=Basement_Area x=Lot_Area);
    effectplot slicefit(x=Lot_Area sliceby=Basement_Area=250 to 1000 by 250);
run; 

title;
/*
Specify PLOTS=ALL and two EFFECTPLOT options, CONTOUR and SLICEFIT. 
The CONTOUR option displays a contour plot of predicted values 
against two continuous covariates. 
We specify y=Basement_Area and x=Lot_Area.

The SLICEFIT option displays a curve of predicted values 
versus a continuous variable grouped by the levels of another effect. 

Here (x=Lot_Area sliceby=Basement_Area=250 to 1000 by 250), 
we tell SAS that we want to see lot area effect 
at different values of basement area.

Now let’s run the code.*/

/* Results:
Notice that the lines on this contour fit plot are oriented differently 
than the one from PROC GLM and this one does not contain a scatterplot overlay. 
Clearly, the PROC GLM contour fit plot is more useful. 

However, if you do not have access to the original data set 
and can run PROC PLM only on the item store, this plot still gives you an idea 
of the relationship between the predictor variables and predicted values.


The last plot is a sliced fit plot for SalePrice by Lot_Area 
categorized by Basement_Area. 
The regression lines represent the slices of Basement_Area 
that we specified in the code. 
This plot can be helpful in reporting predicted values 
to someone who does not understand regression.
 */