/*
 * Lab 4.1: Producing Default Diagnostic Plots Using PROC REG
 *
 * Lesson 4: Model Post-Fitting for Inference
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Assumptions for Regression

Let's start by reviewing the four assumptions for regression. 
The first assumption is that the linear model fits the data adequately. 
In other words, the mean of the response variable is linearly related 
to the value of the predictor variable. 

Here's a question: What does linearly related mean? 
It means that a straight line connects the mean of the response variable 
at each value of the predictor variable. 
To make sure that a linear relationship exists, 
you can create a scatter plot of the response (Y) versus the predictor (X). 

Now try this question. 
Are predictor variables assumed to be normally distributed in linear regression models? 

No, the normality of the predictor variables is not an assumption. 
Linear regression assumes that the response (or Y) variable is normally distributed, 
which is a function of the errors. 
So, your concern is whether the errors are normally distributed. 

The other three assumptions relate to errors. 
The second assumption is that the errors are normally distributed 
at each value of the predictor variable. 
The errors have a mean of 0 at each value of the predictor variable. 

The third assumption is that the errors have the same variance 
at each value of the predictor variable. 

The fourth assumption is that the errors are independent 
at each value of the predictor variable. 
Based on the way you collect your data and design your study, 
you should have a good idea whether or not your observations are independent. 

To summarize, errors are assumed to be independent and follow normal distributions. 
These distributions all have the same variability, 
so Y should have equal variances regardless of the value of X.
 */

/*
The Importance of Plotting Your Data and Checking Assumptions

Now let's focus on the first assumption, that the linear model fits the data adequately. 
You already know that it's important to plot your data and check this assumption. 
But in case you're not persuaded, let's look at a famous example 
that shows just how important verifying this assumption is. 
You'll see four plots, each with the same model and R2 statistic, but with different data. 

In the first plot, the data hovers around the regression line, 
so here a regression line adequately describes the data. T
he model is Y-hat equals 3 plus .5X, where 3 is the y-intercept and .5 is the slope. 
In other words, our predicted value of Y equals 3 plus .5X. 
The R2 value is .67, which is the variation of Y that the model explains. 
In the second plot, a simple linear regression model isn't adequate, 
because it doesn't fit the data well. 
The straight line doesn't fit the curvilinear relationship. 
To fit the data better, the model probably needs a squared or quadratic term. 
Notice that the model and R2 value are still the same. 
In the third plot, an outlier affects the fit of the regression line. 
Again, the model and R2 value are the same. 
In the final plot, the outlier dramatically changes the fit of the regression line—
with the same model and R2 value. 
In fact, without the outlier, the slope would be undefined.

These examples should convince you that you can't simply write a PROC REG step 
and magically produce a good model for your data. 
You know the answer to this question: 
What should you do before you produce a model? You should plot your data. 
 */

/*
Verifying Assumptions Using Residual Plots

Now you're probably asking, "How do I verify the assumptions of linear regression?" 
The answer is that you can use the residual values from the regression analysis. 
Remember that residuals are the difference between each observed value of Y 
and its predicted value. Residuals are estimates of the errors, 
so you can plot the residuals to check the assumptions of the errors. 

In this topic, you learn to use several different residual plots 
to check your regression assumptions. 
First, to check for violations of equal variances, you can plot 
residuals versus the predicted values. 
You can also use this plot to check for violations of linearity and independence. 

Second, to further examine any violations of equal variances, 
you can plot the residuals versus the values of the independent variables. 
If you plot the residuals versus X1, versus X2, and so forth, 
ou can see which predictor contributes to the violation of the assumption. 

Third, you can use a histogram or a normal probability plot of the residuals 
to determine whether or not the errors are normally distributed.


Now let's look at some examples of residual plots to determine 
whether any of the linear model assumptions are being violated. 
Here are plots for four different models fit to four different sets of data. 
Each plot has the residual values on the Y axis 
and the predicted values on the X axis. 
Your job is to analyze the shape of the residual values. 
What you want to see is a random scatter of the residual values 
above and below the reference line at 0. 
This indicates that the model assumptions are valid. 
If you see patterns or trends in the residual values, 
the assumptions might not be valid and the models might have problems. 
When you check the plots, just look for obvious violations. 
Don't worry about small details. Ready?

Look at the first graph and answer this question: 
Is any assumption violated in this plot? 
The residuals are randomly scattered around the reference line at 0 
and no patterns appear in the residuals. 
These features indicate that the assumptions of linearity, equal variances, 
and independence are all reasonable. 

Now look at this graph. What assumption is violated in this plot? 
The residual values have a parabolic or curved shape, 
and the model does not fit the data well. 
The linearity assumption is being violated. 
To account for the curvature in the data, the model needs a quadratic term added. 

Look at the third graph. What assumption is violated in this plot? 
The residuals have a funnel shape. 
The variance of the residuals is not constant—as you look from left to right, 
the variance increases. 
The equal variance assumption is being violated. 
The response variable in the model might need some sort of transformation; 
natural log and square root transformations are very common. 

Now look at the final graph. What assumption is violated in this plot? 
The residuals have a cyclical shape. 
The observations are not independent, so the independence assumption is being violated. 
Cyclical patterns such as this can appear when the predictor variable, X, 
is a measure of time. The residuals are autocorrelated, meaning correlated over time. 
More specifically, residuals are more correlated with observations nearer in time 
than with observations further away in time. 
To take autocorrelation into account, you might need to use a regression procedure 
such as PROC AUTOREG. 

For your own data, your graphs probably won't look this dramatic. 
But now you can identify some basic problems.
 */

