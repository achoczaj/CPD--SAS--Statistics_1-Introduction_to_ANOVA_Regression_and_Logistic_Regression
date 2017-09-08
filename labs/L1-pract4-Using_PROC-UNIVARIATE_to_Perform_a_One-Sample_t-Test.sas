/*
 * Practice 4: Using PROC UNIVARIATE to Perform a One-Sample t-Test
 * Lesson 1: Introduction to Statistics
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
You need to perform a one-sample t-test for the variable BodyTemp in the Statdata.NormTemp data set to confirm whether average body temperature is truly 98.6 degrees.
Task description goes right here. Reminder: Make sure you've defined the Statdata library.
1. Use PROC UNIVARIATE to perform a one-sample t-test to determine whether the mean of the variable BodyTemp in the data set NormTemp is truly the value 98.6. What is the value of the t statistic and the corresponding p-value? 

2. What is the null hypothesis?

3. What is the alternative hypothesis?

4. Using a 0.05 alpha, do you reject or fail to reject the null hypothesis?
*/

/* 1.*/
ods select testsforlocation;
   proc univariate data=statdata.normtemp mu0=98.6;
      var BodyTemp;
      title 'Testing Whether the Mean Body Temperature = 98.6';
   run;
   title;

/* The value of the t statistic is -5.45 and the corresponding p-value = <.0001 respectively.*/

/*2.*/
/* 
What is the null hypothesis?
- The population mean is equal to 98.6.*/

/*3.*/
/* 
What is the alternative hypothesis?
- The population mean is not equal to 98.6. */

/*4.*/
/* 
Using a 0.05 alpha, do you reject or fail to reject the null hypothesis?
- Because the p-value is less than the stated alpha level of .05, 
you do reject the null hypothesis. */

