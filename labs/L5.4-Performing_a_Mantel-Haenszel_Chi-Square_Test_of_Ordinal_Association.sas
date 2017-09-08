/*
 * Lab 5.4: Performing a Mantel-Haenszel Chi-Square Test of Ordinal Association
 *			- Mantel-Haenszel Chi-Square Test
 * 			  (test for an association between ordinal variables as well as nominal variables) 
 * 			- Spearman Correlation Statistic
 * 			  (test for measure the strength of the association between ordinal variables as well as nominal variables)
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
*** Mantel-Haenszel Chi-Square Test ***

You can use the Pearson chi-square test to test for an association between ordinal variables as well as nominal variables. However, for ordinal associations, the Mantel-Haenszel chi-square test is a more powerful test.  When two variables have an ordinal association, an increase in the value of one variable tends to be associated with an increase or decrease in the value of the other variable. For example, the Mantel-Haenszel chi-square test can help to determine whether, as the row values increase in size, the column values also increase in size. When the variables have more than two levels, the levels must be in a logical order for the test results to be meaningful. 

For the Mantel-Haenszel chi-square test, the null hypothesis is that there is no ordinal association between the row and column variables. The alternative hypothesis is that there is an ordinal association between the row and column variables. 

So, why is the Mantel-Haenszel chi-square statistic more powerful than the Pearson chi-square statistic for detecting an ordinal association? All of the power of the Mantel-Haenszel statistic is concentrated on ordinal associations. However, the power of the Pearson (or general) association statistic is dispersed over a greater number of alternatives. 

The Mantel-Haenszel chi-square statistic and its corresponding p-value are similar to the Pearson chi-square statistic and its corresponding p-value in the following ways. They indicate only whether an association exists but not the magnitude of the association. They depend on and reflect the sample size.


*** Spearman Correlation Statistic ***

To measure the strength of the association between two ordinal variables, you can use the Spearman correlation statistic. You should use the Spearman correlation statistic only if both variables are ordinal and the values of each variable are in logical order. The Spearman correlation is considered to be a rank correlation because it provides a degree of association between the ranks of the ordinal variables. Ordinal variables are considered to be ranked because their values have a logical order. 

This statistic has a range between -1 and 1. Values close to 1 indicate that there is a relatively high degree of positive correlation.  Values close to -1 indicate that there is a relatively high degree of negative correlation. And values close to zero indicate a weak correlation.

Like other measures of strength of association, Spearman's correlation statistic is not affected by sample size.

*/

/*
Performing a Mantel-Haenszel Chi-Square Test of Ordinal Association

In an earlier demonstration, we produced a crosstabulation table for IncLevel by Purchase in the Sales_Inc data set. Remember that IncLevel and Purchase both have logically ordered values. This table indicates a possible association between IncLevel and Purchase. Notice that customers' purchasing habits are fairly similar for low and medium income levels but fairly different in the high income level. 

To determine whether the association is significant, we could use the Pearson chi-square test for general association. However, because IncLevel is ordinal and we can consider Purchase to be ordinal, it's a good idea to test specifically for an ordinal association. So, we'll run a Mantel-Haenszel chi-square test. 

Let's look at the code.
*/
proc freq data=statdata.sales_inc;
   tables IncLevel*Purchase / chisq measures cl;
   format IncLevel incfmt. Purchase purfmt.;
   title1 'Ordinal Association between IncLevel and Purchase?';
run;

title;
/* In this PROC FREQ step, the TABLES statement specifies a crosstabulation table for IncLevel by Purchase as well as three options that generate various measures of association. The CHISQ option produces the Pearson chi-square, the likelihood-ratio chi-square, and the Mantel-Haenszel chi-square. It also produces measures of association based on chi-square statistics such as the phi coefficient, the contingency coefficient, and Cramer's V. The MEASURES option produces the Spearman correlation statistic along with other measures of association. The CL option produces confidence bounds for the statistics that the MEASURES option requests. 

Let's run the code. The log shows that the code ran without errors. 
*/

/* Results:
The crosstabulation table is the same as the one we produced earlier.


The first table of statistics displays the results of the Mantel-Haenszel chi-square test. The p‑value of the Mantel-Haenszel chi-square is 0.0044, which is less than 0.05, so we can reject the null hypothesis of no ordinal association. Instead, we can conclude at the 0.05 significance level that there is evidence of an ordinal association between customer income level and purchasing habits.

The last table also displays a variety of measures of association including the Spearman Correlation statistic and its 95% confidence limits. The Spearman Correlation statistic indicates the strength of an ordinal association. The value 0.1391 is close to 0, but it's positive, so there is a weak, positive ordinal association between income level and purchasing habits. As the income level increases, the purchase amount also tends to increase. Notice that the 95% confidence interval does not contain 0. This means that the positive, ordinal relationship between income level and purchasing habits is significant at the 0.05 significance level. The confidence bounds are valid only if the sample size is large. A general guideline is to have a sample size of at least 25 for each degree of freedom in the Pearson chi-square statistic. The asymptotic standard error is used for large samples and is used to calculate the confidence intervals for various measures of association, including the Spearman correlation coefficient. The asymptotic standard error measures the variability of the correlation statistic. In other words, it indicates how much error we can expect if we use the sample Spearman correlation to estimate the population Spearman correlation. 

 */

