/*
 * Practice 6: Performing Two-Way ANOVA
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
Data was collected in an effort to determine whether different dose levels of a given drug have an effect on blood pressure for people with one of three types of heart disease. The data is in the Statdata.Drug data set.

Reminder: Make sure you've defined the Statdata library.

Use PROC SGPLOT to examine the data with a vertical line plot. Put BloodP on the Y axis, and DrugDose on the X axis, and then stratify by Disease. What information can you obtain from looking at the data?


Test the hypothesis that the means are equal, making sure to include an interaction term if the results from PROC SGPLOT indicate that would be advisable. What conclusions can you reach at this point in your analysis? 

*/

/* 1.*/
/* 1.1 Identifying Your Data */
proc print data=Statdata.concrete (obs=10);
   title "Partial Listing of Concrete Data Set";
run;
/*
 * variable Brand is the categorical grouping variable with 3 values: 'Consolidated', 'EZ Mix', 'Graystone'
 * variable Additive is the categorical grouping variable with 2 values: 'reinforced', 'standard'
 *   
 * variable Strength, which is the measured strength of a concrete test plot, 
 * is the continuous variable that you want to analyze
 */


proc means data=statdata.concrete mean var std printalltypes;
   /*specify the classification variables (predictor variables) for the analysis*/
   class Brand Additive;
   /*specify the dependent variable*/
   var Strength;
   /*output the means to a new data set 'means'*/
   output out=means mean=Strength_Mean;
   title 'Selected Descriptive Statistics for Concrete Data Set';
run;

ods graphics on / width=800;

proc sgplot data=means;
   where _TYPE_=3;
   scatter x=Additive y=Strength_Mean / group=Brand 
           markerattrs=(size=10);
   xaxis integer;
   title 'Plot of Stratified Means in Concrete Data Set';
run;
title;


/*
What information can you obtain from looking at the data?

The difference between reinforced and standard means for Graystone is about -5.38, 
whereas the mean difference for Consolidated is -3.2 and for EZ Mix is -2.86. 
It appears that the difference between concretes using standard and reinforced cements differs by brand. 
In other words, it appears that there is an interaction between Additive and Brand. 

That means that an interaction term in the ANOVA model would be appropriate 
to assess the statistical significance of the interaction.
 */

/* 2. Performing Two-Way ANOVA with Interactions */
ods graphics on / width=800;

proc glm data=statdata.concrete;
   class Additive Brand;
   model Strength=Additive Brand Additive*Brand;
   title1 'Analyze the Effects of Additive and Brand';
   title2 'on Concrete Strength';
run;
quit;
title;
/*
What conclusions can you reach at this point in your analysis?

There is no significant interaction between Additive and Brand, 
even though the plot shows slightly different slopes among the three brands of concrete. 

At this point, you can choose to remove the interaction term from the model 
and, if still significant, conclude that there is a difference in additive types.

The p-value for the overall model is very small (p-value=0.0009). 
We can reject the null hypothesis and conclude 
that at least one of the effects in the model is significant.

The R square is 0.557144, so approximately 56% of the variation in strength of a concrete 
can be explained by this ANOVA model. 

The strength of a concrete of all the observations is 26.00000, 
which is exactly what the PROC MEANS output showed.  


You want to look at the interaction term  first 'Additive*Brand' in the table for Type III SS. 
If it's significant, the main effects don't tell you the whole story. 
The p-value for Additive*Brand is 0.4862. 

Presuming an alpha of 0.05, you can not  reject the null hypothesis. 
You have not sufficient evidence to conclude that there is an interaction 
between the two factors.

I choose to remove the interaction term from the model.
*/


/* 3. Performing a Post Hoc Pairwise Comparison*/
ods graphics on / width=800;

proc glm data=statdata.concrete;
   class Additive Brand;
   model Strength=Additive Brand; /*remove the interaction term from the model*/
   
   lsmeans Additive;
   
   title 'Analyze the Effects of Additive and Brand';
   title2 'on Concrete Strength without Interaction';
run;
quit;
title;
/*
What conclusions can you reach at this point?

The test for 'Additive' is still significant.
There is a difference between standard and reinforced concrete for all brands . 

The estimate of the two least squares means is found 
in the results for LS means. 
Additive	Strength LSMEAN
reinforced	27.9066667
standard	24.0933333

A reinforced additive in the concrete seems to add more strength 
than a standard additive does. The mean difference is about 3.8.
 */



L. 