/*
 * Practice 4: Analyzing Data with ANOVA Post Hoc Pairwise Comparisons
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
You performed a study on four types of advertising: 
local newspaper ads, local radio ads, in-store salespeople, and in-store displays. 

Because you were concerned that there was variability caused by the areas of the country, 
you decided to isolate the variability due to this factor. 

In your results, you concluded that there was a statistically significant difference 
among the means for the advertising types. 
You decide to use the data set Statdata.Ads1 to perform a post hoc test 
and look at the individual differences among means for the advertising types.
Reminder: Make sure you've defined the Statdata library.
1. Write a program to conduct pairwise comparisons with an experimentwise error rate of α = 0.05. 
Use the Tukey adjustment. 
Also, use 'Display' as the control group and perform a Dunnett comparison 
of all other advertising methods 
to see whether those methods improved sales over in-store displays. 
Add an appropriate title, submit the code, and examine the results.
2. Which types of advertising are significantly different?
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

/* 2. Analyzing Data with ANOVA Post Hoc Pairwise Comparisons */

/*enable ODS Graphics before requesting plots*/
ods graphics on;
ods select LSMeans Diff MeanPlot DiffPlot ControlPlot;

/*use the LSMEANS statement in PROC GLM to run multiple comparison tests.*/

proc glm data=statdata.ads1;
   /*specify the classification variables (predictor variables) for the analysis*/
   class Ad Area;
   /*specify the variables for MODEL -> dependent-variables=independent-effects*/
   model Sales=Ad Area;
   
   /*conduct pairwise comparisons with an experimentwise error rate of α = 0.05*/
   /*Tukey method - pairwise differences*/
   lsmeans Ad / pdiff=all adjust=tukey;
   /*Dunnett's method - all others vs. control group*/
   lsmeans Ad / pdiff=controlu('display') adjust=dunnett;
   
   title 'Pairwise Differences for Ad Types on Sales';
run;
quit;
title;



/*
2. Which types of advertising are significantly different?

The Tukey comparisons show significant differences:
- between Display and all other types of advertising (p=<.0001), 
- and between Paper and People (p=0.0190). 

LS-Means plot shows the least squares mean graphically.
Paper has the highest mean, 
but all other types of advertising have higher mean weights 
than the In-Shop-Display ad.

Next, diffogram shows if there is a significant difference between 
any of the pairwise comparisons using Tukey's method.
The blue diagonal line indicates significant differences.


In Dunnett table, you can see that SAS compared 
the all other types of advertising to 'Display', the control mical fertilizer. 
 
Dunnett's method showed that all other advertising campaigns resulted 
in significantly better average sales (statistically different) than Display.
All their p-value=<.0001 are less than alpha (0.05).

The  Control Differences with Dunnett Adj plot (control = 'Display') 
serves to reinforce what you just learned.

Because you performed one-sided, upper-tailed hypothesis tests 
you only see only the upper shaded region with the UDL in your plot.

Remember that the bottom horizontal line is the least squares mean 
of your control group. 

The vertical lines for all other advertising campaigns
extends the UDL. 