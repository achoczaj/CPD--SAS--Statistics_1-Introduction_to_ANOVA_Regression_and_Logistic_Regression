/*
 * Lab 2.2: Comparing Group Means with Two-Sample t-Tests
 * 			- using PROC GLM to analyze group means
 *
 * Lesson 2: Analysis of Variance (ANOVA)
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Sometimes you want to make comparisons between two different populations or groups. 
For example, do males, on average, have higher salaries than females? 
Do females, on average, have lower blood pressure than males? 
Do patients who receive a new medication have higher T-cell counts 
than patients who receive a placebo during a drug trial? 

When you compare two different groups, you usually want to know 
if the means of the two groups are different. 

You can use the two-sample t-test to determine the answer. 
In this topic, you learn how to:
- analyze differences between two population means using the TTEST procedure
- verify the assumptions of and perform a two-sample t-test
- perform a one-sided t-test
 */

/* Two-Sample t-Test

You can use a one-sample t-test to determine if the mean of a population 
is equal to a particular value or not. 

When you collect a random sample of independent observations 
from two different populations, you can perform a two-sample t-test. 

The two-sample t-test is a hypothesis test for answering questions 
about the means of two populations. 

This test enables you to examine the differences between populations 
for one or more continuous variables. 
You can assess whether the means of the two populations 
are statistically different from each other. 

As you know, in statistics, the null hypothesis is your initial assumption 
and is usually one of equality.
The null hypothesis for the two-sample t-test is 
that the means for the two groups are equal, or that μ1 - μ2 equals 0. 

The alternative hypothesis is the logical opposite of the null hypothesis 
and is typically what you suspect or are trying to show. 
It is usually a hypothesis of inequality. 

The alternative hypothesis for the two-sample t-test is 
that the means for the two groups are not equal, or μ1 - μ2 does not equal 0.
 */

/* Assumptions for the Two-Sample t-Test

When you compare the means of two populations using a two-sample t-test, 
you make three assumptions: 
1. the data contains independent observations, 
2. the distributions of the two populations are normal, 
3. and the variances in these normal distributions are equal. 

You need to examine your data and verify these assumptions 
before you run any statistical analyses. 
If any one of these assumptions is not valid, then the probability 
of drawing incorrect conclusions from the analyses could increase. 
Let's examine these assumptions further. 

The first assumption is one of independent observations. 
What does this mean? 
This means that one observation doesn't affect another observation, 
that is, no observation provides information about any other observation. 

For example, if your data contains several observations on each subject 
or if your data contains observations on sets of twins, 
then the assumption of independent observations is not valid 
and you shouldn't use the two sample t-test. 

You verify this assumption in the design phase of the experiment: 
if you have a random, representative sample and you collect the data correctly, 
this assumption should be true. 


The next assumption is one of normality. 
Do you have normally distributed data for each group? 
If the populations from which you obtained your samples are normally distributed, 
then your sample data will most likely look normal too; 
it will be approximately symmetric and have close to a bell shape. 

You can examine plots of the data to verify this assumption. 


The last assumption is homogeneity of variance. 
The variance is a measure of spread in your population. 
In the two-sample t-test, you assume that the variances in the two populations are equal. 

To verify this assumption, you can check to see if the variances in your two samples 
are approximately equal.  
If your sample variances are not too different, then you are safe to assume 
that the population variances are equal. 
The F-test is a formal way to verify this assumption.
 */

/* F-Test for Equality of Variance

To evaluate the assumption of equal variances in the two populations, 
you can use the F-test for equality of variances. 

The null hypothesis for this test is that the population variances are equal. 
The formula is sigma_1 squared equals sigma_2 squared, 
where sigma squared is the population parameter for the variance. 

The alternative hypothesis is that the population variances are not equal, 
which is sigma_1 squared does not equal sigma_2 squared.

To test the hypothesis, you calculate the F statistic, 
which is the ratio of 
the maximum sample variance of the two groups 
to 
the minimum sample variance of the two groups.

F_statistic = max(s_1^2, s_2^2) / min(s_1^2, s_2^2)

By construction, the F statistic is always greater than or equal to 1. 

If the variances in the populations really are equal, 
then you expect the variances in the samples to be nearly equal too. 


Here's a question. When the null hypothesis is true, 
what value will the F statistic be close to? 
If the variances in the two populations are equal, then the F statistic tends to be close to 1. 

Consequently, a large value for the F statistic is evidence against the assumption of equality.
 */

