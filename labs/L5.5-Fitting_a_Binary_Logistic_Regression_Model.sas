/*
 * Lab 5.5: Fitting a Binary Logistic Regression Model
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Introduction to Logistic Regression

After you perform tests of association, you might also want 
to build a logistic regression model to characterize the relationship 
between variables. 

A statistical model can help you to make predictions, 
such as who is likely to survive a shipwreck 
or which customers are likely to buy the most merchandise.


*** Logistic Regression ***

Logistic regression is a type of statistical model that you can use to predict a categorical response, or outcome, on the basis of one or more continuous or categorical predictor variables. Logistic regression is in a category of statistical models called generalized linear models. Two other examples of generalized linear models are linear regression and ANOVA. 

There are three logistic regression models to choose from: binary logistic regression, nominal logistic regression, and ordinal logistic regression. You select the appropriate model based on the characteristics of your response variable. If your response variable is dichotomous (which means that it has two categories, or levels), you use the binary logistic regression model. If your response variable has more than two categories, then you look at the measurement scale of the response variable to determine which logistic regression model is appropriate. If the response variable is nominal, you fit a nominal logistic regression model. If the response variable is ordinal, you fit an ordinal logistic regression model.


*** Modeling a Binary Response ***

When you're working with a categorical response variable that's binary, you might be tempted to use linear regression techniques instead of logistic regression. After all, linear and logistic regression models have similar structures regarding the use of a linear predictor. Let's look at some reasons why you can't use linear regression with a binary response variable.

This equation shows the relationship between the response variable Y and the predictor variable X for a simple linear regression model. Estimates of the unknown population parameters β0 and β1 are obtained by the method of least squares.

A linear regression model assumes that the data is continous but this is not true of binary data. Also, in a linear regression model, you assume that the mean of the response is equal to β0+β1X. However, for binary data, the mean of the response is the probability of a success. 

Suppose you're working with a binary response variable that has the values Yes and No. You can code the values numerically: Yes=1 and No=0. But these values are still categories and the coding is arbitrary. If we assume that the probability of a success follows the linear regression relationship, then, for some values of the predictor variables, we'll get predicted values of the response outside of the range of 0 and 1. Values outside this range are not valid probabilities. Also, if the response variable has only two levels, you cannot assume the constant variance and normality that are required for linear regression.

Let's do a quick comparison of linear regression and binary logistic regression. Linear regression uses a predictor variable (X) to estimate the conditional mean of the response (Y), which is continuous. With linear regression, you assume that the expected value of the response, given the predictor, has a linear relationship with the predictor variable. The conditional mean of the response has the linear form β0+β1X, and it ranges from negative infinity to positive infinity. 

Binary logistic regression uses a predictor variable to estimate the probability of a specific outcome. To directly model the relationship between a continuous predictor (X) and the probability of an event or outcome, you must use a nonlinear function. This plot shows what a logistic regression curve looks like. This is a plot of the inverse logit function. In the function, p is the probability. With binary logistic regression, the mean of the response is a probability, which is between 0 and 1. The inverse logit function binds the linear predictor between 0 and 1.

A logistic regression model applies a logit transformation to the probabilities so that the transformed probabilities and predictor variables end up with a linear relationship. This occurs by taking the inverse logit function and solving for the linear predictor β0+β1Xi. The logit is the natural log of the odds—the probability of the event occurring divided by the probability of the event not occurring. In logistic regression, we make the assumption that the logit transformation of the probabilities results in a linear relationship with the predictor variables. In other words, we can use a linear function of X to model the logit in order to indirectly model the probability.

This is the binary logistic regression model. The logit(pi) is the logit transformation of the probability of the event. β0 is the intercept of the regression equation. β1 is the slope parameter of Xi.


*** The LOGISTIC Procedure ***

To model categorical data—in other words, when your response variable is categorical—you use the LOGISTIC procedure. In a logistic regression model, remember that your predictor variables can be categorical, continuous, or both. Depending on the complexity of your analysis, you can use many different statements in PROC LOGISTIC. Some of the most common statements are shown here: the two required statements—PROC LOGISTIC and MODEL—as well as the CLASS, UNITS, and ODDSRATIO statements. Let's look at the syntax of a basic PROC LOGISTIC step that contains only the PROC LOGISTIC, CLASS, and MODEL statements.

The PROC LOGISTIC statement specifies the name of the data set that you're working with. After the name, you can specify a variety of options. For example, you can specify the plots that you want ODS Graphics to produce. 

If your model has one or more categorical predictor variables, you must specify them in the CLASS statement. The variables in the CLASS statement are also called classification variables. You use a space between multiple variables. Following a variable name, you can specify options for that variable within parentheses. At the end of the CLASS statement, following a forward slash, you can specify options that control how PROC LOGISTIC works with all of the specified variables. If you use the CLASS statement, it must precede the MODEL statement. 

The MODEL statement specifies the response variable and other information as well. In the form shown here, you specify the response variable name, an equal sign, and then the names of one or more predictor variables. Following the reponse variable name, you can specify options that pertain to the response variable in parentheses. You must also specify any categorical predictor variables in the CLASS statement above. At the end of the MODEL statement, following a forward slash, you can specify options that apply to the model in general.

Here's an example. The PROC LOGISTIC statement specifies the Sales_Inc data set. The PLOTS= option will display only the effect plot. The CLASS statement specifies one classification variable: the categorical predictor variable Gender. No options are currently specified in the CLASS statement. 

The MODEL statement specifies the response variable Purchase. Following the response variable name, in parentheses, the variable option EVENT= specifies the event category for the binary response model. PROC LOGISTIC models the probability of the event category. You can specify the value of the event category in quotation marks, or you can specify the keyword FIRST or LAST. In this example, the event category is the value 1 for Purchase. The predictor variable is Gender.

CLODDS= is an example of a general option that you can specify in the MODEL statement. This option computes confidence intervals for the odds ratios of all predictor variables. Following the equal sign, you specify a keyword to indicate the type of confidence intervals that you want to use: PL for profile likelihood, WALD, or BOTH. If you don't specify the CLODDS= option, PROC LOGISTIC computes Wald confidence intervals by default. This example now uses the CLODDS= option to request profile-likelihood confidence intervals for the odds ratios. Profile-likelihood confidence intervals are desirable for small sample sizes. The CLODDS= option also enables the production of the odds ratio plot that's specified in the PLOTS= option above. For now, let's remove the CLODDS= option and use the default confidence intervals.


*** Specifying a Parameterization Method in the CLASS Statement ***

PROC LOGISTIC does not work directly with the categorical predictor variables in the CLASS statement. Instead, PROC LOGISTIC first parameterizes (or codes) each predictor variable. Let's see why. 

Remember that PROC LOGISTIC assumes a linear relationship between a predictor variable and the logit of the response. But when the predictor variable is categorical, the assumption of linearity cannot be met. For example, if you're working with the predictor variable Gender, it doesn't make sense to say that moving from one gender to another increases or decreases the logit of the response by beta amount. To get past the obstacle of nonlinearity, the CLASS statement creates a set of one or more design variables that represent the information in each specified classification variable. Design variables are sometimes called dummy variables. PROC LOGISTIC uses the design variables, and not the original variables, in model calculations. 

There are various methods of parameterizing the classification variables. Two common parameterization methods, or coding schemes, are effect coding and reference cell coding. It's important to understand a little bit about each method so that you can decide which method to use in your analysis. Different parameterization methods will produce the same results regarding the significance of the categorical predictors. But understanding the parameterization method will help you to interpret your results accurately. The CLASS statement specifies which parameterization method PROC LOGISTIC uses. By default, PROC LOGISTIC uses effect coding. If you specify only a variable in the CLASS statement, as in this example, PROC LOGISTIC uses effect coding. To specify a parameterization method other than the default, such as reference cell coding, you use the PARAM= option in the CLASS statement. The keyword for reference cell coding is either REFERENCE or REF, as in this example.

As the default reference level for either effect coding or reference cell coding, PROC LOGISTIC uses the level that has the highest ranked value—or, the last value—when the levels are sorted in ascending alphanumeric order. In this example, for Gender, Male is the default reference level. If you want to specify a reference level, you use the REF= variable option. You can specify the actual value (or level) in quotation marks or the keyword FIRST or LAST. In this example, for the classification variable Gender, the REF= option specifies Male as the reference level. Here's a question: In this example, is it necessary to specify Male as the reference level? Male is the default reference level, so it's not necessary to specify it. However, including the REF= option makes your code easier to understand at a glance.


*** Effect Coding ***

Effect coding is a method of parameterizing (or coding) the classification variables—the categorical predictor variables specified in the CLASS statement. This method is also called deviation from the mean coding. Effect coding compares the effect of each level of the variable to the average effect of all levels. In this example, you can use effect coding to test whether the effect of having a particular income level, such as income level 1, or low income, is different from the average effect of all three income levels. 

As shown in this design matrix, PROC LOGISTIC creates design variables for each classification variable. For effect coding, the number of design variables, or betas, that PROC LOGISTIC creates is the number of levels of the classification variable minus 1. In this example, IncLevel has three levels, so PROC LOGISTIC creates two design variables. As the default reference level, PROC LOGISTIC uses the level that has the highest ranked value—or, the last value—when the levels are sorted in ascending alphanumeric order. With effect coding, all design variables for the reference level have a value of -1. The design variables for all other levels of the classification variable are set to 0 or 1. This formula shows how the betas (the estimates of the parameters) are interpreted when effect coding is the parameterization method. β0 is the intercept, but it is not the intercept in terms of where you cross the y axis. Instead, β0 is the average value of the logit across all income levels. β1 is the difference between the logit for income level 1, or low income, and the average logit across all income levels. β2 is the difference between the logit for income level 2, or medium income, and the average logit across all income levels. 

Here's the Analysis of Maximum Likelihood Estimates table that PROC LOGISTIC generates for this example, using effect coding for the classification variable. If you use effect coding, the parameter estimates and p-values reflect differences from the overall mean value over all levels. The values in the Estimate column are the estimates for the betas defined in the formula. IncLevel 1 designates the design variable for the first level of the IncLevel variable (which is 1, or low income) and IncLevel 2 designates the design variable for the second level of the IncLevel variable (which is 2, or medium income). For effect coding, the p-values indicate whether each particular level is significant compared to the average effect of all levels. The p-value for IncLevel 1 is 0.1273, which indicates that the effect of low income is no different than the average effect of low, medium, and high income. The p-value for IncLevel 2 is also not significant, so the effect of medium income is no different than the average effect of low, medium, and high income.


*** Reference Cell Coding ***

Reference cell coding is a commonly used method of parameterizing (or coding) the classification variables—the categorical predictor variables specified in the CLASS statement. To specify reference cell coding, you specify the PARAM= option in the CLASS statement and set it to REFERENCE or REF. 

Reference cell coding compares the effect of each level of the predictor variable to the effect of another level that is the designated reference level. As the default reference level, PROC LOGISTIC uses the level that has the highest ranked value—or, the last value—when the levels are sorted in ascending alphanumeric order. The reference level is the intercept. In this example, income level 3 (high income) is the default reference level. You can use reference cell coding to test whether the effect of having a particular income level, such as a low income, is different from having a high income.

As shown in this design matrix, PROC LOGISTIC creates design variables for each classification variable. For reference cell coding, the number of design variables, or betas, that PROC LOGISTIC creates is the number of levels of the classification variable minus 1. In this example, IncLevel has three levels, so PROC LOGISTIC creates two design variables. With reference cell coding, all design variables for the reference level have a value of 0. The design variables for all other levels of the classification variable are set to 0 or 1.

This formula shows how the betas (the estimates of the parameters) are interpreted when reference cell coding is the parameterization method. β0 is the intercept, but not in terms of where you cross the Y axis. Instead, β0 is the value of the logit of the probability when income is high (or at the reference level). β1 is the difference between the logit of the probability for low and high income. β2 is the difference between the logit of the probability for medium and high income. 

Here's the Analysis of Maximum Likelihood Estimates table that PROC LOGISTIC generates for this example, using reference cell coding for the classification variable. The values in the Estimate column are the estimates for the betas in the formula. IncLevel 1 designates the design variable for the first level of the IncLevel variable (which is 1, or low income) and IncLevel 2 designates the design variable for the second level of the IncLevel variable (which is 2, or medium income). For reference cell coding, the p-values indicate whether each particular level is significant compared to the reference level, which is 3 (or high income). For example, the p-value for IncLevel 1 is 0.0064, which is less than 0.05. This indicates that the effect of a low income is statistically different than the effect of a high income on the probability that people will spend at least $100. The p-value for IncLevel 2 is also significant, so the effect of a medium income is statistically different than the effect of a high income on the probability that people will spend at least $100.
*/


