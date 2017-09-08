/*
 * Lab 5.3: Performing a Pearson Chi-Square Test of Association
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Tests of Association

Suppose you've explored the distribution of your variables 
and you've seen some possible associations. 

To be certain that your variables are associated, 
you need to run a formal test of association—the chi-square test. 

To measure the magnitude of an association, 
you can use measures of association such as 
Cramer's V statistic 
and 
the Spearman correlation statistic.


*** Pearson Chi-Square Test ***

To perform a formal test of association between two categorical variables, 
you use the chi-square test. 
The Pearson chi-square test is the most commonly used of several chi-square tests, 
and it is often referred to as simply the chi-square test. 

You start with the null hypothesis of no association between the variables 
and the alternative hypothesis of association. 

To determine whether there is an association, 
the Pearson chi-square test measures the difference 
between the observed cell frequencies 
and the cell frequencies that are expected 
if there is no association between the variables. 
In other words, the expected frequencies are the frequencies you expect to get 
if the null hypothesis is true. 

The chi-square test calculates the expected frequencies 
for each cell 
by multiplying the row total (R) 
by the column total (C), 
and then dividing the result by the total sample size (T). 

If the observed frequencies equal the expected frequencies, 
there is no association between the variables. 
If the observed frequencies do not equal the expected frequencies, 
there is an association between the variables. 
The chi-square statistic indicates the difference between observed frequencies and expected frequencies. A significant chi-square statistic is strong evidence that an association exists between your variables. 

Keep in mind that the chi-square statistic and its corresponding p-value indicate only whether an association exists between two categorical variables. The p-value indicates how confident you can be that the null hypothesis of no association is false. However, neither the chi-square statistic nor its p-value tells you the magnitude of an association. 

Chi-square statistics and their p-values depend on and reflect the sample size. A larger sample size yields a larger chi-square statistic and a smaller corresponding p-value, even though the association might not be all that strong. For example, if you double the size of your sample by duplicating each observation, you double the value of the chi‑square statistic, even though the strength of the association does not change.


*** Cramer's V Statistic ***

Cramer's V statistic is one measure of the strength of an association between two categorical variables. Cramer's V statistic is derived from the Pearson chi-square statistic. 

For two-by-two tables, Cramer's V is in the range of -1 to 1. For larger tables, Cramer's V is in the range of 0 to 1. 

Values farther away from 0 indicate a relatively strong association between the variables. The closer Cramer's V is to 0, the weaker the association is between the rows and columns. For a two-by-two table, a Cramer's V value close to 1 indicates a strong positive association. A Cramer's V value close to -1 shows a strong negative association. 

Like other measures of strength of association, Cramer's V statistic is not affected by sample size.


*** Odds Ratios ***

Sometimes you want to compare the likelihood that a specific event or outcome will occur in one group as compared with another group. For example, suppose you want to see the effect that training has on spending habits. The people in group B attended a seminar about saving money, and the people in group A did not. The outcome variable indicates whether each person saved at least 10% of income in the year following the seminar. Both the predictor variable and the outcome variable are binary variables. Binary variables have two distinct values. The population frequencies are shown in a two-way frequency table. 

To measure the strength of the association between a binary predictor variable and a binary outcome variable, you can use an odds ratio. An odds ratio indicates how much more likely it is, with respect to odds, that a certain event, or outcome, occurs in one group relative to its occurrence in another group. In this example, you want to know how much more likely it is, with respect to odds, that a Yes outcome occurs in Group B relative to its occurrence in Group A. 

So, what are odds? Odds are not the same thing as probabilities. Instead, odds are calculated from probabilities. To calculate the odds, you divide the probability that the event occurs by the probability that the event does not occur. Let's calculate the probabilities.

First, you need to calculate the probability of a Yes outcome in Group B. You start with the number of Yes outcomes in Group B (90) and divide by the total number of observations in group B (100 ) to get a .90, or 90%, probability of having the outcome in Group B. The probably of a No outcome in Group B is 10 divided by 100, which is 0.10, or 10%. 

Here's a question: What is the probability of having a Yes outcome in Group A? To calculate the probability of a Yes outcome in Group A, you divide 60 by 80, which is 0.75, or 75%. The probability of a No outcome in Group A is 20 divided by 80, which is 0.25, or 25%.

Now that we know the probabilities, let's calculate the odds. The odds of the outcome occurring in Group B are the probability of a Yes outcome in Group B (.90) divided by the probability of a No outcome in Group B (.10). The odds for group B are 9 (or 9:1), which means that we expect nine occurrences of the outcome to one non-occurrence in Group B. 

Here's a question: What are the odds of having the outcome in Group A? To calculate the odds of the outcome occurring in Group A, you divide the probability of a Yes outcome in Group A (.75) by the probability of a No outcome in Group A (.25). The odds for Group A are 3 (or 3:1), which means that you expect three times as many occurrences as non-occurrences in Group A.

Now that you know the odds of the outcome in both groups, you can compare the Group B odds with the Group A odds by calculating an odds ratio. You divide the odds of an outcome in Group B (9) by the odds of an outcome in Group A (3), with a result of 3. An odds ratio of 3 means that the odds of getting the outcome in Group B are three times those of getting the outcome in Group A. In this example, the odds of saving at least 10% of income are three times higher for people who have received training. 

Let's look at the possible range of values for an odds ratio. The value of the odds ratio can range from 0 to infinity; it cannot be negative. When the odds ratio is 1, there is no association between the predictor variable and the outcome variable. If the odds ratio is greater than 1, the group in the numerator of the fraction (here, Group B) is more likely to have the outcome. In the example about saving money, the odds ratio 3 indicates that the odds for Group B is three times the odds for Group A. If the odds ratio is less than 1, the group in the denominator of the fraction (here, Group A) is more likely to have the outcome. 

The odds ratio is approximately the same regardless of sample size. To estimate the true odds ratio while taking into account the variability of the sample statistic, you can calculate confidence intervals just as you can for any unknown parameter you are trying to estimate. A 95% confidence interval for an odds ratio means that you are 95% confident that the interval contains the true odds ratio. In other words, if you sample repeatedly and calculate a confidence interval for each sample odds ratio, 95% of the time your confidence interval will contain the true population odds ratio. 

You can use an odds ratio to test for significance between two categorical variables. If the 95% confidence interval does not include 1, the odds ratio is significant at the 0.05 level. You are 95% confident that the true odds ratio is significantly different from 1. There is an association between the two variables. If the 95% confidence interval includes 1, the odds ratio is not significant at the 0.05 level. You don’t have enough evidence to conclude that the true odds ratio is significantly different from 1. So, there is not enough evidence to conclude that there is an association between the two variables.
*/


