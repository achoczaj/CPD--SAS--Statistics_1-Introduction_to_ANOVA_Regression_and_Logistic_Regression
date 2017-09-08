/*
 * Lab 5.7: Fitting a Multiple Logistic Regression Model with Interactions
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
*** Comparing the Binary and Multiple Logistic Regression Models ***

Let's compare the multiple logistic regression in the demonstration that we just finished—the Gender, Age, and IncLevel model—with the binary logistic regression that we ran in an earlier demonstration—the Gender-only model. We'll look at several fit statistics in the output. 

Looking at the Model Fit Statistics tables, you can see that adding Age and IncLevel to the model decreased the AIC and SC. This decrease indicates that the multiple predictor model is better as either an explanatory or predictive model. 

In the Association of Predicted Probabilities and Observed Responses table, we can see the percent of concordant, discordant, and tied pairs. In the multiple predictor model, the percent of concordant pairs is 63.2, which is an increase from the Gender-only model. In the Gender-only model, the percent of concordant pairs was 30.1. This increase is good. The percent of discordant pairs is 35.9, which is also an increase from the Gender-only model. In the Gender-only model, the percent of discordant pairs was 19.5. This increase is bad. The percent of tied pairs is 1, which is a decrease from the Gender-only model. In the Gender-only model, the percent of tied pairs was 50.4. We expect to see a drastic decrease because tied pairs aren't very common when there are continuous variables in the model. 

Remember that the c statistic (0.637) measures the predictive ability of our logistic regression model. In the Gender-only model, the c statistic was only 0.553. This increase indicates that the new model has better predictive ability than the Gender-only model. Based on these statistics, we can conclude that adding the predictors Age and IncLevel improved the model.


*** Specifying a Formatted Value as a Reference Level ***

In this PROC LOGISTIC output from the last demonstration, the stored values of IncLevel might not be easy to interpret. In a situation like this, you might decide that you want your output to display text labels. Remember that you can use PROC FORMAT to create a format that displays text labels for the stored values. Then, in the PROC LOGISTIC step, you can use a FORMAT statement to assign a format to the variable. Applying a format also requires another change in the PROC LOGISTIC step. In the CLASS statement, when you use the REF= option with a variable that has either a temporary or a permanent format assigned to it, you must specify the formatted value of the level instead of the stored value. 

Here's a question: In this example, what value should you specify as the reference level for IncLevel? The REF= option for IncLevel must now specify the formatted value Low Income instead of the stored value 1. The output from this code will now display formatted values instead of stored values of IncLevel.


*** Interactions between Variables ***

When you fit a multiple logistic regression model, the simplest approach is to consider only the main effects—the effect of each predictor individually—on the response. In other words, this approach assumes that each variable has the same effect on the outcome regardless of the levels of the other variables. However, sometimes the effect of one variable, A, on the outcome depends on the observed level of another variable, B. Or the effect of B might depend on the level of A. When the effect of one variable on the outcome depends on the observed level of another variable, we say that there is an interaction. An interaction is another type of effect. If you suspect there are interactions between predictor variables, you can fit a more complex logistic regression model that includes interactions. 

Let's look at an example. Suppose you want to know how a customer's income affects the probability that the customer will default on a loan. In our logistic regression model, the response, which we'll call Default, is binary: a customer can either default or not default. Here's a graph of the logit of the predicted probability for defaulting on a loan by the customer's income. Notice that as customer income increases, the probability of defaulting on a loan decreases. However, suppose we also look at the previous credit experience of the customer. 

In our logistic regression model, we add the predictor BadCredit, a binary variable that specifies whether or not each customer has any previous defaults. As the graph shows, there is a difference in the effect of income on people with good credit compared to those with bad credit.  For people who have a good credit record, as income increases, the logit of the probability for defaulting on a loan barely decreases.  However, when we look at only the people who have bad credit, an increase in income is associated with a big decrease in the probability of defaulting. There is an interaction between a person's credit record and income. This means that the effect of a person's income on the probability that the person will default on a loan depends on the person's credit record. 

The number of possible interactions—or combinations of variables—depends on the number of main effects. In this example, there is one possible interaction: a two-factor interaction for Income and BadCredit. Suppose we want to look at the effect of education level, as well as income and credit history, on the probability of defaulting on a loan. Here's a question: How many possible interactions are there? A model with three main effects can have three 2-factor interactions and one 3-factor interaction. So there are four possible interactions for this example. Keep in mind that interactions that have more than two factors might be difficult to interpret.


*** The Backward Elimination Method with Interactions in the Model ***

When you use the backward elimination method with interactions in the model, PROC LOGISTIC begins by fitting the full model with all the main effects and interactions. In this example, we want the model to include only the two-factor interactions. 

Using an iterative process, PROC LOGISTIC eliminates nonsignificant interactions, one at a time, starting with the least significant interaction—the one with the largest p-value. For example, in the first step, suppose PROC LOGISTIC eliminates Age by IncLevel as the least significant of the nonsignificant interactions. PROC LOGISTIC then generates the model again without that interaction. Gender by Age is the only other nonsignificant interaction, so PROC LOGISTIC deletes it in step 2. Gender by IncLevel, the remaining interaction, is significant, so it stays in the model. 

When only significant interactions remain, PROC LOGISTIC turns its attention to the main effects. PROC LOGISTIC eliminates, one at a time, the nonsignificant main effects that are not involved in any significant interactions. Each time, PROC LOGISTIC eliminates the least significant interaction—the one with the largest p-value. When eliminating main effects, PROC LOGISTIC must preserve the model hierarchy. According to this requirement, for any interaction that's included in the model, all main effects that the interaction contains must also be in the model. For example, the interaction Gender by IncLevel is significant and has remained in the model, so both Gender and IncLevel must also remain in the model, whether or not they are significant. The only main effect that PROC LOGISTIC could possibly eliminate is Age, and only if Age is nonsignificant. 

In this example, Age is significant, so the backward elimination process ends at step 2. The final model has only significant interactions, the main effects involved in the interactions, and any other significant main effects.


*** Specifying Interactions in the MODEL Statement ***

You've learned how to specify the main effects in the MODEL statement. In this example, the MODEL statement lists the names of three main effects, separated by a space. 

You also specify interactions in the MODEL statement. To specify interactions concisely, you can place a bar operator between the names of each two main effects. The bar tells PROC LOGISTIC to treat the terms on either side of it as effects and also to include their combinations as interactions. If you want to limit the maximum number of variables that are involved in each interaction, you can specify the following after the list of effects: an @ sign followed by an integer indicating the maximum number of variables. In this example, @2 specifies that the model will include only the two-way interactions.
*/

