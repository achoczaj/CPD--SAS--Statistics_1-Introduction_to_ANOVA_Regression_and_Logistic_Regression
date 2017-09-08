/*
 * Practice 1: Using PROC TTEST to Compare Means
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
A professor at a local university collects data to determine 
the effectiveness of a new type of foreign language teaching technique 
on student grammar skills. 
She selects 30 students to receive tutoring: 
15 students receive the new type of teaching technique during the tutorials, 
and 15 students receive standard tutoring. 
Two students move away before completing the study. 
She records scores on a standardized German grammar test before the tutorials, 
and then again 12 weeks later. 
She wants to see the effect of the new technique on grammar skills.

The data set Statdata.German contains the data for this experiment, 
including the variable Change, which represents the change in grammar test scores, 
and the variable Group, which represents the assigned treatment, coded as 'Treatment' or 'Control'.
Reminder: Make sure you've defined the Statdata library.

1. Write a program that uses a one-sided t-test to assess 
whether the treatment group improves more than the control group. 
Add an appropriate title, submit the code, and examine the results.
2. Do the two groups appear to be approximately normally distributed?
3. Do the two groups have approximately equal variances?
4. Does the new teaching technique seem to be a significant improvement over the standard technique?
*/

/* 1.*/
/* 1.1 Identifying Your Data */
proc print data=Statdata.German (obs=10);
   title "Partial Listing of German Test Scores Data";
run;
/*
 * variable Group is the categorical grouping variable with two values: 'Treatment' or 'Treatment'. 
 * variable Gender is the categorical grouping variable with two values: 'male' or 'female'. 
 * 
 * variable Change, which represents the change in grammar test scores, 
 * is the continuous variable that you want to analyze
 */

/* 1.2 2. Performing a One-Sided Two-Sample t-Test*.*/
/*enable ODS Graphics before requesting plots*/
ods graphics on;

proc ttest data=statdata.German 
				plots(shownull)=interval
				/*H0= specifies null value*/
				h0=0 
				/*SIDES= specifies number of sides and direction*/
				sides=L;
				/*SIDES=L specifies lower one-sided tests, in which the alternative hypothesis indicates 
				  a mean less than the null value, 
				  and lower one-sided confidence intervals 
				  between minus infinity and the upper confidence limit.*/
/*Use the SIDES=L option because this is a lower-tailed, one-sided t-test. 
  Control comes before Treatment alphabetically, so the test for differences is for Control minus Treatment. 
  A negative value for the difference score indicates treatment improvement.*/   
   
   
   /* specify the categorical grouping variable*/
   class Group;
   
   /* specify the continuous variable to analyze*/
   var Change;
   
   title1 'German Training, Comparing Treatment to Control';   
   title2 'One-Sided t-Test';
run;
title;

/* 
2. Do the two groups appear to be approximately normally distributed?
The Distribution of Change plots do not show strong evidence against normality in either group.

3. Do the two groups have approximately equal variances?
The p-value of the F-test is 0.0660, and this probability is greater than 0.05, your alpha, 
so you fail to reject the null hypothesis and can proceed 
as if the variances are equal between the groups.

4. Does the new teaching technique seem to be a significant improvement over the standard technique?
The p-value for the Pooled (equal variance) t-test for the difference between the two means is 0.1788
and shows that the two groups are not significantly different. 
Therefore, you don't have enough evidence to say conclusively 
that the new teaching technique is better than the old teaching technique. 

The Difference Interval Plot displays these conclusions graphically. 
The Pooled interval includes 0, 
which indicates a lack of statistical significance.
*/