/*****************************************
Fitting a Binary Logistic Regression Model
******************************************/
/*
We already know that there is a significant association between the categorical predictor variable, Gender, and the categorical outcome variable, Purchase, in the Sales_Inc data set. This PROC LOGISTIC program helps us to characterize the relationship between Gender and Purchase.
*/
ods graphics / width=700;

proc logistic data=statdata.sales_inc
              plots(only)=(effect);
   class Gender (param=ref ref='Male'); 
   model Purchase(event='1')=Gender; 
   title1 'LOGISTIC MODEL (1):Purchase=Gender';
run;

title;
/*
The PLOTS= option in the PROC LOGISTIC statement will display only the effect plot. The keyword ONLY suppresses the default plots. The CLASS statement specifies the categorical predictor variable Gender. Instead of the default parameterization method, which is effect coding, the CLASS statement specifies reference cell coding and Male as the reference level. In the MODEL statement, the event of interest is a value of 1 for Purchase, indicating a customer who spent at least $100 on merchandise.

We submit the program. The log shows that the code ran without errors. A note indicates the probability that PROC LOGISTIC is modeling. Let's look at the results. We look at the first few tables to make sure that the model is set up the way we want. 
*/
/* Results:
The Model Information table describes the data set, the response variable, the number of response levels, the type of model, the algorithm used to obtain the parameter estimates, and the number of observations read and used. 

The Response Profile table shows the values of the response variable, listed according to their ordered value and frequency. By default, PROC LOGISTIC orders the values of the response variable alphanumerically and bases the logistic regression model on the probability of the lowest value. However, we set the EVENT= option to 1, the highest value, so this model is based on the probability that Purchase=1 (the probability that the person spent at least $100). Below this table, we see the probability that PROC LOGISTIC is modeling, as shown in the log. 

The Class Level Information table displays the predictor variable in the CLASS statement: Gender. Our program specifies the PARAM=REF and REF='Male' options, so this table indicates that Male is the reference level. The design variable has the value 1 when Gender=Female and 0 when Gender=Male. 

The Model Convergence Status simply indicates that the convergence criterion was met. There are a number of options to control the convergence criterion, but the default is the gradient convergence criterion with a default value of 1E-8. 

The Model Fit Statistics table reports the results of three tests. AIC is Akaike's Information Criterion. SC is the Schwarz Criterion, which is also known as Schwarz's Bayesian Criterion. -2Log L is -2 times the log likelihood. AIC and SC are goodness-of-fit measures that you can use to compare one model to another. AIC and SC are not dependent on the number of terms in the model. For both AIC and SC, lower values indicate a more desirable model. AIC adjusts for the number of predictor variables, and SC adjusts for the number of predictor variables and the number of observations. SC uses a bigger penalty for extra variables and therefore favors more parsimonious models. If you are trying to come up with the best explanatory model, AIC is the best of the three statistics to use. If you are trying to come up with the best predictive model, SC is the best statistic to use. You can compare the AIC and SC columns for the model with the intercept only and the model with the intercept and the predictor variables. Remember that lower values indicate a more desirable model. If you are only considering these two models and if you want a better explanatory model, the AIC is lower for the second model, so the second model is better. If you want a better predictive model, the SC is lower for the first model, so the first model is better. In a few minutes, we'll use the second column to compare against other models with different variables to see which model is more desirable. 

The table called Testing Global Null Hypothesis: BETA=0 provides three statistics to test the null hypothesis that all regression coefficients in the model are 0. We can look at the chi-square statistics and p-values to determine whether any of the parameter estimates (or betas) are significantly different from 0. The Likelihood Ratio test is the most reliable of the three tests, especially for small sample sizes. The Likelihood Ratio test statistic is similar to the overall F test in linear regression. The Score and Wald tests are also used to test whether all the regression coefficients are 0. Here, all of the p-values are less than 0.05, so we would reject our null hypothesis and say that at least one of our regression coefficients is statistically different from 0. 

The Type 3 Analysis of Effects table is generated when the CLASS statement specifies a categorical predictor variable. The Wald chi-square statistic tests the listed effect. Because Gender is the only predictor variable in the model, the value listed in the table will be identical to the Wald test in the Testing Global Null Hypothesis table. 

Here's a question: Is the parameter estimate of Gender statistically different from 0? The parameter estimate is statistically different because the p-value is less than 0.05. 

The Analysis of Maximum Likelihood Estimates table lists the estimated model parameters, their standard errors, Wald test statistics, and corresponding p-values. The parameter estimates are the estimated coefficients of the fitted logistic regression model. The regression coefficient (or parameter estimate) for β0 (the intercept) is -0.7566. This is the logit of the probability that males will spend at least $100 because males are the reference level. The regression coefficient for β1 is 0.4373. This is the difference in the logit of the probability of females and males spending at least $100. We can use the parameter estimates to construct the logistic regression equation, which is shown here. The Wald chi-square statistics and corresponding p-values test whether the parameter estimates are significantly different from 0. For this example, the p-values for both the intercept and the variable Gender are significant at the 0.05 significance level. The p-value for Gender is 0.0312, which is the same as the p-value in the Type 3 Analysis of Effects table. The significant p-value means that there is an association between Gender and Purchase, so females and males are statistically different from one another in terms of purchasing $100 or more. 

The next table shows the odds ratio of females to males for the modeled event. Notice that PROC LOGISTIC calculates Wald confidence limits by default. 

The Association of Predicted Probabilities and Observed Responses table lists several goodness-of-fit measures. We'll take a closer look at the information in these two tables after this demonstration. 

Let's finish up by looking at the effect plot, which shows the levels of the CLASS predictor variable versus the probability of the desired outcome. In other words, this plot shows the probability of males versus females spending at least $100, as predicted by our model. The vertical axis represents the predicted probability of a customer spending at least $100. Gender is on the horizontal axis. Females have a higher predicted probability of spending at least $100 than males.
*/

