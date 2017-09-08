/*
 * Lab 2.4: Comparing Group Means with ANOVA with Blocking
 * 			- using PROC GLM to analyze group means
 *
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*

*/

/*
Example:
In their original study, the Montana Gourmet Garlic farmers randomly assigned 
their fertilizers to plants in each of their 32 beds. 
Given the negative results of their study, meaning that 
there was no statistically significant difference 
between the mean bulb weights for the four fertilizers, 
the farmers consulted a statistician before planning their next study. 

They decide to rigorously control the influences on the growth of garlic. 
Here's a question. Can you think of some possible nuisance factors in the growth of garlic? 
Sun exposure, the pH level of the soil, and rain are examples of possible nuisance factors. 
They likely affect the weight of the garlic bulbs, but they are not the primary concern. 

The statistician suggests ways to account for these nuisance variables in their experimental design. 
Although they can't actually apply the nuisance factors randomly, 
in other words, they can't change the weather or the soil pH or the sun exposure, 
they can control for these factors by blocking. 

He suggests that whatever the effects of the external influences are, 
the magnitudes of the nuisance factors should be approximately the same 
within sectors of the farm land. 
Therefore, instead of randomizing the fertilizer treatment across all 32 beds, 
he suggests that they randomize the application of the four fertilizer treatments 
within each of eight sectors. 
Based on this recommendation, the farmers divide the farm into eight sectors, 
each of which has four beds, 
and in each of the four beds, they randomly assign each of the four fertilizers. 

An experimental design like this is often referred to as a randomized block design. 
As you can see in this ANOVA model 'Sector' is the blocking variable.
*/


/* 1. Examining Descriptive Statistics across Groups */
proc print data=statdata.mggarlic_Block (obs=10);
   title "Partial Listing of redesigned experiment - Garlic Data";
run;
/*
Remember that the farmers divided the farm into eight sectors, 
each of which has four beds, and in each of the four beds, 
they randomly assigned each of the four fertilizers. 

Here's a question. 
Which variable in this data set represents the beds in the experiment? 
Each sector is divided into 4 positions, and we randomly assign the fertilizers 
to those positions. So the variable Position is a number from 1 to 4, 
which identifies those positions or beds. 

What does the variable BedID represent? 
It is a 5-digit randomly assigned ID number given 
to each of the 32 beds in the experiment. 
*/

/*calculate descriptive statistics for BulbWt for each type of Fertilizer*/
proc means data=statdata.mggarlic_Block printalltypes maxdec=3;
							      /*specify printalltypes to display the means 
							        for the overall bulb weight 
							        and the means of bulb weight by fertilizer*/
   var BulbWt;
   class Fertilizer Sector;
   title 'Descriptive Statistics of redesigned experiment - Garlic Weight';
run;
/*
The mean bulb weight for all 32 beds of garlic is 0.218 pounds with a standard deviation of 0.032. 

Look at the breakdown of the means for the different sectors and fertilizers. 
Which fertilizer has the highest mean? 
Fertilizer 1 has the highest mean at 0.236, 
though its mean is fairly close to fertilizers 3 and 2. 

It also appears just by looking at these statistics that fertilizer 4 
has the lowest mean and the lowest variability. 
 */


/*create box plots for each Fertilizer*/
proc sgplot data=statdata.mggarlic_Block;
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
You can see how the means, represented by the diamonds, 
for the four fertilizer types compare to one another.

Notice that the plot for fertilizer 4 reinforces what we saw with PROC MEANS: 
it has the lowest mean and the lowest variability. 

What was our original question? 
Are the bulb weight means for the four different fertilizers statistically different 
from one another? 
You might have a hunch at this point, but let's use ANOVA to find the answer.
 */


/* 2. Comparing Group Means with ANOVA */

/*Using PROC GLM to analyze the randomized block design of the garlic data*/
/*
With this design, you're testing for statistically significant differences 
between the mean bulb weights for the four fertilizers 
across sectors of
 */

proc glm data=statdata.mggarlic_Block plots(only)=diagnostics(unpack);
								/*use PLOTS= option and specify ONLY 
								  to suppress the default plots */
								/*request diagnostics plots and specify UNPACK -
								  SAS puts each plot on a separate page
								    (otherwise, you will see all of the plots 
								    in a grid or panel display)*/ 
   
   /*specify the classification variable (predictor variable) for the analysis*/
   /* list the blocking variable, Sector, in the CLASS statement*/
   class Fertilizer Sector;
   
   /*specify the variables for MODEL -> dependent-variables=independent-effects*/
   /* list also the blocking variable in the model*/
   model BulbWt=Fertilizer Sector;
   
   title 'ANOVA for Randomized Block Design';