/* Scenario: Comparing Group Means

You know the three assumptions for the two-sample t-test, so now let's look at an example. 
Suppose you want to compare female and male test scores. 
For example, the students in Ms. Chao's statistics course want to determine 
whether girls or boys in Carver County magnet schools scored higher on the SAT.

What do you think the null hypothesis is for this test? 
The null hypothesis is that the mean SAT score for girls is equal to the mean SAT score for boys. 
So, you're not concerned with which group scored higher, 
but whether the difference in population average scores equals 0 or does not equal 0. 

Do you think this is an example of a one-sided two-sample t-test or a two-sided two-sample t-test? 
This is an example of a two-sided two-sample t-test 
because you’re testing to see whether two group means 
are significantly different from each other. 

This would be a one-sided test if your alternative hypothesis was 
that the mean test score for girls is higher than the mean test score for boys, 
or the mean SAT score for boys is higher than the mean SAT score for girls.
 */


/* 1. Identifying Your Data */

proc print data=statdata.testscores (obs=10);
   title "Partial Listing of TestScores Data";
run;
/*
The SAS data set TestScores contains the SAT score information 
and the variables Gender, SATScore, and IDNumber. 

Gender	SATScore	IDNumber
Male	1170	61469897
Female	1090	33081197
Male	1240	68137597
Female	1000	37070397
Male	1210	64608797
Female	970		60714297
Male	1020	16907997
Female	1490	9589297
Male	1200	93891897
Female	1260	85859397

Which of these variables is the categorical grouping variable, or classification variable? 
Gender is the categorical grouping variable with two values: 'male' or 'female'. 

Which of these variables is the continuous variable that you want to analyze for mean? 
You want to analyze and compare the mean values of the variable SATScore for each gender. 
 */


/* 2. Performing a One-Sided Two-Sample t-Test*/

/*
Use PROC TTEST in SAS for the two-sample t-test. 
PROC TTEST performs the two-sample t-test by default. 
It also computes confidence limits and uses ODS graphics 
to create graphs as part of its output.
 
It automatically tests the assumption of equal variances, 
and provides an exact two-sample t-test when the assumption is met, 
and an approximate t-test when it is not met. 

Use the PLOTS= option to the PROC TTEST statement 
to control the plots that ODS graphics produces. 

You want to examine the default plots, which are the histogram and the Q-Q plot, 
as well as the plot of confidence intervals. 
When you add the SHOWNULL option, SAS places a vertical reference line (in the interval plot)
at the mean value of the null hypothesis, which is 0 by default. 
Remember that you're testing to see if μ1 - μ2 = 0. 

In the CLASS statement, you specify the variable Gender, 
and in the VAR statement, you specify the continuous variable SATScore.
 */

proc ttest data=statdata.testscores plots(shownull)=interval;
   /*specify the classification variable (predictor variable) for the analysis*/
   class Gender;
   /*specify the dependent variable*/
   var SATScore;
   title 'Two-Sample t-Test Comparing Girls to Boys';
run;
title;
/* Theory:
The TTEST procedure produces: summary statistics, confidence limits, 
standard deviations, and hypothesis tests. 

It also includes the graphical output we specified in the program. 

There's quite a bit here to analyze, and there's actually an order to 
how you should interpret these results. 

But before you look at the t-test results to compare the group means, 
you need to learn how to interpret them.

Option 1 - Examining the Equal Variance t-Test and p-Values

Let's learn how to interpret the results of PROC TTEST by examining some generic data. 
We'll focus on the order of your analysis. First, let's verify the assumptions for the test. 

For the purposes of this example, let's assume that you have independent observations 
and normally distributed data.
 
Next, you need to verify the assumption of equal variances, 
so you analyze the F-Test for Equal Variances results. 
The p-value of the F-test is 0.7446, and this probability is greater than 0.05, your alpha, 
so you fail to reject the null hypothesis and can proceed 
as if the variances are equal between the groups.

Here's a question. Because you are assuming the population variances are equal, 
which t-test should you use to determine if the means are equal? 
You should use the equal variance t-test, or the Pooled t-test. 

By default, SAS shows the 95% intervals for both the Pooled method, 
assuming equal variances for group 1 and group 2, 
and the Satterthwaite method, 
assuming unequal variances. 

SAS calculates a Pooled t-test that uses a weighted average of the two sample variances. 
You use this p-value to test that the means for the two groups 
are significantly different under the assumption that the variances are equal. 

Here's a question. Are the means of the two groups significantly different? 
The p-value of 0.0003 is less than 0.05, so you reject the null hypothesis 
and can conclude that the means between the two groups are significantly different.

Option 2 - Examining the Unequal Variance t-Test and p-Values

Now consider this. What if you can't verify the assumption of equal variances? 
For example, the p-value of this F-test is 0.0185. 
Is this value greater than your alpha? 
No, it's not, so you have enough evidence to reject the null hypothesis of equal variances. 

Knowing this, which t-test should you use to determine if the means are equal? 
You should use the unequal variance t-test, or Satterthwaite test, to test the group means. 

SAS calculates a Satterthwaite t-test that compensates for unequal variances 
and allows you to move forward with the equality of means test 
when the variances are not equal. 

You use this p-value to test that the means for the two groups 
are significantly different without assuming that the variances are equal. 

Here's a question. Are the means of the two groups significantly different? 
The p-value of 0.032 is less than 0.05, so you reject the null hypothesis 
and can conclude that the means between the two groups are significantly different.
*/


