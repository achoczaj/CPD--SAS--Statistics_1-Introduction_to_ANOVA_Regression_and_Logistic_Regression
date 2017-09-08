/*
 * Lab 3.4: Performing Simple Linear Regression
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
The REG Procedure: Performing Simple Linear Regression
 */

/*
You use correlation analysis to determine the strength of the linear relationships 
between continuous response variables. 
Now you need to go a step further and define the linear relationship itself.  

Two pairs of variables can have the same correlation, 
but very different linear relationships. 
For example, look at the two pairs of variables plotted here. 
If you calculate the correlations for the two sets of variables, 
you get the same value because the strength of the linear relationships is the same. 
However, the linear relationships for the two sets of variables are obviously different. 

In this topic, you use simple linear regression 
to define the linear relationship between a response variable and a predictor variable. 
The response variable is the variable of primary interest. 
The predictor variable explains the variability in the response variable. 
Using simple linear regression, you can determine the equation 
for the straight line that defines the linear relationship 
between the response variable and the predictor variable.

Objectives of Simple Linear Regression

In simple linear regression, you're trying to decide 
how well the predictor variable explains the variability of the response variable. 
You also want to use the values of the predictor variable 
to estimate or predict the values of the response variable. 

Finally you want to determine the equation for the straight line 
that relates the predictor variable to the response variable.
*/

/*
Scenario: Performing Simple Linear Regression

Suppose you want to use linear regression to analyze the data 
from the fitness study. Let's assume that you already plotted 
your data and performed a correlation analysis of the response variable 
versus each of the potential predictor variables. 

The variable RunTime had the highest correlation with Oxygen_Consumption. 
Now you want to explore the relationship between Oxygen_Consumption and RunTime further, 
so you decide to run a simple linear regression of Oxygen_Consumption versus RunTime.

Now answer this question. Which variable is the response variable? 
Oxygen_Consumption is the response variable.
*/

/************************************
The Simple Linear Regression Model
*************************************

Let's examine the simple linear regression model. 

Y = β_0 + ( β_1 * X ) + ε
This equation characterizes the relationship between 
the response variable and the predictor variable. 

The equation for a line is y = mx + b, 
where m is the slope and b is the y-intercept. 
This is where the linear regression equation comes from
— because the regression line is a line, too. 


So, in the linear regression equation, Y is the response variable, 
which in this case is Oxygen_Consumption. 

X is the predictor variable, which is RunTime. 

β_0 is the intercept parameter, which corresponds 
to the value of the response variable when the predictor is 0. 
In other words, this is where the regression line crosses the Y-axis. 

β_1 is the slope parameter, which is the average change in Y 
for a 1-unit change in X. 

ε is the error term representing the variation of Y around the line. 
The regression line is the mean of Y (at any given X), which equals β_0 + β_1 * X.

Now you try. Which variable is the response variable? 
Maximum_Pulse is Y, the response variable. 
The predictor variable Age is X. 

Where is the y-intercept? 
β_0 is the intercept parameter, which is 
where the regression line crosses the Y-axis. 
β_1 is the slope of the line.
*/

/*
How SAS Performs Linear Regression

Remember that one of your goals in simple linear regression 
is to characterize the relationship between 
the response and predictor variable in your population. 
To do this, you begin with a sample of data. 

From this sample, you estimate the unknown population parameters β_0 and β_1, 
which define the assumed relationship between your response and predictor variables. 
Based on your data, SAS calculates estimates of β_0 and β_1 
to determine the line that is as close as possible to all the data points. 
To do so, SAS uses the method of least squares. 
Specifically, this method provides the estimates by determining 
the line that minimizes the sum of the squared vertical distances 
between the data points and the fitted line. 
The estimated parameters are: β^_0 and β^_1. 

The method of least squares produces parameter estimates 
with certain optimum properties. 
If the assumptions of simple linear regression are valid, 
β^_0 and β^_1 are unbiased estimates of the population parameters 
and have minimum variance. 

The least squares estimators are often called BLUE (Best Linear Unbiased Estimators). 
The term best refers to the property of minimum variance. 
For a good representative sample, the estimated parameters β^_0 and β^_1 
should closely approximate the true population parameters β_0 and β_1. 
In turn, the fitted regression line should closely approximate the relationship 
between the response and the predictor variables in the population.
*/