/***************************************************
 Performing a Pearson Chi-Square Test of Association
****************************************************/
/*
Let's see a demonstration of performing a Pearson Chi-Square Test of Association. 

In the first demonstration, we created a crosstabulation table for Gender by Purchase. This table indicates a possible association between the two variables. Now we want to run a formal test to determine whether the association is significant. Let's look at the code.
*/
proc freq data=statdata.sales_inc;
   tables Gender*Purchase /
          chisq expected cellchi2 nocol nopercent 
          relrisk;
   format Purchase purfmt.;
   title1  'Association between Gender and Purchase';
run;

title;
/*
The PROC FREQ step requests a crosstabulation table for Gender by Purchase, as in the earlier program. But, this time, we're working with the Sales_Inc data set that we created instead of Sales.


To perform a Pearson chi-square test of association and generate related measures of association, we'll specify options in the TABLES statement in PROC FREQ. Remember that you add options at the end of the TABLES statement, following a forward slash. 

The CHISQ option produces the Pearson chi-square test of association and the measures of association that are based on the chi-square statistic. The output from this option alone will tell you whether there is a significant association between the specified variables. 

Let's also add some additional options that are related to measures of association. The EXPECTED option prints the expected cell frequencies, which are the cell frequencies that we expect under the null hypothesis of no association. CELLCHI2 prints each cell's contribution to the total chi-square statistic. NOCOL suppresses the printing of the column percentages. NOPERCENT suppresses the printing of the cell percentages. Finally, we'll add the RELRISK (relative risk) option to print a table that contains risk ratios (probability ratios) and odds ratios. 

Let's submit the program.
*/