/*************************************************************
Fitting a Multiple Logistic Regression Model with Interactions 
**************************************************************/

/*
In this demonstration, we'll fit a multiple logistic regression model that includes main effects and interactions between the main effects.
*/
ods graphics / width=700;

proc logistic data=statdata.sales_inc 
              plots(only)=(effect oddsratio);
   class Gender (param=ref ref='Male')
         IncLevel (param=ref ref='1');
   units Age=10;
   model Purchase(event='1')=Gender | Age | IncLevel @2/ 
         selection=backward clodds=pl; 
   title1 'LOGISTIC MODEL (3): Main Effects and 2-Way Interactions';
   title2 '/ sel=backward';
run;

title;
/*
In the PROC LOGISTIC step, the MODEL statement now lists the three main effects Gender, Age, and IncLevel as well as a bar operator between each pair to specify their interactions. Following the last effect, the @2 tells PROC LOGISTIC to include only the two-factor interactions along with the main effects. 

Let's submit the program. The log shows that the program ran successfully. The log also displays several notes about our analysis. One note indicates that the CLODDS= option does not compute odds ratios for effects within interactions. We'll see this later in the results. 

Let's look at the results. The Model Information, Response Profile, and Class Level Information tables are the same as in the multiple logistic regression model that we fit without interactions in the last demonstration. 

The backward elimination process starts at Step 0 with a full model. We can see that all main effects and two-way interactions are in the model. At Step 1, the interaction between Age and IncLevel was removed because it had the least significant (or greatest) p-value. At Step 2, the interaction between Age and Gender was removed because it had the least significant p-value. The note after Step 2 indicates that no additional effects met the 0.05 significance level for removal from the model. This means that all the variables had p-values less than 0.05. This is the final model using the backward elimination method of selection. 

The Summary of Backward Elimination table displays the terms removed at each step, along with their p-values, which are greater than 0.05. 

The terms that remain in the model are listed in the Joint Tests table: the three main effects (Gender, Age, and IncLevel) and the interaction of Gender and IncLevel. Because the interaction between Gender and IncLevel is significant, we can say that the effect that Gender has on purchasing at least $100 is dependent on income level. We'll look at a breakdown of the interaction in a minute to see where the interaction is happening. Here's a question: If the main effects Gender and IncLevel were not significant, would they remain in the model? Remember that any effects that are involved in interactions in the model must also stay in the model. For this reason, Gender and IncLevel must remain in the model whether or not they are significant. On the other hand, Age is not involved in an interaction, and it remains in the model only because it is significant. 

The Analysis of Maximum Likelihood Estimates table provides a breakdown of information for the parameter estimates (or betas). Now that the model includes interactions, we want to focus on interpreting the interactions. The p-value for the interaction term labeled Female 3 (which is females with a high income) is less than 0.05, so we can say that the effect of Gender on the probability of purchasing at least $100 is different for people with high and low incomes. However, the p-value for the interaction term labeled Female 2 (which is females with a medium income) is greater than 0.05, so we can say that the effect of Gender on the probability of purchasing at least $100 is the same for medium and low incomes. Because the p-value for Age is less than 0.05 and the estimate is positive, we can say that older people have a greater tendency of purchasing $100 or more than younger people do, holding Gender and IncLevel constant. 

Let's scroll down to the effect plot. This is slightly different from the effect plot in the last demonstration because the model now includes the interaction between Gender and IncLevel. Remember that this plot shows the probability of a person's spending at least $100, as predicted by our model, based on their age, gender, income, and the interaction between gender and income. The vertical axis represents the predicted probability of a person's spending at least $100. Age is on the horizontal axis. Each level of Gender and IncLevel is plotted as a separate line as shown in the legend below the plot. We can easily see the positive trend for age: older people have a greater tendency of purchasing $100 or more from the catalog company than younger people do. Males with high income have the highest probability of spending at least $100, while males with low income have the lowest probability. 

Immediately above is the odds ratio plot. The only odds ratio shown is for Age. By default, PROC LOGISTIC does not produce or display odds ratios for terms that are involved in interactions, and Age is the only term that is not involved in an interaction. Our next step is to find out how to tell PROC LOGISTIC to produce the odds ratio for each value of interacting variables. In the next demonstration, we'll specify those odds ratios in our code.

