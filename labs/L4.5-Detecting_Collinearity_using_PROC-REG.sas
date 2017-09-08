/*
 * Lab 4.5: Detecting Collinearity
 *
 * Lesson 4: Model Post-Fitting for Inference
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* 
*** Detecting Collinearity ***

Collinearity, also called multicollinearity, is a problem that you face in multiple regression. It occurs when two or more predictor variables are highly correlated with each other. Try this question. Suppose your model contains three variables: the response variable, weight, and the predictors, height in inches and height in centimeters. Are the two predictors completely redundant? The two predictors are completely redundant. Height is the same variable, whether measured in inches or centimeters.

The height example is extreme, but you saw a more typical example of collinearity in the Fitness data. RunTime and Performance are highly correlated with one another. They are both trying to explain much of the same variation in Oxygen_Consumption. Collinearity doesn't violate the assumptions of multiple regression. It means there is redundant information among the predictor variables. 

So, why is this a problem? Think about one of your goals in regression. For both simple linear and multiple linear regression, you want to explain as much of the variation in the response variable as possible. Ideally, you want a multiple regression model in which the predictor variables correlate highly with the response variable, but only minimally with each other. In such a model, you can easily determine the effects of each individual predictor variable in explaining the variability of the response. When multiple variables try to explain much of the same variation in the response, it leads to inflated standard errors and instability in the regression model. So, you want to avoid having two highly correlated predictor variables in the same model.

Collinearity causes instability in the model by inflating the variance of the parameter estimates, which raises the p-values. However, it does not violate any assumptions. 

In this topic, you learn techniques for determining whether collinearity exists in a model. You also learn how to identify the variables involved and the strength of their collinearity. Finally, you learn how to minimize collinearity.


*** Understanding Collinearity ***

Let's begin by looking at collinearity in more detail. You've seen that when variables are collinear, one of the variables provides nearly as much information as the other. Again, why is this redundancy bad? For one thing, it can hide significant variables in your model. Look at this example. X1 and X2 are collinear, so they follow a fairly straight line. When the model includes both variables, neither one might be significant. But when the model includes only one of them, either variable might be significant. This means that collinearity can hide significant effects. This is a good reason to deal with collinearity before using any automated model selection tool. Second, collinearity increases the variance of the parameter estimates, making them unstable. In turn, this increases the prediction error of the model. 

Let's see what this instability looks like. Remember that you're modeling the relationship of the three variables using a plane of predicted response values. Where should the prediction plane lie in this diagram? This represents a best-fit plane through the data. Now think of a table. The plane you're trying to build is like the tabletop. The observations guide the angle of the tabletop relative to the floor, like the table legs. Here's a question: What happens if the legs line up along the center of the table? The tabletop will be unstable. In this model, collinearity between the two predictors, X1 and X2, means that their data points don't spread out enough in the X space to provide stable support for the plane. Instead, the points cluster around the center, making the plane unstable. In fact, if you remove just one data point, the model's instability drastically changes the plane of predicted response values. This is the resulting plane. Even if you only move a data point, the plane can shift considerably. So, collinear predictors act as substitutes for each other to define one direction redundantly. How do you solve this problem? In this case, you can drop either X1 or X2 from the model, since they both measure essentially the same thing.
*/

/*********************************************
 * The REG Procedure: Detecting Collinearity *
 *********************************************/ 
/*
Now let's run two regression models in PROC REG. The first model is the PREDICT model you've seen before. The second model is the full model that includes all the predictor variables. The label for the model can be up to 8 characters, so we'll call this model FULL. After we run the models, we'll check for collinearity. Let's submit the program and check the log.
*/
proc reg data=statdata.fitness;
   PREDICT: model Oxygen_Consumption = 
                  RunTime Age Run_Pulse Maximum_Pulse;
   
   FULL: model Oxygen_Consumption = 
               Performance RunTime Age Weight
               Run_Pulse Rest_Pulse Maximum_Pulse; 
   title 'Collinearity: PREDICT and FULL Model';
run;
quit;

title;
/*
The output for the PREDICT model that you're seen before. It includes RunTime, Age, Run_Pulse, and Maximum_Pulse as the predictor variables. As you might recall, the p-value for the overall model is highly significant. Here's a question: What is the adjusted R-square value for the model? It's .8102, which is fairly high. Combined, the overall p-value and the adjusted R-square value indicate that the model fits the data well. Now look at the p-values for each of the parameter estimates. They range from less than .05 to slightly greater than .05. So, we have a pretty good model here. 

Now let's view the output for the FULL model, which includes all of the predictor variables. Here's another question: What is the p-value for the overall model, and is it significant? At less than .0001, the p-value is highly significant. Now try this question: What is the adjusted R-square value, and what does it indicate? At .8026, the adjusted R-square value is also fairly high, indicating that the model fits the data well. However, the adjusted R-square value fell from .8102 in the PREDICT model to .8026 in the FULL model. This indicates that the additional explained variability is not enough to justify the three additional predictors that are included in the FULL model.

Now check the p-values for the parameter estimates. Are the p-values consistent? What does this tell you? When we look at these p-values for the parameter estimates, we don't see the same consistency as the p-value for the overall model. This is a clue. When an overall model is highly significant but the individual variables don't tell the same story, it's a warning sign of collinearity. In the FULL model, only Run_Pulse and Maximum_Pulse are statistically significant. 

We can also quickly compare the standard errors to the parameter estimates. When the standard error for an estimate is larger than the parameter estimate itself, it's not going to be statistically significant. What does the standard error, or SE, represent? The SE tells us how variable the corresponding parameter estimate is. When the standard errors are high, the model lacks stability.
 */