/* Results:
At the top of the results is the requested crosstabulation table for Gender by Purchase. The total number of observations appears in the bottom right corner. Notice that we're working with a large sample. You can see how the options in the TABLES statement change the statistics that appear in each cell. The actual frequency appears first. Next, the EXPECTED option generates the expected frequency. The expected frequency is the count that we'd expect if the null hypothesis of no association between the two variables is true. The CELLCHI2 option generates the cell chi-square statistic, which indicates how much that cell contributes to the overall chi-square statistic. The formulas for calculating the cell chi-square statistic and the overall chi-square statistic are shown here. The NOCOL and NOPERCENT options suppress the column percentages and overall percentages, respectively, which would otherwise appear by default. The row percent indicates the percent of females or males in each purchasing category. We want to identify the customers who spent at least $100, so let's look at the row percentages in that column. Approximately 42% of females and 32% of males spent at least $100. We compare these two values to test for a difference between the percent of males and the percent of females who spend this amount. 

The next table contains the Pearson chi-square test and Cramer's V statistic, as well as other tests and measures of association. The CHISQ option in the TABLES statement generates this table. At the top are the overall chi-square statistic and its corresponding p-value. The p-value is less than 0.05, so we reject the null hypothesis. This value tells us that there is an association between Gender and Purchase. In other words, the observed difference between males and females spending at least $100 is statistically significant. The Cramer's V statistic measures the strength of the association that the chi-square test detected. This is a two-way table, so the Cramer's V statistic can range from -1 to 1. Here, the Cramer's V statistic is close to 0, which indicates a relatively weak association between Gender and Purchase. The chi-square test might have detected an association because of the large sample size and not because of the strength of the association. 

Here's a question: What effect does a decrease in sample size have on the chi-square value, the p-value for the chi-square statistic, and Cramer's V statistic? The Cramer's V statistic is not affected by sample size. However, if the sample size decreases, the chi-square value decreases and the p-value for the chi-square statistic increases. 

The last table shows estimates of the relative risk for the row 1 variable to the row 2 variable in the crosstabulation table above. The RELRISK option generates this table. 

Before you look at the values in this table, it's important to understand how PROC FREQ calculates odds ratios. Let's look at the crosstabulation table for Gender by Purchase. To calculate an odds ratio, PROC FREQ uses the classification in the first column of the crosstabulation table as the outcome of interest, and the classification in the first row as the numerator of the equation. In this example, remember that the first column is people who spent less than $100. So PROC FREQ uses this as the outcome of interest when calculating an odds ratio. PROC FREQ uses females, the value in the first row, in the numerator of the equation, and males, the value in the second row, in the denominator. 

In the Estimates of the Relative Risk table, the odds ratio of females to males for spending less than $100 is in the first row. However, remember that we are actually interested in the other outcome – spending $100 or more. So we'll interpret this odds ratio as the odds of the row 2 value (males) compared to the odds of the row 1 value (females) of being in the second column. This interpretation is logically equivalent. 

Remember that you can use the odds ratio to measure the strength of association for a two-by-two table. The odds ratio of 0.6458 means that the odds of a male spending at least $100 are approximately 65%, or 2/3 that of a female. It's often easier to report odds ratios by converting the decimal value to a percent difference value. The formula for the conversion is shown here. In this example, males have 35.42 percent lower odds than females of spending $100 or more. An odds ratio of 1 would mean no association. However, the 95% confidence interval does not include 1, which indicates that the odds ratio is significant at the 0.05 significance level. This also means that the true odds ratio is statistically different from 1, so it's another way of testing whether the association between Gender and Purchase is significant. 

Here's a question: What effect does a decrease in sample size have on the odds ratio value and the width of the confidence interval? The odds ratio is not affected by sample size, but the width of the confidence interval will increase (given that the relative proportions are held constant). 
 */

