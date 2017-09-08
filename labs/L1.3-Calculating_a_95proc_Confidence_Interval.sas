/*
 * Lab 1.3: Calculating a 95% Confidence Interval
 *
 * Lesson 1: Introduction to Statistic
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

proc means data=statdata.testscores maxdec=4
           n mean stderr clm;
   var SATScore;
   title '95% Confidence Interval for SAT';
run;
title;