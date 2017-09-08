/*
 * Lab 2.7: Performing Two-Way ANOVA with Interactions with the STORE Statement
 * 			- Using PROC GLM to analyze the randomized block design
 *
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
When running PROC GLM, you can add a STORE statement to save your analysis results. 
By using the STORE statement, you can run postprocessing analyses on the stored results, 
even if you no longer have access to the original data set.

The STORE statement requests that the procedure save the context and results of the statistical analysis 
into an item store. An item store is a binary file format that cannot be modified. 
You can process the contents of an item store with the PLM procedure.

For example, if you need to perform a time-consuming analysis, you can store the results 
by using the STORE statement. 

At a later time, you can use PROC PLM to perform specific statistical analysis tasks 
based on the saved results of the previous analysis without having to fit the model again. 
This can be a great time saver!

Here is the syntax of the STORE statement.
 
Following the keyword STORE and OUT= you specify the item store name and an optional label.
*/

/* Performing Postprocessing Tasks with the PLM Procedure */
/*
You know that you can add a STORE statement to PROC GLM, 
or a number of other procedures, to save the analysis results to a store item. 

To perform post-fitting statistical analyses and plotting for the contents of the store item, 
you use the PLM procedure.

Here is the PROC PLM syntax. 

PROC PLM RESTORE=item-store-specification<options>;
  EFFECTPLOT <plot-type <(plot-definition options)>>
            </ options>;

  LSMEANS <model-effects > </ options>;
  LSMESTIMATE model-effect <'label'> values
            <divisor=n><,...<'label'> values
            <divisor=n>> </ options>;
  SHOW options;
  SLICE model-effect </ options>;
  WHERE expression;
RUN;

The statements and options that are available vary depending upon 
which procedure you used to produce the item store. 

PROC PLM is followed by RESTORE= and then the specified item store to be processed. 
You can include the EFFECTPLOT statement to produce additional plots of the fitted model. 
The SLICE statement is helpful when your model contains an interaction. 
You use the SLICE statement to look at the effect of one variable at different slices, 
or value ranges, of another variable.
*/

/*
Example:
Storing PROC GLM Results for Future Analysis

During your analysis of residential property sales in Ames, Iowa, 
you identify a possible interaction between the variables Heating_QC and Season_Sold. 
You decide to perform a two-way ANOVA of SalePrice with Heating_QC and Season_Sold 
as the predictor variables. 
You also include the interaction term Heating_QC*Season_Sold. 

You add a STORE statement to save the analysis results as a store item. 
Later, you run PROC PLM to create some additional plots of the fitted model.
*/


/*******************************************************************
 * 1. Performing Two-Way ANOVA with an Interaction by Using PROC GLM
 *******************************************************************/
/*
Use PROC GLM to perform a two-way ANOVA with an interaction 
using the statdata.ameshousing3 data set. 
Include a STORE statement to save the results in an item store. 
 */

proc format;
   value Season
   1="Winter"
   2="Spring"
   3="Summer"
   4="Fall";
run;

ods graphics on;

proc glm data=statdata.ameshousing3 
         order=internal
         
         plots(only)=intplot;
   
   /*specify the classification variables (predictor variables) for the analysis*/
   class Season_Sold Heating_QC;
   /*specify the variables for MODEL -> dependent-variables=independent-effects*/
   model SalePrice = Heating_QC Season_Sold Heating_QC*Season_Sold;
   /*conduct pairwise comparisons with an experimentwise error rate of α = 0.05*/
   lsmeans Heating_QC*Season_Sold / diff slice=Heating_QC;
   /*use format 'Season.'*/
   format Season_Sold Season.;
   /*save the results in an item store 'interact'*/
   store out=interact;
   
   title1 "Model with Heating Quality and Season as Interacting Predictors";
