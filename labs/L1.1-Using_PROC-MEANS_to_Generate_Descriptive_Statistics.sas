/*
 * Lab 1.1: Using PROC MEANS to Generate Descriptive Statistics
 *
 * Lesson 1: Introduction to Statistic
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

proc print data=statdata.testscores (obs=10);
   title 'Listing of the SAT Data Set';
run;
title;

proc means data=statdata.testscores maxdec=2 fw=10 printalltypes;
   class Gender;
   var SATScore;
   title 'Descriptive Statistics Using PROC MEANS';
run;
title;

proc means data=statdata.testscores maxdec=2 fw=10 printalltypes
           n mean median std var q1 q3; 
   class Gender;
   var SATScore;
   title 'Selected Descriptive Statistics for SAT Scores';
run;
title;