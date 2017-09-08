/*
 * Lab 2.5: Comparing Group Means with ANOVA Post Hoc Tests
 * 			- Using PROC GLM with LSMEANS to analyze the randomized block design
 *
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*

*/

/*
Example:
The Montana Gourmet Garlic farmers are trying to determine 
which of their fertilizers has the best effect on garlic bulb weight. 
They have three organic fertilizers and one chemical fertilizer, 
which is the control. In their last experiment, they performed 
a randomized block design to control for the nuisance factors, 
and after analyzing the results, they rejected the null hypothesis 
that all groups are the same. 
At least one of the fertilizer types is different from the others 
because the p-value for Fertilizer was significant. 

Here's the ANOVA mathematical model. 
Bulb Weight = Base Level + Sector + Fertilizer Type + Unaccounted for variation

You add Sector to the model as your blocking variable, 
which means you'll also need to modify your SAS program 
to determine which fertilizer is different. 
Let's first look at the output SAS produces with this model.*/

/*
>> Diffograms and the Tukey Method

You request all of the multiple comparison methods 
with options in the LSMEANS statement in PROC GLM.
	LSMEANS effects </ options>;
The PDIFF=ALL option requests p-values for the differences between ALL the means.
The ADJUST= option specifies the adjustment method for multiple comparisons.
If you don't specify an option, SAS uses the Tukey method by default.

>>> Diffograms 
When you specify the PDIFF=ALL option, SAS produces a diffogram automatically.
A diffogram displays all pairwise least squares means differences and indicates which are significant.
You can use diffograms to visually assess whether two group means are statistically different.
You can think of a diffogram as a least squares mean by least squares mean plot 
because SAS plots the least squares means on the vertical and horizontal axes. 

The point estimates for differences between the means for each pairwise comparison
can be found at the intersections of the gray grid lines.
The red and blue diagonal lines show the confidence intervals 
for the true differences of the means for each pairwise comparison,
and the gray 45-degree reference line represents equality of the means.

>>> Tukey Method Interpretation
If the confidence interval for the two groups crosses over the reference line, 
then there is no significant difference between the two groups.
In that case, the diagonal line for the pair will be broken and colored red.

If the confidence interval does not cross the reference line, 
then there is a significant difference between the two groups,
and the diagonal line for the pair will be solid and colored blue. 

Here's a question.
In this diffogram, is there a significant difference 
between the means of treatments 1 and 2? Yes there is.
This line represents the pairwise comparison of treatments 1 and 2. 

Because this line does not cross over the reference line, 
and because SAS made it a solid blue line, 
you know there's a significant difference between these two treatments. 

Can you identify the pairwise comparisons that do not have significantly different means? 
As indicated by the red broken lines, the differences between treatments 3 and 4 
and treatments 4 and 2 are not significant.

>> Control Plots and the Dunnett Method
When you specify an LSMEANS statement with the ADJUST=Dunnett option, 
the GLM procedure produces multiple comparisons 
using Dunnett's method and a control plot. 

>> Control Plots
A control plot displays the least squares mean and confidence limits 
of each treatment compared to the control group using Dunnett's method. 

In this scenario, group 1 is the control group 
and the middle horizontal line represents its least squares mean value. 
You can see the arithmetic mean value in the upper right corner of the graph. 

SAS bounds the shaded area with the LDL, or lower decision limit, 
and the UDL, or upper decision limit. 

Notice that there is a vertical line for each treatment 
that you're comparing to the control group. 

>>> the Dunnett Method Interpretation
If a vertical line extends past the shaded area, 
then the group represented by the line is significantly different than the control group. 

In this case, which treatments are significantly different than the control? 
Treatments 2, 3, and 4 are all significantly different than the control. 

If a vertical line is longer, or further away from the shaded area, 
it represents a greater significance, that is, a smaller p-value.




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


/* 2. Comparing Group Means with ANOVA */

/*Using PROC GLM with LSMEANS to analyze the randomized block design of the garlic data*/
/*
Recall that to calculate multiple comparison tests and to produce the diffogram 
and control plot for the garlic bulb weight analysis in SAS, 
you use PROC GLM with the LSMEANS statement. 

Here's the code. 
*/
ods graphics on / width=700;
/*ods trace on;*/
ods trace off;
ods select lsmeans diff meanplot diffplot controlplot;
/* You can use the ODS SELECT and ODS EXCLUDE statements 
along with graph and table names to specify which ODS output SAS displays.

How do you know what output objects your SAS program produces? 
You can use the ODS TRACE statement in your program.
When you add the ODS TRACE statement, 
SAS writes a trace record to the log that includes information 
about each output object, such as the path for each object 
and the label for each object.
*/

proc glm data=statdata.mggarlic_block;
   /*specify the classification variables (predictor variables) for the analysis*/
   class Fertilizer Sector;
   /*specify the variables for MODEL -> dependent-variables=independent-effects*/
   model BulbWt = Fertilizer Sector;
   
   /*conduct pairwise comparisons with an experimentwise error rate of α = 0.05*/
   lsmeans Fertilizer / pdiff=all adjust=tukey;
   lsmeans Fertilizer / pdiff=controlu('4') adjust=dunnett;
   lsmeans Fertilizer / pdiff=all adjust=t;
   title 'Garlic Data: Multiple Comparisons';
