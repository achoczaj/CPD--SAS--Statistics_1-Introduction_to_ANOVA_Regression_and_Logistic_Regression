/*
 * Lab 3.2: Using PROC CORR to Produce Correlation Statistics and Scatter Plots
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Now let's see how you use SAS to perform exploratory data analysis 
on the Fitness data. 
To produce correlation statistics and scatter plots for your data, 
you can use the CORR procedure. 
PROC CORR produces tables of variable information, 
simple descriptive statistics, and correlation statistics, 
including Pearson correlation coefficients and corresponding p-values. 

PROC CORR also produces scatter plots or a scatter plot matrix. 
Let's start with correlations, where the code is simpler. 
You'll learn about producing scatter plots in a minute. 

Here's the syntax for a PROC CORR step for producing correlations. 
	PROC CORR DATA=SAS-data-set <options>;
	  VAR variable(s);
	  WITH variable(s);
	RUN;

The PROC CORR statement specifies the CORR procedure, 
and the DATA= option specifies the SAS data set that you want to analyze. 
The VAR statement specifies the continuous variables 
that you want to produce correlations for. 
By default, SAS produces correlations for each pair of variables in the VAR statement.

But maybe you prefer to specify the correlations you want. 
In that case, you can add a WITH statement 
to correlate each variable in the VAR statement 
with all variables in the WITH statement. 

	PROC CORR DATA=SAS-data-set <options>;
	  VAR X1 X2;
	  WITH Y1;
	RUN;
Suppose you specify X1 and X2 in the VAR statement 
and Y1 in the WITH statement. 
Now what correlations do you produce? 
You correlate X1 with Y1 and X2 with Y1. 


Below is the PROC CORR step you need to calculate 
correlation coefficients for Oxygen_Consumption 
with each of the predictor variables. 
*/

proc corr data=statdata.fitness; 
   /*specify the continuous predictor variables*/
   var RunTime Age Weight Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   /*specify the continuous response variable*/
   with Oxygen_Consumption;
   
   title "Correlations with Oxygen_Consumption";   
run;
title;
/*
The PROC CORR statement specifies Statdata.Fitness as the SAS data set to read. 

The VAR statement specifies the continuous variables 
other than Oxygen_Consumption, 
and the WITH statement specifies Oxygen_Consumption. 
*/

/*
You should examine the general features of your data before exploratory data analysis, 
so we'll start by looking at properties of the Fitness data.

First, we'll select Libraries in the Explorer window and open the Statdata library. 
Then we right-click the Fitness data set and select View Columns. 
The numeric columns here are the continuous variables you're interested in. 

Now we'll open the data set and become familiar with the data values. 
Of course, you could also do this by submitting a PROC PRINT step. 

You should also investigate the univariate statistics of continuous variables 
in the data set by using PROC MEANS, PROC UNIVARIATE, and PROC SGPLOT 
to explore distributions, measure central tendency and spread, 
and look for outliers. 

But right now we'll focus on using PROC CORR. 
Remember that we want to determine whether a linear relationship 
exists between the response variable Oxygen_Consumption 
and any of the predictor variables. 

We'll also produce scatter plots to visually assess 
whether relationships exist between any of the variables. 

To rank-order the absolute value of the correlations from highest to lowest, 
you can add the RANK option to the PROC CORR statement. 
When you run this code in SAS, you can determine whether there is a linear relationship between Oxygen_Consumption and the predictor variables. But first let's see how you add scatter plots to your PROC CORR results. Remember—plot your data! 

To produce scatter plots using PROC CORR, you add the PLOTS= option 
in the PROC CORR statement. 
The PLOTS= option specifies the type of plot to produce. 
PLOTS=MATRIX displays a scatter plot matrix, 
whereas PLOTS=SCATTER displays individual scatter plots for pairs of variables. 
When you request a scatter plot or a scatter plot matrix, 
SAS also displays the Pearson correlations with the plot. 
For now, let's specify PLOTS=SCATTER to request individual scatter plots. 
You can also add context-specific options in parentheses 
following the main option keyword, such as PLOTS or SCATTER. 
For example, the global plot option ONLY suppresses the default plots, 
so that only plots that you specifically request are displayed. 
You add this plot option after PLOTS. 

After the keyword SCATTER, let's add two more options. 
NVAR=ALL specifies that all the variables listed in the VAR statement 
be displayed in the plots. 
ELLIPSE=NONE turns off prediction ellipses on plots. 

Now you're ready to perform both steps in exploratory data analysis: 
viewing the relationship between pairs of variables, 
and measuring the degree and type of linear association 
between pairs of variables.

Here's the code that you saw before. 

We'll specify the Journal style to create high-quality grayscale graphs 
that print nicely. Let's submit the code.
*/