run;
title;
/*
The option order=internal tells SAS to use the order of the variable values 
stored internally, rather than the order of the formatted values. 
The internal values for Season_Sold are 1 (formatted as Winter), 
2 (formatted as Spring), 3 (for Summer), and 4 (for Fall). 
So, including order=internal tells SAS to display the seasons 
in the order Winter, Spring, Summer, and Fall, 
rather than in alphabetical order. 

We specify plots(only)=intplot to request an interaction plot. 
You can request an interaction plot even if there isn’t an interaction in the model. 
In this case, there is an interaction, so we’ll be able to visualize the interaction in the plot. 
Because Season_Sold and Heating_QC are categorical variables, 
we need to include them in a CLASS statement.

In the MODEL statement, we specify 
the response variable SalePrice, 
equals, 
the main effects Heating_QC and Season_Sold, and then interaction effect. 
The interaction effect is represented as the two main effects separated by an asterisk. 
Here’s another way to represent the effects. 
Instead of listing the interaction effect, we could simply 
place a vertical bar '|' between the main effects.
	model SalePrice = Heating_QC | Season_Sold;
	
Recall that the LSMEANS option computes and compares least squares means of fixed effects. 
This LSMEANS statement specifies the interaction term Heating_QC by Season_Sold. 
By specifying slice=Heating_QC, we tell SAS to to slice the interaction effect 
by the different levels of Heating_QC. 

This means that each slice will have one Heating_QC level 
and will show the Season_Sold effect across that slice. 
We'll format Season_Sold with a FORMAT statement. 

The statement store out=interact saves the analysis results 
as a SAS item store named interact in the Work library.

The program ends with a TITLE statement and a RUN statement.
*/

/* Results:

The first two tables tell us that 
there are four levels of season sold (winter, spring, summer, and fall), 
four levels of heating quality and condition (excellent, fair, good, and typical/average), 
300 observations, and no missing values. 

The next table tells us that the overall model is statistically significant.
The p-value for the overall model is very small (p-value= <.0001), so what does this tell you? 
You can reject the null hypothesis and conclude 
that at least one of the effects in the model is significant.

The R square is 0.230634, so approximately 23% of the variation in Sale Price change 
can be explained by this ANOVA model. 

The average Sale Price change of all the observations is 137524.9. 


The next tables show the breakdown of the main effects and interaction term in the model. 
Look at the Type III Sums of Squares values. 

Now let’s look at the p-value=0.0121 of the interaction term 'Season_So*Heating_QC'
to determine whether to remove it. In this case, it is significant. 
Presuming an alpha of 0.05, you reject the null hypothesis. 
You have sufficient evidence to conclude that there is an interaction 
between the two factors. 

This tells us that the relationship between Heating_QC and SalePrice 
differs across levels of Season_Sold. 
Also the relationship between Season_Sold and SalePrice 
differs across levels of Heating_QC. 

With the significance of this interaction, it should stay in the model. 
Note that due to model hierarchy, all effects contained 
within significant interactions should also remain in the model, 
regardless of their p-value. 


The Interaction Plot is a line plot overlaid 
with all of the observations of the data set. 
This plot shows that for most categories of heating quality, 
the season when the property was sold had little effect on the sale price. 

However, when the heating quality value was fair, 
the price sold was low in winter, went up until summer 
and then went down again in fall. 

The next table displays the least square means for every possible combination 
of Season_Sold and Heating_QC, 
and the following matrix displays p-values for every possible combination. 

These tables were produced by the DIFF option in the LSMEANS statement, 
but they really aren’t very informative. 
So let’s focus instead on the slice analysis of this model, 
which is produced by the SLICE option we specified in the code. 

In the next table we have Season_Sold by Heating_QC 
sliced by Heating_QC for SalePrice. 
We have three degrees of freedom for each level of Heating_QC 
(excellent, fair, good, and typical/average). 
These are the three degrees of freedom for the Season_Sold variable, 
which has four levels. 

Season_So*Heating_QC Effect Sliced by Heating_QC for SalePrice
Heating_QC	DF	Sum of Squares	Mean Square	F Value	Pr > F
Ex			3	1759608339		586536113	0.51	0.6746
Fa			3	12318827232		4106275744	3.58	0.0143
Gd			3	14560964166		4853654722	4.23	0.0060
TA			3	2134918196		711639399	0.62	0.6021

The first p-value(=0.6746) looks at the homogeneity of means 
within the Heating_QC group 'Excellent' 
across all of the levels of Season_Sold. 
This p-value shows that there is no significant difference 
across seasons sold for when heating quality and condition is 'Excellent'.

There is a statistically significant season sold effect 
within the 'fair' group as well as the 'good' group, 
but not within the 'typical/average group'. 
 */


/*******************************************************
 * 2. Performing Postprocessing Analysis by Using PROC PLM
 *******************************************************/