run;
quit;
title;
/*
In the PROC GLM statement, you specify the SAS data set MGGarlic_Block. 
In the CLASS statement, you specify the classification 
and blocking variables for the analysis. 
In the MODEL statement, you specify the variables as indicated in the ANOVA model. 

Now let's look at the LSMEANS statements. 
You use these statements to run several multiple comparison tests on the means. 
In practice, you will typically use one method. 
The three shown here demonstrate how they compare to one another. 

In the first LSMEANS statement, you specify the classification, 
or predictor variable, Fertilizer. 
The PDIFF option requests p-values for the differences. 
You specify PDIFF=ALL, which is the default, 
to request all pairwise differences. 
You add the ADJUST= option to specify the adjustment method 
for multiple comparisons. 
If you don't specify an adjustment method, 
SAS uses the Tukey method by default. 
Remember with the Tukey method, you can examine all pairwise differences. 

In the second LSMEANS statement, you specify the ADJUST=Dunnett option 
to calculate multiple comparisons using Dunnett's method. 
In the 'PDIFF=controlu' option, you specify fertilizer '4' as the control group. 
In this analysis, the garlic growers are not blind to the fertilizers 
and know that number 4 is the chemical fertilizer. 
You specify 'controlu' here, but 'control' and 'controll' 
are valid PDIFF options as well. 
When you use 'controlu', you are testing if the non-control levels, 
that is, fertilizers 1, 2, and 3, are greater than the control. 
You want to see if fertilizer 1 is statistically greater than fertilizer 4, 
and if fertilizer 2 is statistically greater than 4, and so on. 

What do you know about the direction of the sign in a comparison? 
The direction of the sign in the alternative hypothesis 
is the same as the direction you are testing, 
so this is a one-sided upper-tailed t-test. 

The third LSMEANS statement requests all pairwise t-tests 
on the differences 
and requests that SAS make no adjustments for multiple comparisons.
 */
/*
Let's look at the output. 

1. Let's start with the Tukey LSMEANS Comparisons, 
which correspond to your first LSMEANS statement. 

The first table shows the mean bulb weight for each type of fertilizer. 
The LSMEAN Number is a legend, or key, to read the table of p-values 
in the second table. 
In this case, they are the same as the numbers assigned to your fertilizers. 

The second table shows the p-values from pairwise comparisons 
of all possible combinations of means. 
Notice that row 2 column 4 has the same p-value as row 4 column 2. 
What does this mean? 
You see the same values because SAS compares the same two means 
in each case and displays them as a convenience to you. 
Why are some of the spaces blank? 
It doesn't make sense to compare a mean to itself, 
so in each of these cases, you see blanks. 

Recall that the null hypothesis for each test is that 
the means for the two fertilizers are equal. 

Now for the important question: 
Do you see a significant pairwise comparison difference in this table? 
The only significant pairwise difference is between 
fertilizer 1 and fertilizer 4. 
The p-value of 0.0144 is less than your alpha, 
meaning that the bulb weights of these two fertilizers 
are significantly different from one another. 

LS-Means plot shows the least squares mean graphically. 
You can see the mean bulb weight for each type of fertilizer. 
Fertilizer 1 has the highest mean, 
but all three organic fertilizers have higher mean weights 
than the chemical fertilizer, fertilizer 4. 

You can use the diffogram to visually assess 
if there is a significant difference between 
any of the pairwise comparisons using Tukey's method. 

The blue diagonal line indicates that the means of fertilizers 1 and 4 
are significantly different from one another. 


2. Let's now move onto the Dunnett method output. 
These results correspond to your second LSMEANS statement. 

In Dunnett table, you can see that SAS compared the first three fertilizers 
to fertilizer 4, the control, or chemical fertilizer. 
Even though the mean weights of garlic bulbs 
using any of the three organic fertilizers 
are all greater than the mean weight of garlic bulbs grown 
using the chemical fertilizer, you can say 
that only fertilizer 1 is statistically greater than the control. 
Its p-value is the only one less than your alpha (0.05).

Here's Control Differences with Dunnett Adj plot (control = 'fertilizer 4'), 
which serves to reinforce what you just learned. 

Because you performed one-sided, upper-tailed hypothesis tests 
of each of the organic fertilizers versus the chemical fertilizer, 
you only see only the upper shaded region with the UDL in your plot. 

Remember that the bottom horizontal line is the least squares mean 
of your control group. 
The vertical line for fertilizer 1 is the only line 
that extends past the UDL. 


3. Finally, let's examine the output that corresponds 
to your third LSMEANS statement. 

These t-tests do not adjust for multiple comparisons, 
and are therefore more liberal than tests that do control for the EER. 

Take a moment to look at the p-values. 
You might notice that the p-values in this table are smaller 
than those in the Tukey table.
 
In fact, which additional significant pairwise difference does this method show? 
It shows that fertilizer 1 is significantly different 
from fertilizer 2 with a p-value of 0.0195. 
This is in addition to fertilizers 1 and 4 being statistically different 
with a p-value of 0.0029. 
Notice also that the comparison between fertilizers 3 and 4 
is nearly significant. 

So with this test, there's a tendency to find 
more significant pairwise differences than might actually exist. 

Lastly, let's take a look at the diffogram. 
Again, this reinforces what you know a
bout fertilizers 1 and 4 and fertilizers 1 and 2. 


Using these multiple comparison techniques gives you options. 
If you feel strongly about controlling the EER, 
you shouldn't use the pairwise t-test results 
and should instead use the Tukey or Dunnett results. 

You knew before you performed these multiple comparison techniques 
that fertilizer 1 produced the garlic with the heaviest overall mean bulb weight, 
so that would be your first choice if you are not considering other factors 
like cost or availability. 

But what if fertilizer 1 is very expensive or hard to obtain? 
With these multiple comparison techniques, you now know 
which fertilizers are not statistically different from fertilizer 1, 
so the Montana Gourmet Garlic farmers have options 
for the fertilizer to use that will produce equally heavy garlic bulbs.
 */