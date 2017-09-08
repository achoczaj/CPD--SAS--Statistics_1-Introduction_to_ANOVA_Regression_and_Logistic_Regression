/*
 * Practice 3: Using PROC MEANS to Generate a 95% Confidence Interval for the Mean
 * Lesson 1: Introduction to Statistics
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
You need to generate a 95% confidence interval for the mean of the variable BodyTemp in the Statdata.NormTemp data set.
Reminder: Make sure you've defined the Statdata library.

1. Use PROC MEANS to generate a 95% confidence interval for the mean of BodyTemp in the NormTemp data set. Is the assumption of normality met to produce a confidence interval for these data? 

2. What is the confidence interval?

3. How do you interpret this interval with regards to the true population mean 
for body temperature?
*/

/* 1.*/
proc means data=statdata.normtemp maxdec=2
              n mean stderr clm;
      var BodyTemp;
      title '95% Confidence Interval for Body Temp';
   run;
   title;
/* Yes, the normality assumption seems to hold because the sample size is large enough and because the data values seemed to be normally distributed.*/

/*2.*/
/* 
What is the confidence interval?
- The 95% confidence interval is 98.12 to 98.38 degrees Fahrenheit.

/*3.*/
/* 
How do you interpret this interval with regards to the true population mean for body temperature?
- You are 95% confident that the true mean body temperature for the population of all people in the world is somewhere between 98.12 and 98.38 degrees.*/