/*
Previously, we used PROC GLM to perform a two-way ANOVA with an interaction 
using the statdata.ameshousing3 data set. 
We included a STORE statement to save the results in an item store named interact 
in the temporary Work library. 

In this demonsration, we are in the same SAS session, 
so we can access the the interact item store.

We produce additional plots by running PROC PLM on the item store.
 */
ods graphics on;

/* previous program */
/* must be run in the same SAS session*/
/*
proc glm data=statdata.ameshousing3 
         order=internal 
         plots(only)=intplot;
   class Season_Sold Heating_QC;
   model SalePrice=Heating_QC Season_Sold Heating_QC*Season_Sold;
   lsmeans Heating_QC*Season_Sold / diff slice=Heating_QC;
   format Season_Sold Season.;
   store out=interact;
   title "Model with Heating Quality and Season as Interacting Predictors";
run;
title;
*/

proc plm restore=interact plots=all;
   slice Heating_QC*Season_Sold / sliceby=Heating_QC 
   								  adjust=tukey;
   effectplot interaction(sliceby=Heating_QC) / clm;
run;
/*
It starts with with ODS Graphics on to ensure 
that get all of the plots we request. 

Previously, we ran PROC GLM with a STORE statement 
and saved the results in an item store named interact. 
So, restore=interact tells SAS to run PROC PLM on the interact item store. 
We specify plots=all, which tells SAS that we want 
all of the available ODS plots for the statements that we include in PROC PLM.

We want to produce more tables on Season_Sold by different levels of Heating_QC, 
so we add the SLICE statement Heating_QC by Season_Sold, 
and option sliceby=Heating_QC. 
Notice that the syntax sliceby= in the SLICE statement is different 
from slice= in the LSMEANS statement. 

We include adjust=tukey in order to get the Tukey adjustment 
for multiple comparison tests.

By specifying plots=all, the output will include an effect plot. 
However, by adding an EFFECTPLOT statement, we can specify more options. 
We specify the interaction sliceby=Heating_QC, 
and we specify clm, which gives us confidence limits for the means.
*/

/*Results:
We see information about the item store we created, 
including its name and location, the data set 
from which it was created, the procedure we used to create it, 
the response variable, the class variables, and the model effects. 

We get Class Level Information again, and then 
we get a table of the Overall F test for Season_Sold for the interaction term. 
This table focuses on just one Heating_QC level 'Excellent'. 
The p-value(=0.6746) is the same as the one shown in the PROC GLM results.

The next table shows all of the pairwise comparisons of 
Season_Sold within the Heating_QC level 'Excellent'. 
In last columns we get the unadjusted p-values [Pr > |t|]
as well as the Tukey adjusted p-values [Adj P].


Because we specified plots=all and a SLICE statement, we get a diffogram. 
This diffogram is for just Season_Sold by Heating_QC at the Excellent level. 
As you can see, there are no significant differences 
among pairs when we hold Heating_QC constant at excellent.

Next, let’s look at the diffogram for Heating_QC at the level 'fair'. 
In the plot, notice one blue line. 
It tells us that there is a significant difference 
in the mean SalePrice of properties sold in the summer 
versus winter when the value of Heating_QC is 'fair'.

Now let’s look at the diffogram for Heating_QC at the level 'good'. 
Spring versus summer is statistically different. 

The last diffogram holds Heating_QC constant at 'typical/average' 
and shows no significant differences among the pairs of seasons.


The last plot 'Fit for SalePrice' was produced by the EFFECTPLOT statement. 
This plot includes the confidence intervals that we requested.
 */










proc print data=statdata.Drug (obs=10);
   title "Partial Listing of Drug Data";
run;
/*
The SAS data set Drug contains the experiment data. 
You can see the four drug dose levels and the three categories of disease. 
Here's a question. What do the negative values for BloodP mean? 
The negative values indicate a reduction in the diastolic blood pressure after two weeks of treatment. 
The positive values, therefore, indicate an increase in the diastolic blood pressure. 
 */

/* 2. Applying the Two-Way ANOVA Model*/
 