/*
*** Interpreting the Odds Ratio for a Categorical Predictor***

To help interpret the odds ratio output from the demonstration that we just finished, let's see how to calculate the odds and the odds ratio from the logistic regression model. Here is the logistic regression model that predicts the logit of p. The logit is the natural log of the odds or the natural log of p divided by the quantity 1-p. The logit of p is also equal to the linear predictor for our model: β0+β1*Gender. Remember that our model uses reference cell coding for the categorical predictor variable Gender, with Male as the reference level. So, females are coded 1 and males are coded 0. 

To obtain the odds for females, we exponentiate the linear predictor for females. First, we substitute 1 for Gender to get β0+β1 as the linear predictor for females. Then we add the parameter estimates that we got for β0 and β1 and exponentiate the sum. To obtain the odds for males, we follow the same process. First, we substitute 0 for Gender to get β0 as the linear predictor for males. Then we take the parameter estimate that we got for β0 and exponentiate it. The odds ratio of females is the odds for females divided by the odds for males. Mathematically, this works out to e^β1, so we can divide the two values we just calculated, or we can simply take the parameter estimate that we got for β1 and exponentiate it. 

We're ready to take a closer look at the the odds ratio table that PROC LOGISTIC created for the categorical predictor variable Gender. Remember that we modeled the probability of a customer spending more than $100. The odds ratio of females to males for this event is 1.549. This means that the odds of females spending $100 or more are 1.55 times the odds of males spending $100 or more. The 95% confidence limits indicate that we are 95% confident that the true odds ratio is between 1.04 and 2.31. The 95% confidence interval does not include 1, so the odds ratio 1.549 is significant at the 0.05 level. This odds ratio indicates that there is an association between Gender and Purchase.

PROC LOGISTIC uses a 0.05 significance level and a 95% confidence interval by default. If you want to specify a different significance level for the confidence interval, you can use the ALPHA= option in the MODEL statement. You must specify a value for number between 0 and 1.


*** Interpreting the Odds Ratio for a Continuous Predictor ***

Now let's see how to interpret the odds ratio for a continuous predictor variable, which is a little different than for a categorical variable. In this example, you're examining the relationship between the continuous predictor Age, which stores each customer's age in years, and the categorical response Purchase. This PROC LOGISTIC step fits the regression model for Age as the predictor and Purchase as the response. PROC LOGISTIC models the probability of purchasing $100 or more of merchandise, which is the probability that Purchase=1.

Here is the odds ratio table that this PROC LOGISTIC step creates. For a continuous predictor variable, the odds ratio measures the increase or decrease in odds associated with a one-unit difference of the predictor variable by default. For example, Age has an odds ratio of 1.052. This means that the odds of a person spending $100 or more is 1.052 times the odds of someone who is one year younger spending $100 or more. If you start with this odds ratio and subtract the odds ratio of two people of the same age, which is 1, there is a 5.2% difference. So, a person has 5.2% greater odds of spending $100 or more than someone who is one year younger. Notice that the 95% confidence interval for Age does not include 1, so the odds ratio 1.052 is significantly different from 1 at the 0.05 level.


*** Comparing Pairs to Assess the Fit of a Logistic Regression Model ***

If a logistic regression model predicts its own data accurately, then we say that the model fits the data well. PROC LOGISTIC calculates several different goodness-of-fit measures and displays the resulting statistics in the Association of Predicted Probabilities and Observed Responses table. The table shown here is from the last demonstration. One of these goodness-of-fit methods is comparing pairs. Let's take a closer look at how PROC LOGISTIC compares pairs. 

We're analyzing the relationship between the categorical predictor Gender and the categorical response Purchase. To start, PROC LOGISTIC creates two groups of observations, one for each value of the response variable, Purchase. One group contains all of the observations in which the value of Purchase is 0. These are the people who spent less than $100.  The other group contains all of the observations in which the value of Purchase is 1. These are the customers who spent $100 or more, which is the desired outcome. PROC LOGISTIC then selects pairs of observations, one from each group, until no more pairs can be selected. PROC LOGISTIC determines whether each pair is concordant, discordant, or tied. Let's look at each type of pair. 

Suppose a pair consists of a man from the "less than $100" group and a woman from the "$100 or more" group. We know that customers have a different predicted probability of spending the target amount, based on their gender. A man has a lower predicted probability (0.32) and a woman has a higher predicted probability (0.42) of spending that amount. In this pair, the woman spent the higher amount and the man did not, as the model predicts. A pair is concordant if the model predicts it correctly. In other words, a pair is concordant if the observation with the desired outcome has a higher predicted probability, based on the model, than the observation without the outcome. 

Let's look at another pair. Suppose a woman is chosen from the "less than $100" group and a man is chosen from the "$100 or more" group. From our model, we know that a woman has a higher predicted probability (0.42) and a man has a lower predicted probability (0.32) of spending $100 or more. However, in this pair, the man spent $100 or more but the woman did not. Our model did not predict this pair correctly, so it is a discordant pair. A pair is discordant if the observation with the desired outcome has a lower predicted probability than the observation without the outcome.

Let's look at one more pair, which consists of a woman from each group. According to our model, both have a predicted probability of 0.42 of spending $100 or more, so our model cannot distinguish between them. A pair is tied if it is neither concordant nor discordant—the probabilities are the same. Here's a question: If a pair consists of two men, is it a tied pair? In this example, a tied pair can consist of either two women or two men. Either way, the probabilities are the same and the model cannot distinguish between them.

This table summarizes the combinations that make up the three types of pairs in this analysis. When a pair consists of a female from the group of customers with the desired outcome and a male from the group of customers without the outcome, then the pair is concordant. The pair fits the model. When a pair consists of a male from the group of customers with the desired outcome and a female from the group of customers without the outcome, then the pair is discordant. The pair does not fit the model. When a pair consists of either two males or two females, they have the same predicted probability, and the pair is tied. The predictor variable Gender has only two levels, so there are only two predicted probabilities for the outcome of purchasing $100 or more. More complex models have more than two predicted probabilities. However, regardless of the model's complexity, the same comparisons are made across all pairs of observations with different outcomes. 

Let's take another look at the Association of Predicted Probabilities and Observed Responses table. The left column lists the percentage of pairs of each type: concordant, discordant, and tied. At the bottom is the total number of observation pairs on which the percentages are based. In this example, there are 43,578 pairs of observations with different outcome values. The frequency table for Purchase that we generated in an earlier demonstration shows where the total number of pairs comes from. The data set contains 162 observations with an outcome of $100 dollars or more and 269 observations with an outcome of under $100 dollars. We multiply 162 by 269 to get 43,578 pairs of observations that have different outcome values. You can use the percentages of concordant, discordant, and tied pairs as goodness‑of‑fit measures to compare one model to another. In general, higher percentages of concordant pairs and lower percentages of discordant and tied pairs indicate a more desirable model. 

This table also shows the four rank correlation indices that are computed from the numbers of concordant, discordant, and tied pairs of observations: Somers' D, Gamma, Tau-a, and c. In general, a model with higher values for these indices has better predictive ability than a model with lower values. Of these indices, c is the most commonly used. The concordance index, c, estimates the probability of an observation with the desired outcome having a higher predicted probability than an observation without the desired outcome. C is calculated as the number concordant outcomes plus ½ times the number of ties divided by the total number of pairs.
 */