proc corr data=statdata.fitness rank
     plots(only)=scatter(nvar=all ellipse=none);
   
   /*specify the continuous predictor variables*/
   var RunTime Age Weight Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   /*specify the continuous response variable*/
   with Oxygen_Consumption;
   
   title "Correlations and Scatter Plots with Oxygen_Consumption";
run;
title;

/*
Now let's go through your PROC CORR results. 
The first part of the PROC CORR results is tabular output. 

By default, PROC CORR generates a list of the variables that were analyzed. 
Then it displays descriptive statistics for each variable, 
including the mean, standard deviation, 
and minimum and maximum values. 


In the next table 'Pearson Correlation Coefficients ...'
PROC CORR gives the correlation coefficients and p-values 
for the correlations of Oxygen_Consumption with each of the predictor variables. 

Here's a question: What's the Pearson correlation coefficient 
for the correlation of Oxygen_Consumption with RunTime? 
It's -.86219. 
What is the p-value for the correlation of Oxygen_Consumption with Performance? 
It's less than .0001. 

Remember that the p-values are testing the null hypothesis 
H_0: ρ=0 and the alternative hypothesis Ha: ρ≠0. 
The null hypothesis states that the true correlation coefficient is equal to 0, 
meaning there is no linear relationship between the variables. 
The alternative hypothesis states that 
the true correlation coefficient is not equal to 0, 
meaning there is a linear relationship between the variables. 

The correlation coefficient for Oxygen_Consumption versus Runtime is -.86219, 
and the p-value is very small. 
The correlation coefficient for Oxygen_Consumption versus Performance is also high at .7789, 
with a very small p-value as well. 
The high correlations indicate strong relationships between Oxygen_Consumption and each of the two variables. 

Try this question: 
For these two correlations, would you reject the null hypothesis or not? 
Since the p-values are so small, you would reject H_0: in both cases 
and say that there is a linear relationship between Oxygen_Consumption 
and each of the two predictors. 
So, this output tells us that RunTime and Performance may be good predictors for Oxygen_Consumption. 

You need to be careful with these other p-values. 
Even though no linear relationship exists between two variables with a low p-value, 
such as Oxygen_Consumption and Weight, 
some other type of relationship might exist, such as a curvilinear relationship. 


Now let's go through the scatter plots associated with the correlations. 
Here's the scatter plot for Oxygen_Consumption versus RunTime. 
What type of relationship do you see? 
A strong, negative linear relationship exists between these two variables. 
You already saw that the correlation coefficient of -.86219 indicated this type of relationship. 

Next, what type of relationship do you see for Oxygen_Consumption versus Age? 
No clear relationship exists between these two variables. 

How about for Oxygen_Consumption versus Weight? 
Again, no clear relationship exists between these two variables. 

Oxygen_Consumption does show some correlation with Run_Pulse and Rest_Pulse. 
How about for Oxygen_Consumption versus Maximum_Pulse? 
No clear relationship exists between these two variables. 
However, the scatter plot for Oxygen_Consumption versus Performance does show a relationship. 
What kind of relationship do you see here? 
A strong, positive linear relationship exists between these two variables, 
as the correlation coefficient .77890 indicated.

Overall, the correlation and scatter plot analyses indicated 
that several variables might be good predictors 
for Oxygen_Consumption--in particular, RunTime and Performance.