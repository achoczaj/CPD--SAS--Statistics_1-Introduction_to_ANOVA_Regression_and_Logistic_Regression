/*
 * Lab 1.2: Using SAS to Picture Your Data
 *
 * Lesson 1: Introduction to Statistic
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

ods graphics on/width=600;

proc univariate data=statdata.testscores;
   var SATScore;
   id idnumber;
   histogram SATScore / normal(mu=est sigma=est);
   inset skewness kurtosis / position=ne;
   probplot SATScore / normal(mu=est sigma=est);
   inset skewness kurtosis;
   title 'Descriptive Statistics Using PROC UNIVARIATE';
run;
title;