/* 
Now let's see how your experiment fits the two-way ANOVA model. 

Here's the ANOVA mathematical model. 

Bulb Weight = 'Base Level' + 'Disease' + 'DrugDose' + 'DrugDose and Disease' + 'Unaccounted for variation'
Y_ijk = μ + α_i + β_j + (α*β)_ij + ε_ijk

Y_ijk is the observed BloodP for each patient. 

μ is the overall population mean of the response, BloodP. 
This is the average blood pressure of all patients 
regardless of the disease category or drug dose level. 

α_i is the effect of the ith Disease category, 
which is the difference between 
the overall population mean of the i_th disease category 
and the overall mean μ. 

β_j is the effect of the jth DrugDose, 
which is the difference between 
the population mean of the jth drug level 
and the overall mean μ. 

(αβ)_ij is the effect of the interaction 
between the i_th Disease and the j_th DrugDose. 

ε_ijk is the error term, or residual in your model. 
....................................................

As with the one-way ANOVA, in this model you also assume 
that the observations are independent, 
that the data is normal for each observation, 
and that the population variances are equal for each treatment. 

Here's a question. Can you identify the null hypothesis for your two-way ANOVA? 
The null hypothesis is that none of the effects in the model are statistically different, 
that is, no differences exist among the 12 group means. 
H0: μ_1 = μ_2 = ... = μ_11 = μ_12

Where did the 12 means come from? 
Your experiment includes four drug dose levels and three types of heart disease, 
so you have 12 different combinations of dosage level and heart disease types.
*/


/* 3. Examining Your Data with PROC MEANS */
/*
Use PROC MEANS statement to examine the means of blood pressure overall, 
the means of blood pressure for each type of disease, 
the means of blood pressure for each level of drug dose, 
and the means of blood pressure for each disease by drug dose combination.
You do this by specifying PRINTALLTYPES in the PROC MEANS statement.
 */
/*create format dosef.*/
proc format;
   value dosef
   1="0mg-Placebo"
   2="100mg"
   3="200mg"
   4="500mg";
run;

/*compute means and use new format dosef. */
proc means data=statdata.drug
           mean var std printalltypes;
   
   /*specify the classification variables (predictor variables) for the analysis*/
   class Disease DrugDose;
   /*specify the dependent variable*/
   var BloodP;
   
   output out=means mean=BloodP_Mean; /*(1.)*/
   
   format DrugDose dosef.; /*(2.)*/
   title "Selected Descriptive Statistics for Drug Data Set";
run;
title;
/*
(1.)The OUTPUT statement creates a new dataset 'Means' to include all of the types of means. 
The Means data set contains the variable _TYPE_, with values ranging from 0 to 3 
to represent the four tables this PROC MEANS program generates. 
Type 0 gives you the mean blood pressure change of all observations, 
regardless of disease type or drug dose. 
Type 1 gives you the mean blood pressure for each drug dose, 
regardless of disease type. 
Type 2 gives you the mean blood pressure for each disease type, 
regardless of drug dose. 
And Type 3 gives you the mean blood pressure 
for each disease type and drug dose combination. 

You'll use the _TYPE_ value in the next demonstration. 
The variable Mean will be named BloodP_Mean in the new output data set.

(2.) FORMAT statement applies the 'dosef.' format to the variable DrugDose 
so that you can see the actual four drug dose levels in the output 
rather than the numbers 1 through 4. 
*/

/* Results:
In the first table you can see the mean, variance, and standard deviation 
for all of the observations, regardless of disease type or drug dose. 
Here's a question. What conclusion can you make about the mean blood pressure 
for the two-week experiment? 
Overall, there was a drop in diastolic blood pressure. The mean change was about -2.3. 

The next table shows the mean, variance, and standard deviation 
for each level of drug dose, regardless of disease type. 
What do you observe about the mean blood pressure in this table? 
You should notice that the reduction in mean blood pressure 
is greater when the drug dose is lower. 
Remember that this isn't accounting for the type of heart disease each patient has. 

The next table shows the mean, variance, and standard deviation 
for each disease type, regardless of drug dose. 
How did the patients with disease A seem to respond to the experiment? 
The patients with disease A have the greatest reduction in mean blood pressure at -15. 
On the other hand, the patients with disease B showed an increase in blood pressure, 
but this is without accounting for the drug dose. 

The last table shows the mean, variance, and standard deviation of blood pressure 
for each disease type and drug dose combination. 
SAS orders the table based on the order that you list the variables in the CLASS statement, 
so you see the disease type and the drug doses within. 
Here's a question. 
In which disease type does the drug dose appear to be most effective? 
The drug treatment appears to be the most effective 
in patients with disease A because there is a mean blood pressure reduction at each level. 
Note that the first drug dosage level is the placebo, 
and patients with disease type A and placebo saw a slight increase in blood pressure, on average. 
Patients with disease B have an increase in blood pressure on average, 
so the treatment doesn't appear to be effective for them. 
And the average change in blood pressure for patients with disease C 
is relatively constant across each level of drug dose.
 */


