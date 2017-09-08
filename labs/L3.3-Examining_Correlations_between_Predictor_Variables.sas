/*
 * Lab 3.3: Examining Correlations between Predictor Variables
 *
 * Lesson 3: Regression
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
But before you perform a regression analysis, it's also a good idea 
to examine the correlations between the potential predictor variables. 
Let's see how you use PROC CORR to produce a correlation matrix 
and scatter plot matrix, which help you compare the relationships 
between predictor variables. 

The basic syntax for the PROC CORR step is the same as before. 
However, to produce the correlation matrix and scatter plot matrix, 
you need to specify different options in the PROC CORR statement. 

First, you can remove the RANK option, to keep the correlation matrix easy to read. 
You can also add the NOSIMPLE option, 
which suppresses printing of the simple descriptive statistics for each variable. 

Then you can change PLOTS=SCATTER to PLOTS=MATRIX 
to produce the scatter plot matrix instead of individual scatter plots. 

You can also replace ELLIPSE=NONE with HISTOGRAM, 
which displays histograms of the variables in the VAR statement 
along the diagonal of the scatter plot matrix. 
Notice that you don't need the WITH statement in this case. 


Now suppose that in your scatter plot matrix, 
you want to be able to hover over data points 
and see tooltips containing detailed information about the observations. 
To specify this tooltip feature, you add two SAS language elements. 

The first is the IMAGEMAP=ON option after a slash in the ODS GRAPHICS statement. 
This option enables the tooltip feature. 

The second is an ID statement that specifies the variable 
whose value you want to see in the tooltip.
 
In PROC CORR, the information in the tooltips includes 
the value of the X-axis and Y-axis variables, the observation number, 
and the value of any variable in the ID statement.
 
In this case, let's say you want to see the subject's name, 
so you specify Name in the ID statement. 
The tooltip features applies only to HTML output.

Submit the revised program and view the correlation matrix 
and the scatter plot matrix.
*/

ods graphics on / imagemap=on;

proc corr data=statdata.fitness nosimple
     plots=matrix(nvar=all histogram); 
   
   /*specify the continuous predictor variables*/
   var RunTime Age Weight Run_Pulse
       Rest_Pulse Maximum_Pulse Performance;
   /*specify the variable whose value you want to see in the tooltip*/
   id name;
   
   title "Correlation Matrix and Scatter Plot Matrix of Fitness Predictors";
run;
title;

/*Results:
Notice that the variables are still listed, but the table of simple statistics 
is gone because we specified the NOSIMPLE option in the PROC CORR statement. 

The correlation matrix replaces the previous table of Pearson correlation statistics, 
and the scatter plot matrix replaces the individual scatter plots.

Let's start with the correlation matrix, which displays 
the Pearson correlation coefficients for all pairs of variables. 
The upper and lower triangles of the matrix contain the same information. 
Looking at one of these triangles, answer this question: 
What are the two highest Pearson correlation coefficients? 
The strongest association is between Run_Pulse and Maximum_Pulse, 
with a correlation coefficient of .92975. 
RunTime and Performance also have a strong correlation of -.82049. 

You can prepare a correlation table which summarizes the correlation analysis 
of the independent variables. 
It selects the highest correlations from the correlation matrix, 
based on choosing small p-values. 
The pairs of correlated variables appear in descending order 
of the absolute value of the correlation.


The scatter plot matrix plots the relationships between the pairs of variables. 
It also displays a histogram for each variable so you can see their distributions. 
Answer this question. 
Why would you look at histograms of predictor variables? 
The histograms enable you to explore the data. 
Normality of the X variables is not an assumption in regression, 
so there is no need to make sure the predictor variables have normal distributions. 

Looking at only the left side of the scatter plot matrix, 
can you find the plot that shows a positive linear relationship? 
Run_Pulse and Maximum_Pulse have a strong, positive linear relationship. 

Which two plots show a negative linear relationship? 
RunTime and Performance have a strong, negative linear relationship. 
Age and Performance have a fairly strong, negative linear relationship. 

For now, that's all you need to learn from the scatter plot matrix. 
Later, when you work with multiple regression and regression diagnostics, 
this information about strongly correlated predictor variables becomes more useful.
*/