/*
Detecting Outliers Using Residual Plots

As you just saw, you use residual plots to verify your regression assumptions. 
You can also use them to detect outliers, which often reflect data errors 
or unusual circumstances. 

Outliers can affect your regression results, so you want to know 
whether any outliers are present and causing problems. 

For example, this outlier is far away from the bulk of the data. 
If you notice a large residual or an outlier like this one, 
it's usually associated with an outlying observation. 

You need to investigate outliers to see whether they result 
from data entry error or some other problem that you can correct.
 */
/*
Let's see how you use PROC REG to create residual plots 
and other diagnostic plots. 

We'll use these plots to check our model assumptions 
and to check for outliers. 

First, to assess our model overall, we'll produce the eight default plots for fit diagnostics. 
Here's the PROC REG step we'll use. 

You probably recognize the model as one of the top models for prediction 
that we identified earlier using Mallows' criterion for Cp. 

As before, specifying Name in the ID statement 
hows us the subject's name when we hover over the data points in the graph. 
*/

ods graphics / imagemap=on;

proc reg data=statdata.fitness; 
   PREDICT: model Oxygen_Consumption =
                  RunTime Age Run_Pulse Maximum_Pulse; 
   id Name; 
   title 'PREDICT Model - Plots of Diagnostic Statistics';
run;
quit;

title;

/*
In the output, we'll scroll to the diagnostic plots. 
Notice that key statistics for the model are displayed along with the plots. 

First is the plot of residuals versus predicted values. 
Looking at this plot, we're able to verify the equal variance assumption. 
We can also verify the independence assumption and check the adequacy of the model. 
Remember that we want to see a random scatter, with no patterns, 
of our residuals above and below the 0 reference line. 

The next two plots display Rstudent versus predicted values 
and Rstudent versus leverage values. 
We'll discuss these Rstudent plots in the next topic. 
For now, let's go on to the rest of the plots. 

The residuals versus quantile plot is a normal quantile plot of the residuals. 
Using this plot, we can verify that the errors are normally distributed, 
which is one of our assumptions. 
Here the residuals follow the normal reference line pretty closely, 
so we can conclude that the errors are normally distributed. 

The fifth plot, of Oxygen_Consumption versus predicted values, 
is a plot of the response variable values 
versus the predicted values. 
Patterns in the spread around the 45-degree reference line 
indicate an inadequate model. 
However, the points in this plot look pretty good. 

The next plot, Cook's D versus observation number, 
helps us detect influential observations.
 We'll discuss this type of plot in the next topic. 
 
 In the lower left corner is a histogram plot. 
 A histogram displays a frequency distribution, 
 which you can use to assess the normality of your data. 
 Here the histogram shows the normality of the residuals. 
 Notice that a normal density curve is overlaid on the residual histogram 
 to help detect departures from normality. Here the residuals look pretty normal. 

The last plot is called a residual-fit or RF plot. 
It consists of side-by-side quantile plots of the centered fit and the residuals. 
You should check to see whether the spread of the residuals in the plot 
on the right is greater than the spread of the centered fit in the plot on the left. 
What do you think? 
The spread of the residuals is less than the spread of the centered fit, 
so the model is fine. 


Now let's look at the next set of default plots, 
the plots of the residuals versus each of the predictor variables in the model. 

These plots help us check for model adequacy and equal variances. 
Patterns in these plots indicate an inadequate model. 

Here's a quick question: 
At a glance, do any of these plots show signs of unequal variance? 
No, these plots look pretty good. 
But if any of them showed signs of unequal variance, 
we could determine which predictor variable was involved in the problem.
*/