/* 4. Examining Your Data with PROC SGPLOT */
/*Examine a means plot to graphically explore the relationship of blood pressure 
for each disease type and drug dose combination. 
In the PROC SGPLOT statement you specify the data set Means, which SAS created in the previous demo. You want to plot only the mean blood pressure change for each disease type and drug dose combination, so you specify where _TYPE_=3
 */

/*enable ODS Graphics before requesting plots*/
ods graphics on / width=800;

/*create scatter plots for the mean blood pressure
for each disease type and drug dose combination*/
proc sgplot data=means;
   where _TYPE_=3;     
   scatter x=DrugDose y=BloodP_Mean / 
           					group=Disease 
           					markerattrs=(size=10);
   series x=DrugDose y=BloodP_Mean / 
   							group=Disease        
          					lineattrs=(thickness=2);
   xaxis integer;
   format DrugDose dosef.;  
   title "Plot of Stratified Means in Drug Data Set";
run;
title; 
/*
The SCATTER statement creates a scatter plot 
with DrugDose on the x axis and BloodP_Mean on the y axis, grouped by Disease. 

You specify the appearance of the markers in the plot with the MARKERATTRS option. 

The SERIES statement adds lines to connect the dots in the scatterplot. 

The XAXIS statement forces the x axis to have tick marks only at integer values. 
By default, SAS assumes that X is a continuous variable. 
You must explicitly indicate that DrugDose is categorical. 
*/
/* Result:
From the graph, the relationship is clearer. 
For disease type A, blood pressure decreases as the drug level increases. 
For disease type B, blood pressure increases as the drug level increases. 
For disease type C, blood pressure stays relatively the same for different drug levels. 

This plot is exploratory, and it helps you plan your analysis. 
You can generate similar plots in PROC GLM.
 */


/* 5. Specifying Interactions in PROC GLM */
/*
Specifying an interaction term in the MODEL statement of PROC GLM is easy. 
You can simply place an asterisk between the terms. 
Interaction terms are also called product terms or crossed effects. 

Alternatively, you can use the bar operator '|' to specify a full factorial model.

For example, here are two ways of writing the model for a full three-way factorial model:
model Y=A B A*B C A*C B*C A*B*C;
and
model Y=A|B|C;
*/


/* 6. Performing Two-Way ANOVA with Interactions */
/* 
Use PROC GLM to determine if the effects of Disease and DrugDose, 
and the interaction between the two, are statistically significant. 

In the PROC GLM statement, you specify the data set Drug. 
In the CLASS statement, you specify the classification variables for the analysis. 
In the MODEL statement, you specify the variables as they exist in the two-way ANOVA model. 

SAS enables you to easily define the interaction. 
You simply separate the two main effects variables by an asterisk. 
*/
ods graphics on / width=800;

proc glm data=statdata.drug;
   class DrugDose Disease;
   model Bloodp = DrugDose Disease DrugDose*Disease;
   format DrugDose dosef.;  
   title "Analyze the Effects of DrugDose and Disease";
   title2 "Including Interaction";
