/*
 * Lab 1.4: Using PROC UNIVARIATE to Perform a Hypothesis Test
 *
 * Lesson 1: Introduction to Statistic
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*This program uses PROC UNIVARIATE 
to test the hypothesis that the mean of SATScore 
is equal to 1200. 

Your null hypothesis is that the population's mean SAT score 
for the Carver County magnet high schools is 1200. 

H0: μ = 1200

Your alternative hypothesis is that the population's mean SAT score 
is not 1200. 

Ha: μ ≠ 1200
 
Let's submit this program and take a look at the output SAS produces.
*/

ods select testsforlocation;

proc univariate data=statdata.testscores mu0=1200;
   var SATScore;
   title 'Testing Whether the Mean of SAT Scores = 1200';
run;
title;

/*
The Tests for Location table provides the t statistic, labeled Student's t, 
and the corresponding p-value. 

The p-value (=0.5702)is greater than the significance level, or α, of 0.05 that we had set. 

Note by the way that it is a coincidence that the t statistic and p-value 
have the same numeric value (although one is positive and the other negative). 

Because the p-value is greater than alpha, we fail to reject the null hypothesis. 
Therefore, we believe that there is no statistical difference 
between the sample mean of 1190 and the hypothesized mean of 1200.   

Here's another way to look at it. 
If the null hypothesis is true, how likely are we to see 
a t statistic with an absolute value of .5702 or greater? 
Well, about 57% of the time. 
This value confirms that we do not have enough evidence 
to reject the null hypothesis. 

To summarize: the original question was 
whether the mean SAT score for Carver County magnet high school students equals 1200. 
From this hypothesis test, we conclude that 
there is not enough evidence to say that the sample mean score of 1190.625 
is statistically different from 1200.
 */