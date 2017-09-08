/*
 * Lab 2.3: Comparing Group Means with One-Way ANOVA
 * 			- using PROC GLM to analyze group means
 *
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
A way to test for differences in means when you have two or more groups 
is analysis of variance, or ANOVA. 

With ANOVA, you have a continuous response variable 
and at least one categorical predictor variable, 
which can have multiple levels, 
and you can use PROC GLM to analyze your data.

Your goal is to determine whether the differences in means are significant, 
and if they are significant, 
which specific groups differ from each other. 
*/

/*
Example:
It's time to learn about growing garlic. 
The farmers at the Montana Gourmet Garlic ranch want to know 
if the type of fertilizer they use affects the average bulb weight 
of their organic garlic, so they design an experiment. 

They test three different organic fertilizers 
and one chemical fertilizer, which is the control. 

They blind themselves to the fertilizers by numbering the fertilizer containers 1 through 4. 
They use 32 beds of garlic within the total one acre farm, 
and then randomly assign fertilizers to the beds. 

Then they calculate the average weight of garlic bulbs in each of the beds. 

Here's a question. What do you think the response and predictor variables are in this scenario? 
Bulb weight is the response variable and fertilizer, which includes four levels 
to represent the four fertilizers, is the predictor variable. 

You want to set up a one-way ANOVA to test the effects of the four fertilizers 
on the average garlic bulb weight. 

Can you identify the null hypothesis? 
The null hypothesis is that the mean bulb weights for each of the fertilizers 
are equal: μ1=μ2=μ3=μ4. 
The alternative hypothesis is that the mean bulb weight for at least one fertilizer 
is different than the others.
 */


/* 1. Examining Descriptive Statistics across Groups */
proc print data=statdata.mggarlic (obs=10);
   title "Partial Listing of Garlic Data";
run;

/*
You can see the Fertilizer variable, which represents the type of fertilizer, 
the BulbWt variable, which represents the average garlic bulb weight in pounds in the bed, 
the Cloves variable, which we will not use, 
and the BedID variable, which is a randomly assigned bed identification number.
 */

/*calculate descriptive statistics for BulbWt for each type of Fertilizer*/
proc means data=statdata.mggarlic printalltypes maxdec=3;
							      /*specify printalltypes to display the means 
							        for the overall bulb weight 
							        and the means of bulb weight by fertilizer*/
   var BulbWt;
   class Fertilizer;
   title 'Descriptive Statistics of Garlic Weight';
run;
/*
The mean bulb weight for all 32 beds of garlic is 0.219 pounds with a standard deviation of 0.029. 

Look at the breakdown of the means for the different fertilizers. 
Which fertilizer has the highest mean? 
Fertilizer 3 has the highest mean at 0.23, though its mean is fairly close to fertilizers 1 and 2. 

When you look at the number of observations for each fertilizer, what stands out to you? 
You should recognize that this design is not balanced. 
In other words, the groups are not equally sized. 
Fertilizer 4 has the least number of observations. 

It also appears just by looking at these statistics that fertilizer 4 
has the lowest mean and the largest variability. 
 */


/*create box plots for each Fertilizer*/
proc sgplot data=statdata.mggarlic;
   vbox BulbWt / category=Fertilizer datalabel=BedID;
   				 /*CATEGORY option produces separate box and whisker plots 
   				   for each level of Fertilizer.*/
   				 /*DATALABEL option identifies potential outliers 
   				   with the variable BedID.*/ 
   format BedID 5.;
   title 'Box Plots of Garlic Weight';
run;
title;
/*
These box plots show us graphically what we saw in the table of statistics. 
You can see how the means, represented by the diamonds, for the four fertilizer types 
compare to one another.

Notice that the plot for fertilizer 4 reinforces what we saw with PROC MEANS: 
it has the lowest mean and the most variability. 

What was our original question? 
Are the bulb weight means for the four different fertilizers statistically different 
from one another? 
You might have a hunch at this point, but let's use ANOVA to find the answer.
 */


/* 2. Comparing Group Means with One-Way ANOVA */

/*Using PROC GLM to analyze group means */
/*
PROC GLM fits a general linear model, of which ANOVA is a special case. 
PROC GLM also displays the sums of squares associated with each hypothesis it tests. 
 */

proc glm data=statdata.mggarlic plots(only)=diagnostics(unpack);
								/*use PLOTS= option and specify ONLY 
								  to suppress the default plots */
								/*request diagnostics plots and specify UNPACK -
								  SAS puts each plot on a separate page
								    (otherwise, you will see all of the plots 
								    in a grid or panel display)*/ 
   
   /*specify the classification variable (predictor variable) for the analysis*/
   class Fertilizer;
   
   /*specify the variables for MODEL -> dependent-variables=independent-effects*/
   model BulbWt=Fertilizer;
   
   /*MEANS statement computes unadjusted means, or arithmetic means, of the dependent variable BulbWt 
     for each value of the specified effect*/
   /*compute the average bulb weight for each type of fertilizer*/ 
   means Fertilizer / hovtest;
   					/*use the MEANS statement to test the assumption of equal variances*/
   					/*add the HOVTEST option, which is the homogeneity 
   					  of variance test option*/
   					/*This option performs Levene's test for homogeneity of variances by default.
   					  If the resulting p-value of Levene's test is greater than some critical value, 
   					  typically 0.05, you fail to reject the null hypothesis of equal variances.*/ 
 	  
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
title;