run;
quit;
title;
/*Results:
Examine the output. 
The p-value for the overall model is very small (p-value= <.0001), so what does this tell you? 
You can reject the null hypothesis and conclude 
that at least one of the effects in the model is significant, 
in other words, there is at least one difference among the 12 group means, 
one for each drug dose and disease combination. 

Which factors explain this difference? You'll see in just a few moments. 

The R square is 0.3479, so approximately 35% of the variation in blood pressure change 
can be explained by this ANOVA model. 

The average blood pressure change of all the observations is -2.294118, 
which is exactly what the PROC MEANS output showed.  
 
The next tables show the breakdown of the main effects and interaction term in the model. 
Look at the Type I and Type III Sums of Squares values. 
Do you know why their values are not exactly the same? 
You don't have a balanced design in this experiment. 
In other words, you have a different number of observations 
in each drug dose and disease combination group. 

In most situations, you will want to use the Type III SS. 
The Type I, or sequential SS, are the sums of squares you obtain 
from fitting the effects in the order you specify in the ANOVA model.
 
The Type III, or marginal SS, are the sums of squares you obtain 
from fitting each effect after all the other terms in the ANOVA model, 
that is, the sums of squares for each effect corrected for the other terms in the model. 
Type III SS does not depend upon the order you specify effects in the model. 

You want to look at the interaction term  first 'DrugDose*Disease' in the table for Type III SS. 
If it's significant, the main effects don't tell you the whole story. 
The p-value for DrugDose*Disease is 0.0001. 
Presuming an alpha of 0.05, you reject the null hypothesis. 
You have sufficient evidence to conclude that there is an interaction 
between the two factors, meaning that the effect of the level of drug dose on blood pressure 
changes for the different disease types. 

You don't need to worry all that much about the significance 
of the main effects 'Disease' + 'DrugDose' [or α_i + β_j]
at this point for two reasons: 
1) Because the interaction term 'DrugDose and Disease' [or (α*β)_ij] is significant, 
you know that the effect of the drug level changes for the different disease types. 
2) Because the interaction term 'DrugDose and Disease' [or (α*β)_ij] is significant, 
you want to include the main effects 'Disease' + 'DrugDose' [or  α_i + β_j] in the model, 
whether they are significant or not, to preserve model hierarchy.   

Let's finally take a look at the 'Interaction Plot for blood pressure'. 
SAS produces this plot by default when you have an interaction term in the model. 

This plot looks similar to the one you produced with PROC SGPLOT, 
except that this one plots each of the blood pressure change measurements, 
as well as the means for each drug dose and disease type combination. 

Well, you might be thinking, "Okay. I know the interaction is significant. 
What I really want to know is the effect of drug dose at each particular level of disease."

You have to performe ANOVA Post Hoc Pairwise Comparison 
and add the LSMEANS statement to your program to find the answer.
*/ 


/* 7. Performing a Post Hoc Pairwise Comparison*/
/*
You do not yet know the significance of the DrugDose effect at any particular level of Disease 
because of the interaction, so let's see how you can analyze and interpret the effect. 

Add the LSMEANS statement to request the least squares mean for each unique DrugDose and Disease combination. 
Add the SLICE option to test the effect of DrugDose within each Disease. 
*/
ods graphics on / width=800;
ods select meanplot lsmeans slicedanova;  

proc glm data=statdata.drug;
   class DrugDose Disease;
   model Bloodp=DrugDose Disease DrugDose*Disease;
   
   lsmeans DrugDose*Disease / slice=Disease; 
   
   format DrugDose dosef.;
   title "Analyze the Effects of DrugDose";
   title2 "at Each Level of Disease";
run;
quit;
title;
/* Results:
In the sliced ANOVA table 'DrugDose*Disease Effect Sliced by Disease for BloodP'
see results for testing the significance of drug dosage level 
on blood pressure within each level of disease. 

Take a moment and determine which, if any, of these p-values is significant. 
Disease	DF	Sum of Squares	Mean Square		F Value		Pr > F
A		3	6320.126747		2106.708916		4.87		0.0029
B		3	10561			3520.222833		8.14		<.0001
C		3	468.099308		156.033103		0.36		0.7815

As you've seen in previous plots, the drug dose effect is significant 
when used in patients with either disease A or disease B, 
but not in patients with disease C (as p-value=0.7815). 

SAS creates two types of LS-MEANS plots when you use the LSMEANS statement 
with an interaction term. 
The first plot simply displays the least squares mean for every effect level. 
SAS plots each effect level on the horizontal axis 
and the LSMean of blood pressure on the vertical axis. 

In this second plot, you can basically see what you've seen earlier. 
You can look a little closer at the combination levels if you want. 
You can see that the greatest increase in blood pressure change 
is at the drug dosage level of 200mg for patients with disease B, 
and that the greatest decrease in blood pressure change 
is at the drug dosage level of 200mg for patients with disease A. 

Based on these results, what treatment plan would you recommend to patients? 
It seems that you would want to aggressively treat blood pressure 
in patients with disease A with high dosages of the drug to decrease blood pressure. 
For those patients with disease B, perhaps a disease caused by a traumatic event, 
you might not want to use the drug at all 
because it appears to increase blood pressure. 
For those patients with disease C, you might want to look into an alternative drug 
because this drug doesn't appear to have any effect on blood pressure. 
*/

