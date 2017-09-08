/*
 * Practice 6: Performing Two-Way ANOVA Ex-2
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
Data was collected in an effort to determine whether different dose levels of a given drug have an effect on blood pressure for people with one of three types of heart disease. The data is in the Statdata.Drug data set.
Reminder: Make sure you've defined the Statdata library.
1. Use PROC SGPLOT to examine the data with a vertical line plot. 
Put BloodP on the Y axis, and DrugDose on the X axis, 
and then stratify by Disease. 
What information can you obtain from looking at the data?
2. Test the hypothesis that the means are equal, 
making sure to include an interaction term if the results from PROC SGPLOT 
indicate that would be advisable. 
What conclusions can you reach at this point in your analysis? 

*/

/* 1.*/
/*create format dosef.*/
proc format;
   value dosef
   1="0mg-Placebo"
   2="100mg"
   3="200mg"
   4="500mg";
run;

proc sgplot data=statdata.drug;
   vline DrugDose / group=Disease 
                    stat=mean 
                    response=BloodP 
                    markers;
   format DrugDose dosefmt.;
run;
/*
Based on the results, it appears that drug dose affects change in blood pressure. 
However, that effect is not consistent across diseases. 
Higher doses result in increased blood pressure for patients with disease B, 
decreased blood pressure for patients with disease A, 
and little change in blood pressure for patients with disease C.
*/

ods graphics on;

proc glm data=statdata.drug plots(only)=intplot;
   class DrugDose Disease;
   model BloodP=DrugDose|Disease;
   lsmeans DrugDose*Disease / slice=Disease;
run;
quit;
/*
 * In the results, note the following:
The first table under the heading Dependent Variable: 
BloodP displays the results of the global F test, 
which indicates a significant difference among the different groups. 

Because the interaction is in the model, this is a test 
of all combinations of DrugDose*Disease against all other combinations.

In the next table, the R-Square value 
implies that about 35% of the variation in BloodP 
can be explained by variation in the explanatory variables.

The interaction term is statistically significant, 
as predicted by the plot of means (Interaction Plot for BloodP).

The sliced table (DrugDose*Disease Effect Sliced by Disease for BloodP) 
shows the effects of DrugDose at each level of Disease. 

The effect is significant for all but disease C.
*/
 */