/*
Scenario: Measuring How Well a Model Fits the Data

You've seen how the simple linear regression model fits the data. 
But can you measure how well it fits the data? 

In other words, how much better is the model 
that takes the predictor variable into account 
than a model that ignores the predictor variable [Y = mean(Y)]? 

To find out, you can compare the simple linear regression model to a baseline model.

Comparing the Regression Model to a Baseline Model

Here's a scatter plot of the Fitness data with a baseline model drawn through the plot. 
The slope of this line is 0, and the y-intercept is the sample mean of Y, which is Y-bar. 

In a baseline model, the X and Y variables are assumed to have no relationship. 
This means that for predicting values of the response variable, 
the mean of the response, Y-bar, does not depend on the values of the X variable. 

To determine whether a simple linear regression model is better than the baseline model, 
you compare the explained variability to the unexplained variability. 
To be the better model, the simple linear regression model must explain 
significantly more variability than the baseline model does. 

For your comparison, you calculate: the explained, unexplained, and total variability 
in the simple linear regression model. 
Of course, your software does this for you. But let's go through the calculations in detail. 

The explained variability is the difference between the regression line 
and the mean of the response variable. 
For each data point, you calculate this difference, 
which equals Y^_i minus Y-bar. 
To get rid of negative distances, you square each of these values. 
Then you add these squared values to get the model sum of squares, or SSM. 
The model sum of squares is the amount of variability that your model explains. 

The unexplained variability is the difference 
between the observed values and the regression line. 
For each data point, you calculate Y_i minus Y^_i 
and square the difference. 
Then you add these squared values to get the error sum of squares, or SSE. 
The error sum of squares is the amount of variability that your model fails to explain. 

The total variability is the difference between the observed values (Y_i)
and the mean of the response variable (Y-bar). 
For each data point, you calculate Yi minus Y-bar and square the difference. 
Then you add these squared values to get the corrected total sum of squares. 
The corrected total sum of squares is the sum of 
the explained and unexplained variability in your model, or SSM+SSE.
 */

/*
Hypothesis Testing for Linear Regression

Now let's think about hypothesis testing for simple linear regression. 

The null hypothesis is that the regression model does not fit the data better 
than the baseline model. 

Do you remember the slope of the regression line in the baseline model? 
The baseline model has a slope of 0. 
So, in the null hypothesis, the slope of the regression line is 0 
or the parameter estimate (β_1) of the predictor variable is 0. 
H0: β_1 = 0

The alternative hypothesis is that the regression model 
does fit the data better than the baseline model. 
In other words, the slope of the regression line is not equal to 0, 
or the parameter estimate of the predictor variable is not equal to 0.
Ha: β_1 <> 0
*/

/*
Assumptions of Simple Linear Regression

For a simple linear regression analysis to be valid, 
four assumptions need to be met. 
These assumptions underlie the hypothesis test for the regression model. 
How is that? To calculate a p-value, which is a probability, 
you have to assume a probability distribution. 
So, these assumptions are about the probability distribution in linear regression.

1. The first assumption is that the mean of the response variable 
is linearly related to the value of the predictor variable. 
In other words, a straight line connects 
the means of the response variable 
at each value of the predictor variable.

The next three assumptions are the same as for ANOVA: 

2. The error terms are normally distributed with a mean of 0.
3. The error terms have equal variances.
4. The error terms are independent at each value of the predictor variable.
For now, just keep these assumptions in mind as you learn 
how to perform simple linear regression. 
Later you'll see how to verify the assumptions.
*/

/*
The REG Procedure: Performing Simple Linear Regression

To fit regression models to your data, you use the REG procedure. 
Here's the basic syntax for a PROC REG step to perform a simple linear regression analysis.
	PROC REG DATA=SAS-data-set <options>;
	  MODEL dependent-regressor <options>;
	  WITH variable(s);
	  ID variable(s);
	RUN; 

As usual, the PROC REG statement specifies the data set and options for the procedure. 
The MODEL statement specifies the model you are analyzing. 
In the MODEL statement, you specify the response (or dependent) variable, 
an equal sign, and then the predictor (or regressor) variable. 
Notice that PROC REG supports RUN-group processing. 

Here's a question: 
What type of variables must the response and predictor variables be? 
Remember—they must be continuous. 

Here's the PROC REG step for your linear regression. 
*/
proc reg data=statdata.fitness;
   
   /*specify response (or dependent) variable = predictor (or regressor) variable*/	
   model Oxygen_Consumption = RunTime;
   
   title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
title;
/*
The PROC REG statement specifies Statdata.Fitness as the data set. 
The MODEL statement specifies 
Oxygen_Consumption as the response variable 
and RunTime as the predictor variable.
*/

