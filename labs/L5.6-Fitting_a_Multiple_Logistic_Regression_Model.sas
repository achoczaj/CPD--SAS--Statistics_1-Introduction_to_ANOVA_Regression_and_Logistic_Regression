/*
 * Lab 5.6: Fitting a Multiple Logistic Regression Model
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Multiple Predictors Regression

Sometimes you want to create a statistical model that explains the relationships 
among multiple predictors and a categorical response. You might want to examine the effect of each individual predictor on the response regardless of the levels of the other predictors. Or you might want to perform a more complex analysis that takes into account the interactions between the predictors. For example, you could build a model that examines the effects of age, gender, and travel class on the probability of surviving the sinking of the Titanic. Or you could build a model that allows for different effects of age or gender on the probability of survival for different travel classes. Here’s what you learn in this topic.

*** Multiple Logistic Regression ***

A multiple logistic regression model characterizes the relationship between a categorical response variable and multiple predictor variables. The predictor variables can be continuous or categorical or both. The goal of multiple logistic regression, like multiple linear regression, is to find the subset of variables that best explains the variability of the response variable. To determine the best subset of variables, you eliminate the unnecessary variables. Having a smaller subset of variables is typically an advantage. Models that are parsimonious (or simple) are more likely to be numerically stable and are also easier to generalize.

Let's look at an example. Suppose you're analyzing data about a group of patients, some of whom have had heart attacks. You can fit a multiple logistic regression model to determine the effect of cholesterol, weight, and gender on the probability of having a heart attack. The predictor variables Cholesterol and Weight are continuous, and Gender is categorical.


*** The Backward Elimination Method of Variable Selection ***

One method of selecting a subset of predictor variables for a multiple logistic regression model is the backward elimination method. This method starts with a full model—a model that contains all of the main effects, that is, all of the predictor variables. Using an iterative process, the backward elimination method identifies and eliminates the nonsignificant predictor variables, one at a time. At each step, the backward elimination method removes the least significant variable of the nonsignificant terms—the variable with the largest p-value.

Let's see how the backward elimination process works in this example. In the first step, Weight has the largest p-value of the nonsignificant terms, so it's eliminated. In the next step, Cholesterol is the only remaining nonsignificant term, so it's eliminated. Gender is significant, so it remains in the model. The backward elimination process is finished. The resulting model can only include significant main effects.

When you choose a significance level, think about how much evidence you need to determine that a predictor variable is significant. Here's a question: If you want a more parsimonious model, should you choose a larger or smaller significance level? The smaller your significance level, the more evidence you need to keep a predictor variable in the model. This results in a more parsimonious model.


*** Adjusted Odds Ratios ***

One major difference between a multiple logistic regression model and a logistic regression model with only one predictor variable is that odds ratios are reported differently. Multiple logistic regression uses adjusted odds ratios. An adjusted odds ratio measures the effect of a single predictor variable on a response variable while holding all the other predictor variables constant. Holding variables constant means that all observations are held at the same value. 

For example, the adjusted odds ratio for the variable Gender would measure the effect of Gender on H_Attack while holding Cholesterol and Weight constant. The adjusted odds ratio assumes that the odds ratio for Gender is the same regardless of the level of the other predictor variables. If that assumption is not true, then you need to fit a more complex model that also considers the interactions between predictor variables.


*** Specifying the Variable Selection Method in the MODEL Statement ***

To specify the method that PROC LOGISTIC uses to select variables in a multiple logistic regression model, you add the SELECTION= option to the MODEL statement. All possible values of the SELECTION= option are shown here: BACKWARD or B requests backward elimination. FORWARD or F requests forward selection. When you specify NONE, no selection method is used. Instead, PROC LOGISTIC fits the complete model specified in the MODEL statement. STEPWISE requests stepwise selection. SCORE requests best subset selection. By default, SELECTION= is set to NONE. In this example, the SELECTION= option specifies the backward elimination method to select the variables for the model. 

By default, for the backward elimination method, PROC LOGISTIC uses a 0.05 significance level to determine which variables remain in the model. If you want to change the significance level, you can use the SLSTAY= option—or SLS= for short—in the MODEL statement. You must specify a value between 0 and 1 inclusive. This example does not specify the SLSTAY= option, so PROC LOGISTIC will use the default significance level.


*** The UNITS Statement ***

In PROC LOGISTIC, the UNITS statement enables you to obtain customized odds ratio estimates for a specified unit of change in one or more continuous predictor variables. For each continuous predictor (or independent variable) that you want to modify, you specify the variable name, an equal sign, and a list of one or more units of change, separated by spaces, that are of interest for that variable. A unit of change can be a number, a standard deviation (SD), or a number multipled by the standard deviation (for example, 2*SD). 

In this example, the UNITS statement specifies the number 10 as the unit of change for the continuous predictor Age. Age specifies people's age in whole years. This UNITS statement tells PROC LOGISTIC to estimate odds ratios for Age using 10-year intervals. The UNITS statement is optional. If you want to use the units of change that are reflected in the stored data values, you do not need to include the UNITS statement.
*/


