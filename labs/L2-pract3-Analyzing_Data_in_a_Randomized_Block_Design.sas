/*
 * Practice 3: Analyzing Data in a Randomized Block Design
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
You performed a study on four types of advertising: 
local newspaper ads, local radio ads, in-store salespeople, and in-store displays. 
Because you were concerned that there was variability caused by the areas of the country, 
you randomly assigned each type of advertising to 36 locations across the U.S. 
You measured the level of sales in each region in thousands of dollars. 
You wanted to know whether the average sales were significantly different for these advertising types.

You now decide that you're not particularly concerned with the differences 
caused by the area of the country, but you are interested in isolating the variability due to this factor.

The data set Statdata.Ads1 contains data for the variable Ad, which represents the type of advertising, 
the variable Area, which represents the area of the country, 
and the variable Sales, which represents the level of sales in thousands of dollars.
Reminder: Make sure you've defined the Statdata library.

1. Write a program to test the hypothesis that the means are equal. 
Include all of the variables in your MODEL statement. 
Add an appropriate title and submit the code.
2. What can you conclude from your analysis? 
Did adding the blocking variable Area into the design and analysis 
explain more of the variability and increase the precision of the affect of the treatment?
*/

/* 1.*/
/* 1.1 Identifying Your Data */
proc print data=Statdata.Ads1 (obs=10);
   title "Partial Listing of Ads Data";
run;
/*
 * variable Ad is the categorical grouping variable with 4 values: paper, radio, people, display 
 * variable Area is the categorical grouping variable with 36 values (locations across the U.S.)
 *   
 * variable Sales, which represents the change in grammar test scores, 
 * is the continuous variable that you want to analyze
 */

/* 2. Comparing Group Means with ANOVA */

/*enable ODS Graphics before requesting plots*/
ods graphics on;

/*Using PROC GLM to analyze the randomized block design of the garlic data*/
proc glm data=statdata.ads1 
		plots(only)=diagnostics(unpack);
   
   /*specify the classification variables (predictor variables) for the analysis*/
   class Ad Area;
   
   /*specify the variables for MODEL -> dependent-variables=independent-effects*/
   model Sales = Ad Area;
   
   		  
   title 'ANOVA for Randomized Block Design';
run;
quit;
title;



/*
What can you conclude from your analysis? 
Did adding the blocking variable Area into the design and analysis 
explain more of the variability 
and increase the precision of the affect of the treatment?

I assume the observations are independent.

The Q-Q Plot of Residuals plot indicates 
that the normality assumption for ANOVA is met.

Residuals by Predicted plot looks good and indicates
that the variances are equal across each treatment and block combination


The overall F test, where F=8.43 and p=0.0001 (is smaller than 0.05), 
indicates that there are significant differences in Sales 
among the advertising campaign types when controlling for Area. 

However, because both 'Ad' and 'Area' variables are in the model,
you can't tell if the differences are due to differences
among the type of Ad or just differences across Areas.
To determine this, you generally use the Type III SS, 

What have you gained by including Area in the model?
If you compare this MSE, which is 89.73916, 
to the MSE in the model that included Ads only, 145.02302, 
you see that it decreased.
The mean square error (MSE) is an estimate of the population variance.

The drop in the MSE indicates that by adding the blocking factor 'Area', 
you were able to account for a bit more of the unexplained variability 
due to the nuisance factors.

Also notice that the R-square for this model is much greater 
than that in the previous model without the blocking factor: 0.578211 versus 0.224159.
To some degree, this is a function of just having more model degrees of freedom, 
but it's unlikely that this is the only reason for this magnitude of difference.

The Type III SS test at the bottom of the output 
tests for differences due to each variable, 
controlling for or adjusting for the other variable.

F-value for 'Ad' is 21.79 and the corresponding p-value is <.0001, 
and this is significant at the 0.05 level. So what can you conclude?
You can conclude that at least one of the type of ads is different 
for sales results from the others. This is great news.

How about the blocking variable 'Area'? 
F-value for 'Area' is 6.07 and the corresponding p-value is <.0001   
is statistically significant at the 0.05 level
and gives evidence that the area of the country 
was a useful factor on which to block. 

It explains a significant amount of the variability, 
and helps improve the model.