run;
quit;
title;


/* Verify your analysis of variance three assumptions

1. The first ANOVA assumption is satisfied because 
you assume the farmers did a good job at sampling garlic bulbs 
to weigh by randomly selecting them, 
so you assume the observations are independent.

2. Use diagnostic plots of the residuals in PROC GLM 
to verify the assumption that the errors are normally distributed.
See Q-Q Plot of Residuals for BulbWt. 
Do the errors appear to be normally distributed? Yes.

3. Examine the Residuals by Predicted plot to check 
if the variances are equal across each treatment and block combination.
The plot looks good.

Can you also test the equal variance assumption more formally, 
such as with Levene's Test for Homogeneity?
Levene's test is only available for one-way ANOVA models, 
so in this case, you have to use the Residuals by Predicted plot.
*/

/*

Now that you've verified the assumptions, you can look at the output 
and feel confident about interpreting the p-value.

First you see the overall ANOVA table. 

The first column is information about the Degrees of Freedom. 
You can think of Degrees of Freedom as the number of independent pieces of information, 
or the number of values in the final calculation of a statistic that are free to vary. 

The next column is information about the sum of squares. 
The model sum of squares (SSM) is 0.02307, 
the error sum of squares (SSE) is 0.0082, 
and the total sum of squares (SST) is 0.0313. 

The mean square model (MSM) is 0.0023. 
SAS calculates this by dividing the model sum of squares (SMM)
by the model Degrees of Freedom (Model DF), 
which gives you the average sum of squares for the model. 

The mean square error (MSE) is 0.00039, 
which is an estimate of the population variance. 
SAS calculates this by dividing the error sum of squares (SSE)
by the Error Degrees of Freedom (Error DF), 
which gives you the average sum of squares for the error. 

SAS calculates the F-statistic by dividing the MSM by the MSE. 
The overall F test, where F=5.86 and p=0.0003 (is smaller than 0.05), 
indicates that there are significant differences 
between the means of the garlic bulb weights in each of the beds. 


However, because both Fertilizer and Sector are in the model,
you can't tell if the differences are due to differences
among the fertilizers or just differences across sectors.

To determine this, you generally use the Type III SS, 
and we'll look at this in a moment. 

What have you gained by including Sector in the model?
If you compare this MSE, which is 0.00039, 
to the MSE in the model that included Fertilizer only, 0.00077966, 
you see that it decreased.
The drop in the MSE indicates that by adding the blocking factor, 
you were able to account for a bit more of the unexplained variability 
due to the nuisance factors.

Also notice that the R-square for this model is much greater 
than that in the previous model without the blocking factor: 0.736 versus 0.173.
To some degree, this is a function of just having more model degrees of freedom, 
but it's unlikely that this is the only reason for this magnitude of difference. 

Most important to the Montana Gourmet Garlic farmers is 
that the effect of Fertilizer in this model is now significant.
(see table with Type III SS)
Its F-value is 4.31 and the corresponding p-value is 0.0162, 
and this is significant at the 0.05 level. So what can you conclude?
You can conclude that at least one of the fertilizers is different from the others. 
This is great news.

The Type III SS test at the bottom of the output 
tests for differences due to each variable, 
controlling for or adjusting for the other variable.

How about the blocking variable 'Sector'? 
Again you might ask: did it help the model?
The rule of thumb that most statisticians use is 
that if the F-value is greater than 1, 
then it helped to add the blocking factor to your model.

Because this F-value of 6.53 is greater than 1, 
adding Sector as a blocking factor 
helped to decrease the unexplained variability of the response, bulb weight. 
So adding Sector helps you have more precise estimates of the effect of Fertilizer.

If the blocking factor was found not to be useful, 
would you still need to keep it in the model?
Yes you would because this experiment, and therefore this analysis, 
was based on data the farmers collected using Sector as a blocking variable. 
You can, however, exclude it from future studies.


You determined from the randomized block design 
that one of the fertilizer types is different from the rest
because your p-value for Fertilizer was significant. 

If you were to report this to the garlic farmers, they might say,
"Well, which fertilizer is different from the rest?" Or "Which fertilizer is the best?"
You could go back and conduct more t-tests to find the answer, 
but there are better techniques at your disposal.
*/