/*******************************************
Fitting a Multiple Logistic Regression Model
********************************************/
/*
This PROC LOGISTIC program fits a multiple logistic regression model that characterizes the relationship between the categorical predictor variables Gender and IncLevel, the continuous predictor variable Age, and the categorical outcome variable Purchase.
*/
ods graphics / width=700;

proc logistic data=statdata.sales_inc 
              plots(only)=(effect oddsratio);
   class Gender (param=ref ref='Male')
         IncLevel (param=ref ref='1');
   units Age=10;
   model Purchase(event='1')=Gender Age IncLevel / 
         selection=backward clodds=pl; 
   title1 'LOGISTIC MODEL (2):Purchase=Gender Age IncLevel';
run;

title;
/*
In the PROC LOGISTIC statement, the PLOTS= option specifies an effect plot and an odds ratio plot. The CLASS statement now lists both of the categorical predictor variables and specifies reference cell coding for both. The reference level for Gender is Male and the reference level for IncLevel is 1 (representing low income). The UNITS statement specifies 10-year intervals as the units of change for the continuous predictor variable Age. The MODEL statement specifies the outcome of interest and lists the three predictors, separated by spaces. The SELECTION= option specifies the backward elimination method of variable selection.

Here's a question: For the backward elimination method in PROC LOGISTIC, what is the default significance level for a predictor variable to stay in the model? The default significance level is 0.05. If you want to change the significance level, you can use the SLSTAY= option in the MODEL statement. 

The MODEL statement also specifies the CLODDS= option. This option is set to PL so that PROC LOGISTIC will calculate profile-likelihood confidence limits for the odds ratios of all predictor variables. Profile-likelihood confidence limits are based on the log likelihood and are generally preferred, especially for smaller sample sizes. The CLODDS= option also enables the production of the odds ratio plot. 

It's time to submit the code. The log shows that the step ran without errors. Let's look at the results. 
*/
/* Results:
The Model Information and Response Profile are the same as for the binary logistic regression model that we ran in the previous demonstration. It's useful to look at this information to make sure that your model is set up as you intended. The statement below the table indicates that, once again, we're modeling the probability that a person spends at least $100. 

Following a reference to the backward elimination method is the Class Level Information table. The table now lists both classification variables, Gender and IncLevel. Remember that the number of design variables is one less than the number of levels of the variable. IncLevel has three levels, so it requires two design variables. Male is the reference level for Gender, and 1 is the reference level for IncLevel. 

Notice the reference to Step 0. This is the point at which the backward elimination process starts, with a full model. 

The Model Fit Statistics table lists several goodness-of-fit measures that enable you to compare one model to another. Remember that lower values of these statistics indicate a more desirable model. However, there is no standard for determining how much of a difference indicates an improvement. Here, all three measurements indicate that the model with the intercept and predictor variables is better than the intercept-only model. 

The next table shows the results of testing the global null hypothesis. We're looking to see whether any of the parameter estimates (or betas) are significantly different from 0. Remember that the likelihood ratio test is generally preferred because it is the most reliable, especially for small sample sizes. All of the p-values are less than 0.05, so we would reject our null hypothesis and say that at least one of our regression coefficients is statistically different from 0. The note below the table says that all of the variables at Step 0 had p-values less than the default criterion of 0.05, so none of the variables were removed during the backward selection process. In this case, the final model is the full model. 

The Type 3 Analysis of Effects table shows the results of testing whether each individual parameter estimate is statistically different from 0. The coefficients for Gender, Age, and IncLevel are all statistically different from 0 because all their p-values are less than 0.05. 

The Analysis of Maximum Likelihood Estimates table provides a breakdown of the parameter estimates (the betas). The p-value for Gender=Female is 0.0139, which is less than 0.05, so the parameter estimate (0.5204) is statistically different from 0. This means that females and males (the reference level) are statistically different from one another in terms of purchasing $100 or more, holding Age and IncLevel constant. The regression coefficient for Age is 0.056 and the corresponding p-value is 0.002. Because the coefficient is positive and the p-value is significant at the 0.05 level, we can say that older people are more likely to purchase at least $100 than younger people are, holding Gender and IncLevel constant. The p-value for IncLevel=3 is 0.0014, which is less than 0.05. The parameter estimate (0.8186) is statistically different from 0. This means that high-income people and low-income people (the reference level) are statistically different from one another with respect to purchasing at least $100, holding Gender and Age constant. The p-value for IncLevel=2 is 0.6887, which is greater than 0.05, so the regression coefficient (0.1064) is not statistically different from 0. This means that medium- and low-income people are not statistically different from one another in terms of purchasing habits, holding Gender and Age constant. Remember that you can use the parameter estimates in this table to construct your logistic regression equation and also to calculate the adjusted odds ratios for each of these effects. 

The Association of Predicted Probabilities and Observed Responses table lists several goodness-of-fit measures. We'll take a closer look at the information after this demonstration. 

Next, we look at the odds ratios for the main effects. Let's also look at the code. SAS displays only one odds ratios table, which contains the odds ratio estimates and the profile-likelihood confidence limits that the CLODDS= option specified. For multiple logistic regression, remember that PROC LOGISTIC calculates the adjusted odds ratios. 

Let's look at the odds ratio for the one continuous predictor, Age. For a continuous predictor, the odds ratio measures the change in odds associated with a one-unit difference of the predictor variable by default. Here's a question: Why does the Unit column for Age display the value 10 instead of 1? Remember that the UNITS statement specifies the value 10 for Age, so these calculations are based on each 10-year unit of Age. The adjusted odds ratio for Age (1.752) means that a person's odds of spending at least $100 are 1.752 times the odds of a person who is 10 years younger spending at least $100, holding Gender and IncLevel constant. For Gender, the adjusted odds ratio for females versus males is 1.683. The odds of females spending at least $100 are 1.683 times the odds of males, holding Age and IncLevel constant. The odds ratio is adjusted for Age and IncLevel because we have accounted for Age and IncLevel directly in our model. The 95% confidence interval does not include 1, so the adjusted odds ratio for Gender—1.683—is statistically significant (or statistically different from 1) at the 0.05 level. 

Now let's look at the adjusted odds ratios for IncLevel. High-income people have 2.267 times the odds of low-income people of spending at least $100, holding Gender and Age constant. Because the 95% confidence interval does not include 1, the adjusted odds ratio for high versus low income (2.267) is statistically significant at the 0.05 level. Medium-income people have 1.112 times the odds of low-income people of spending at least $100, holding Gender and Age constant. Because the 95% confidence interval includes 1, the adjusted odds ratio for medium versus low income (1.112) is not statistically significant at the 0.05 level. In the odds ratios plot, the dots represent the odds ratio estimates and the horizontal lines represent the confidence intervals for those estimates. The only confidence interval that crosses 1 is for medium-income versus low-income customers. So, this is the only odds ratio that is not statistically different from 1. On the other hand, the 95% confidence interval for females versus males does not cross 1, so the odds ratio for Gender is statistically different from 1. This also indicates that there is an association between Gender and Purchase. 

The effect plot shows the probability of a person's spending at least $100, as predicted by the model, based on their age, gender, and income. The vertical axis represents the predicted probability of a person's spending at least $100. Age is on the horizontal axis. Each level of Gender and IncLevel is plotted as a separate line defined in the legend at the bottom. We can easily see the positive trend for Age, with probability values ranging from about 0.10 to 0.30 at age 20 to about 0.50 to 0.80 at age 60. So, older people have a greater tendency of purchasing $100 or more than younger people do. Females with high income have the highest probability of spending at least $100, while males with low income have the lowest probability.
 */
