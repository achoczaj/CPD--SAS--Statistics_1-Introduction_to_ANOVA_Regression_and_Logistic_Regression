/*
 * Lab 5.8: Fitting a Multiple Logistic Regression Model with All Odds Ratios
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
***The ODDSRATIO Statement***

By default, PROC LOGISTIC produces the odds ratio only for variables that are not involved in an interaction. The odds ratio for a main effect within an interaction would be misleading. It would only show the odds ratio for that variable, holding constant the other variable at the value 0, which might not even be a valid value.

To tell PROC LOGISTIC to produce the odds ratios for each value of a variable that is involved in an interaction, you can use the ODDSRATIO statement.  You specify a separate ODDSRATIO statement for each variable. In the ODDSRATIO statement, you can optionally specify a label for the variable. The variable name is required. At the end, you can specify options following a forward slash. In this example, there are three ODDSRATIO statements, one for each main effect. Notice that the ODDSRATIO statements for the variables do not have to appear in the same order that the variables are listed in the MODEL statement.

Let's look at some of the options that are available for the ODDSRATIO statement. 

The CL= option enables you to specify the type of confidence limits you want to produce: Wald, profile-likelihood, or both. By default, PROC LOGISTIC produces Wald confidence limits. In this example, all three ODDSRATIO statements specify profile-likelihood confidence limits. 

The DIFF= option applies only to categorical variables. Using the DIFF= option, you can specify whether PROC LOGISTIC computes the odds ratios for a categorical variable against the reference level or against all of its levels. By default, DIFF= is set to ALL. However, in this example, the DIFF= option is set to REF for the two categorical variables, Gender and IncLevel. In the ODDSRATIO statement for Gender, DIFF=REF tells PROC LOGISTIC to calculate the odds ratio against the reference level, which is Male. Here's a question: For IncLevel, which level or levels will PROC LOGISTIC calculate the odds ratio against? In the ODDSRATIO statement for IncLevel, DIFF=REF tells PROC LOGISTIC to calculate the odds ratio against the reference level, which is 1. 

The AT option specifies fixed levels of one or more interacting variables (also called covariates). PROC LOGISTIC computes odds ratios at each of the specified levels. For each categorical variable, you can specify a list of one or more formatted levels of the variable, or the keyword REF to select the reference level, or the keyword ALL to select all levels of the variable. ALL is the default setting for categorical variables. You enclose this information in parentheses. 

In this example, the AT option is specified in the ODDSRATIO statements for the two categorical variables. In the ODDSRATIO statement for Gender, the AT option specifies IncLevel as the interacting variable, and the ALL keyword. So, PROC LOGISTIC will calculate odds ratios against the reference level of Gender as compared with all levels of IncLevel. In the ODDSRATIO statement for IncLevel, the AT option specifies Gender as the interacting variable, and the ALL keyword. So, PROC LOGISTIC will calculate odds ratios against the reference level of IncLevel as compared with all levels of Gender. ALL is the default setting for categorical variables, so it's not necessary to specify it here. However, specifying the ALL keyword makes your code easier to understand. You can also use the AT option with continuous variables, although it's not specified for the continuous variable Age in this example. 

Here's a list of the odds ratios that this code produces.
 */

/****************************************************************
Fitting a Multiple Logistic Regression Model with All Odds Ratios
*****************************************************************/
/*
In this demonstration, we want to refine the multiple logistic regression model that we fit in the last demonstration. The results from the last demonstration are shown here. Now we want to produce the odds ratios for each value of variables that are involved in an interaction. We'll include only the significant terms. 

In this modified program, we've added an ODS SELECT statement to restrict the results to two items: a table and a plot that show odds ratios and profile-likelihood confidence limits.
*/
ods graphics / width=700;
ods select OddsRatiosPL ORPlot;

proc logistic data=statdata.sales_inc 
              plots(only)=(oddsratio);
   class Gender (param=ref ref='Male')
         IncLevel (param=ref ref='1');
   units Age=10;
   model Purchase(event='1')=Gender | IncLevel Age;
   oddsratio Age / cl=pl;
   oddsratio Gender / diff=ref at (IncLevel=all) cl=pl;
   oddsratio IncLevel / diff=ref at (Gender=all) cl=pl;
   title1 'LOGISTIC MODEL (3a): Significant Terms and All Odds Ratios';
   title2 '/ sel=backward';
run;

title;
/*
In the PROC LOGISTIC step, the PLOTS= option now specifies only an odds ratio plot. The MODEL statement specifies all of the significant terms that remained in the final model: Gender, IncLevel, the interaction of Gender and IncLevel, and Age.

At the end of the MODEL statement, notice that we've removed the SELECTION= and CLODDS= options that specify the backward elimination method and profile-likelihood confidence intervals, respectively. We don't need to use backward selection because we know that all specified terms are significant and will remain in the model. 

Here's a question: We want to calculate profile-likelihood confidence limits, so why don't we need the CLODDS= option? The profile-likelihood confidence limits are now specified in the three ODDSRATIO statements that we've added below. The first ODDSRATIO statement calculates the odds ratio for Age, where the units of Age are set to 10-year intervals. The second ODDSRATIO statement calculates the odds ratio for Gender against the reference level (Male) as compared with the levels of IncLevel. And the third ODDSRATIO statement calculates the odds ratio for IncLevel against the reference level (1 or low income) as compared with all levels of Gender. 

Let's submit the program. The log indicates that the code ran without problems. Let's look at the results. 
*/
/* Results:
The table lists the adjusted odds ratio estimates with corresponding confidence intervals for Age as well as each value of interacting variables. 

The adjusted odds ratio for Age—1.716—indicates that a person's odds of spending at least $100 are 1.716 times the odds of a person who is 10 years younger spending at least $100, holding Gender and IncLevel constant. Because the 95% profile-likelihood confidence interval does not include 1, the adjusted odds ratio for Age is statistically significant (or significantly different from 1) at the 0.05 level. 

The odds ratio 0.831 indicates that the odds that a female with a level 3, or high, income will purchase at least $100 are less than the odds of a male with a high income. Because the 95% confidence interval includes 1, the adjusted odds ratio is not significant, indicating that there is no difference between the odds of females and males with a high income purchasing at least $100. 

The odds ratio 2.797 indicates that the odds that a female with low income will purchase at least $100 are more than the odds of a male with low income. Because the 95% confidence interval does not include 1, the adjusted odds ratio is significant. In other words, there is a difference between the odds of females and males with low income purchasing at least $100. 

The odds ratio 1.407 indicates that the odds of a female with high income purchasing at least $100 are higher than the odds of a female with low income. Because the 95% confidence interval includes 1, there is no difference between the odds of females with high income and females with low income purchasing at least $100. 

The odds ratio 4.733 indicates that the odds of a male with high income purchasing at least $100 are higher than the odds of a male with low income. Because the 95% confidence interval does not include 1, there is a difference between the odds of males with high income and males with low income purchasing at least $100. 

This plot shows graphically what we saw with the calculated confidence intervals in the table above. The dots represent the odds ratio estimates, and the horizontal lines represent the confidence intervals for those estimates. If the 95% confidence intervals cross 1, the corresponding adjusted odds ratio is not statistically different from 1. For example, the odds ratios for the following are not statistically different from 1: females versus males with high income, high-income versus low-income females, medium-income versus low-income females, and medium-income versus low-income males.
*/