/* Results:
First, notice that the number of observations read 
and the number of observations used are the same, 
indicating that SAS detected no missing values for Oxygen_Consumption and RunTime. 

Next, the Analysis of Variance table displays the variability 
observed in the response and the variability explained by the regression line. 

The Source column indicates the source of variability. 
Model is the between-group variability that your model explains. 
Error is the within-group variability that your model does not explain. 
Corrected Total is the total variability in the response. 

The DF column indicates the degrees of freedom associated with each source of variability.
What does this mean? 
You can think of degrees of freedom as the number of independent pieces of information 
for each source.
The model DF is 1 because the model has one continuous predictor term, 
so we are estimating one parameter, β_1.

The corrected total DF is n-1 (n minus the intercept), so it is 31-1, which is 30.

The error DF is what is left over. 
It is the difference between the total DF, 30, and the model DF, 1, which is 29.


The Sum of Squares column indicates the amount of variability associated with each source of variability.
The Model Sum of Squares is 633.01. This is the amount of variability that the model explains.
The Error Sum of Squares is 218.54. This is the amount of variability that the model does not explain.
The Total Sum of Squares is 851.55, which is the total amount of variability in the response.
The Mean Square column indicates the ratio of the sum of squares and the degrees of freedom.
The mean square model is 633.01. This is calculated by dividing the model sum of squares by the model DF, which gives us the average sum of squares for the model.
The mean square error is 7.54, which is an estimate of the population variance. This is calculated by dividing the error sum of squares by the error DF, which gives us the average sum of squares for the error.
The F value is the ratio of the mean square for the model and the mean square for the error. This ratio compares the variability that the regression line explains to the variability that the regression line doesn't explain. Here the F value is 84.0, calculated by dividing the mean square model by the mean square error. The corresponding p-value is less than .0001. Remember that we are testing the null hypothesis that β1 is equal to 0. If true, this hypothesis would mean that the model taking RunTime into account isn't any better than the baseline model. 

Now look at the p-value and answer this question: should we reject the null hypothesis? Because the p-value is less than .05, we would reject the null hypothesis and say that our model fits the data better than the baseline model does. In other words, RunTime does explain a significant amount of variability in Oxygen_Consumption. 

The third part of the PROC REG output displays summary measures of fit for the model.
The Root MSE is 2.75. This is the square root of the mean square error in the Analysis of Variance table. The Root MSE is a measure of the standard deviation of Oxygen_Consumption at each value of RunTime.
The Dependent Mean is 47.38, which is the average of Oxygen_Consumption for all 31 subjects.
The Coefficient of Variation is 5.79. This is the size of the standard deviation relative to the mean.
The R-square value is .743, which is calculated by dividing the mean square for the model by the total sum of squares. The R-square value is between 0 and 1 and measures the proportion of variation observed in the response that the regression line explains.
Here's another question. What percentage of the variation in Oxygen_Consumption does the model explain? Approximately 74%. 

The Adjusted R-square is useful in multiple regression. You'll learn about it later, when you perform multiple regression. 

The Parameter Estimates table defines the model for your data. Whereas the Analysis of Variance table provides the overall fit for the model, the Parameter Estimates table provides separate estimates and significance tests for each model parameter.
The parameter estimate for the intercept, β0, is 82.42. This is the estimated value of Oxygen_Consumption when RunTime is equal to 0.
The parameter estimate for RunTime, β1, is –3.31. If RunTime increases by 1 unit, Oxygen_Consumption decreases, on average, by this amount.
The standard errors for the intercept and RunTime are measures of how variable the estimates would be if you resampled. We are interested in determining whether a relationship exists between RunTime, the X variable, and Oxygen_Consumption, the Y variable, so we want to look at the p-value for RunTime. The significance test for RunTime tests whether β1 is equal to 0. Because the model specifies only one predictor variable, the p-value for RunTime is the same as the p-value for the overall test.
Now try answering this question: Given the p-value for RunTime, is it statistically significant in predicting Oxygen_Consumption? Because the p-value for RunTime is less than .05, RunTime is statistically significant in predicting, or explaining the variability of, Oxygen_Consumption. In other words, -3.31 is far enough from 0 that it probably didn't occur by chance. 

Finally, let's enter our results into the equation for simple linear regression. The Y variable, Oxygen_Consumption, equals the intercept, 82.42, plus – 3.31 times the X variable, RunTime. So this is the estimated regression equation. The model indicates that an increase of one unit for Runtime amounts to a 3.31085 decrease in Oxygen_Consumption. However, this equation applies only in the range of values that you observed for the variable RunTime. 

The Parameter Estimates table also shows that the intercept parameter is not equal to 0. However, the test for the intercept parameter has practical significance only when the range of values for the predictor variable includes 0. In this example, the test doesn't have practical significance because the range of observed values doesn't include RunTime=0. 

That's it for now. We'll look at the graphical part of the output in the next demonstration.
*/
