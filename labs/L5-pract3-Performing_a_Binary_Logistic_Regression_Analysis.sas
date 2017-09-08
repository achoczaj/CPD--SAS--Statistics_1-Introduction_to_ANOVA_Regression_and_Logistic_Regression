/*
 * Practice 3: Performing a Binary Logistic Regression Analysis
 * Lesson 5: Categorical Data Analysis
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
The insurance company wants to characterize the relationship between the region in which a car was manufactured and its safety rating. The Statdata.Safety data set contains the data that you need.
Reminder: Make sure you've defined the Statdata library.

1. Fit a simple logistic regression model with Unsafe as the outcome variable and Region as the predictor variable. Request reference cell coding and specify Asia as the reference level. Use the EVENT= option to model the probability of below-average safety scores. Request an effect plot. Add an appropriate title. Submit the code and view the log.

2. Do you reject or fail to reject the null hypothesis that all regression coefficients of the model are 0?

3. Write out the logistic regression equation.

4. Interpret the odds ratio for Region. 
*/

/* 1.*/
proc logistic data=statdata.safety plots(only)=(effect);
   class Region (param=ref ref='Asia');
   model Unsafe(event='1')=Region;
   title1 'LOGISTIC MODEL (1):Unsafe=Region';
run;

title;

/*
2. Do you reject or fail to reject the null hypothesis that all regression coefficients of the model are 0?
All three global tests (Likelihood Ratio, Score, and Wald) lead to the conclusion of not rejecting the null hypothesis.

3. Write out the logistic regression equation.
The equation is: Logit(Unsafe) = -0.2876 – 0.8329 * (Region='N America').

4. Interpret the odds ratio for Region. 
The odds ratio for Region says that the odds for being unsafe (having a below average safety rating) are 56.5% lower for cars produced in North America, compared with those produced in Asia. The confidence interval includes 1, indicating that that the odds ratio is not statistically significant. The difference between Asian and North American cars is shown on the probability scale in the effect plot.
*/