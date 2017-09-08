/*
 * Practice 2: Producing Descriptive Statistics and Box Plots
 * Lesson 1: Introduction to Statistics
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
You want to understand if true mean body temperature is 98.6 and whether women's body temperatures are the same as men's body temperatures. The Statdata.NormTemp data set contains the data that you need.
Reminder: Make sure you've defined the Statdata library.

1. Use PROC MEANS to determine the overall mean and standard deviation of the variable BodyTemp in the data set NormTemp. Ensure that SAS displays statistics for all requested combinations of the class variable. 

2. Do the mean values seem to differ between men and women? 

3. What is the interquartile range of body temperature?  
*/

/* 1.*/
proc means data=statdata.normtemp
              maxdec=2 fw=10 printalltypes
              n mean std q1 q3;
      var BodyTemp;
      class Gender;
      title 'Selected Descriptive Statistics for Body Temp';
   run;
   title;
   
/* The overall mean is 98.25. The standard deviation is 0.73. */

/*2.*/
/* Do the mean values seem to differ between men and women? 
- The values do differ somewhat.*/

/*3.*/
/* What is the interquartile range of body temperature? 
- The interquartile range is 0.90 (98.70 - 97.80). Another option for determining the interquartile range is to include the keyword QRANGE in the list of statistics specified in the PROC MEANS statement. That way SAS will calculate this statistic for you.
*/