/*Verify your analysis of variance three assumptions

1. The first ANOVA assumption is satisfied because fertilizers 
were randomly assigned to plots in an appropriate manner.

2. Use diagnostic plots of the residuals in PROC GLM 
to verify the assumption that the errors are normally distributed.

3. Use Levene's test for homogeneity in PROC GLM 
to verify that the variances are equal across the fertilizers.

The GLM procedure also produces a plot of residuals versus 
their predicted values, the group means,
to visually verify the equal variance assumption.*/

/*
SAS provides everything we need to verify our ANOVA assumptions 
and the ANOVA test results. 

It's a good idea to check our assumptions first, but that means 
we have to examine the output in a slightly different order.

The Class Level Information table specifies the number of levels, 
the values of the class variable, and the number of observations SAS read. 
If any row has missing data for a predictor or response variable, 
SAS drops that row from the analysis.  

You assume that the farmers did a good job at sampling garlic bulbs to weigh 
by randomly selecting them, so you assume that the observations 
are independent and check that off your list. 

To verify if the variances are equal across fertilizers, 
you can first examine the Residuals by Predicted plot. 
This plot helps you to see graphically if the equal variance assumption has been met. 
You don't want to see any patterns or trends, but rather, 
you want to see a random scatter of residuals above and below 0 
for the four fertilizer groups. The plot looks good. 

You can examine Levene's test for homogeneity 
to more formally test the equal variance assumption. 
You don't want to reject the null 
because that would be rejecting one of your assumptions, 
so you want a large p-value for this test. 
Because the p-value of 0.4173 is greater than 0.05, 
you fail to reject the null and conclude that the variances are equal. 
This is good. You verified the equal variance assumption. 

To verify the assumption of the errors being normally distributed, 
you check the normal probability plot and histogram of the residuals. 
Because the residuals follow the diagonal reference line fairly closely, 
you can say that they are approximately normal. 
The histogram of residuals looks approximately normal as well. 
It has no unique peak and it has short tails, but it's approximately symmetric, 
so you verify the assumption that the error terms are normally distributed. 


Now you can look at the ANOVA table and feel comfortable interpreting your p-value. 

This is the ANOVA output from PROC GLM. 

First you see the overall ANOVA table. 
The first column is information about the Degrees of Freedom. 
You can think of Degrees of Freedom as the number of independent pieces of information, 
or the number of values in the final calculation of a statistic that are free to vary. 

The next column is information about the sum of squares. 
The model sum of squares (SSM) is 0.00458, 
the error sum of squares (SSE) is 0.0218, 
and the total sum of squares (SST) is 0.0264. 

The mean square model (MSM) is 0.0015. 
SAS calculates this by dividing the model sum of squares (SMM)
by the model Degrees of Freedom (Model DF), 
which gives you the average sum of squares for the model. 

The mean square error (MSE) is 0.00078, which is an estimate of the population variance. 
SAS calculates this by dividing the error sum of squares (SSE)
by the Error Degrees of Freedom (Error DF), 
which gives you the average sum of squares for the error. 

SAS calculates the F-statistic by dividing the MSM by the MSE. 
The F statistic is 1.96. 

Because the corresponding p-value of .1432 is greater than 0.05, 
you can conclude that there is not a statistically significant difference 
between the mean bulb weights for the four fertilizers. 

Remember, you are testing if the means for the four fertilizer types are equal, 
so you fail to reject the null. 


At this point, it's important for you to realize that the one-way ANOVA 
is an omnibus test statistic and cannot tell you 
which specific groups are significantly different from each other, 
only that at least two groups are different. 

To determine which specific groups differ from each other, 
you need to use a post-hoc test. 


The next table contains the R-Square, 
which is the proportion of variance in the response accounted for by the model. 
The R-square is between 0 and 1. 
It's close to 0 if the independent variables do not explain much variability in the data, 
and it's close to 1 if the independent variables explain 
a relatively large proportion of the variability in the data. 
This R-Square is 0.1734, so approximately 17% of the variation in bulb weight 
can be explained by fertilizer. 
Fertilizer doesn't explain much of our variability. Interesting.   


The coefficient of variation expresses the root MSE 
as a percentage of the mean bulb weight. 
It is a unit-less measure that is useful in comparing the variability 
of two sets of data with different units of measure. 

The Root MSE is the estimate of the standard deviation of bulb weights for all fertilizers.
 
The BulbWt Mean is the mean of all of the data values in the variable BulbWt 
without regard to Fertilizer. 


Now let's look at information about our class variable in the model, Fertilizer. 
When you have one predictor variable in an ANOVA model, 
the breakdown of the variable in this table is the same 
as the model line in the overall ANOVA table 
and the information for Type I and Type III sums of squares is the same. 


All in all, the PROC GLM output supports your conclusion 
that there's not a statistically significant difference between 
the mean bulb weights for the four fertilizers.
 */