/*3. Interpreting Results for Two-Sample t-Test Comparing Girls to Boys */
/*
Now you're ready to interpret the two-sample t-test results 
and determine if the mean SAT score for females is equal 
to the mean SAT score for males. 

Let's begin by verifying our assumptions. 
Remember that you satisfy the assumption of independent observations with good data collection. 
To assess the normality assumption for each gender, 
you examine the histograms and normal probability plots. 

The top histogram is of the SAT scores for females 
and the bottom histogram is of the SAT scores for males. 
Here's a question. Do the data appear to have come from normal populations? 
Both histograms have a blue normal reference curve superimposed on the plots 
to help you determine if the distributions are normal, and these look approximately normal.

You can additionally examine the Q-Q plot, or quantile-quantile plot, 
at the bottom of the results to assess normality. 
If the data in a Q-Q plot comes from a normal distribution, 
the points cluster tightly around the reference line. 
Here you can see that the females are on the left and the males are on the right. 
Do the data appear to have come from normal distributions? Yes. 

The sample histograms and the Q-Q-plots show 
that the samples have an approximate normal shape, 
so it's probably safe to assume that the populations are normal. 


At the top of the results, you can see the statistical tables for the TTEST procedure. 
Let's look at the Equality of Variances table. 
The F-test for equal variances has a p-value of 0.2545. 
Do you reject or fail to reject the null hypothesis? T
his p-value is greater than 0.05, so you fail to reject the null hypothesis. 
The variances are not statistically different at the 95% significance level. 

Now you use the p-value for the t-test where the variances are equal, or the Pooled method t-test. 
This p-value shows the results of the t-test 
where the null hypothesis is that the average SAT scores of females and males are equal. 
The p-value of 0.0643 is greater than 0.05, so what can you conclude? 
You don't have enough evidence to conclude that the average SAT scores for females and males 
are significantly different at the 95% significance level. 

Here's a question. Do you notice anything interesting about the p-value in the Satterthwaite test? 
It's almost equal to the Pooled p-value. 
Also, notice the t statistic values for both tests, 1.88. 
What can you generalize from these equalities? 
The Pooled and Satterthwaite t-tests are equal when the variances are equal. 
You can also see the 95% confidence intervals of the means and standard deviations for females and males.

For the differences between the means, you can see both Pooled and Satterthwaite 95% intervals. 
If you look at the confidence interval for the differences between the means 
using the Pooled method, which is -3.695 to 125.2, it includes 0, 
so you don't have enough evidence to say that the difference of the means 
is significantly different from 0 at the 95% confidence level. 
This is equivalent to the p-value being greater than 0.05. 

In this scenario, the differences between the mean SAT score for females and males 
is the same whether you use the Pooled method or Satterthwaite method. 
The confidence intervals are what are now different, 
but just barely different, as are these p-values, 
because the sample variances for males and females are so similar. 

At the top of the TTEST output, you see descriptive statistics 
separated by the levels of the CLASS variable Gender. 
What does the mean Diff value represent? 
It's the result of subtracting the sample mean of group 2, the males, 
from the sample mean of group 1, the females. 
So the actual sample mean difference in SAT scores is 60.75 points. 

Here's another question. Why does SAS label the females group 1? 
Females are group 1 because they come first alphabetically. 

Let's finally look at the confidence interval plot. 
Because the variances here are so similar between males and females, 
the Pooled and Satterthwaite intervals, and p-values, are very similar. 
Notice that the lower bound of the Pooled interval extends past 0, 
so you don't have enough evidence to say 
that the difference of the mean SAT score for females 
and the mean SAT score for males is significantly different from zero.
 */