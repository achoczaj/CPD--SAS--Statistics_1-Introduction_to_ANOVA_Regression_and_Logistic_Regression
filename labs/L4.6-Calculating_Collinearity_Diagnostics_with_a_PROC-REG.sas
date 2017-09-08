/*
 * Lab 4.6: Calculating Collinearity Diagnostics with REG Procedure 
 *
 * Lesson 4: Model Post-Fitting for Inference
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* 
The REG Procedure: Calculating Collinearity Diagnostics

Now let's run PROC REG again only on the FULL model.
 
This time, we'll add the VIF option to calculate variance inflation factors 
for each predictor in the model. 

Delete the PREDICT model 
and add a forward slash and the VIF option 
in the MODEL statement for the FULL model. 

Edit the title.
*/
proc reg data=statdata.fitness;
   FULL: model Oxygen_Consumption = 
               Performance RunTime Age Weight
               Run_Pulse Rest_Pulse Maximum_Pulse
               /*add the VIF option to calculate variance inflation factors 
				 for each predictor in the model*/
               / vif; 
   title 'Collinearity: Full Model with VIF';
run;
quit;

title;
/* Results:
The output for the FULL model looks the same as before, 
except for the extra column 'Variance Inflation'
of VIFs for each predictor variable 
in the Parameter Estimates table. 

Here's a question: 
Which predictors exceed the cutoff value of 10 for the VIF? 
Performance, RunTime, and Age have very high VIFs, 
definitely greater than 10. 
Run_Pulse and Maximum_Pulse also have VIFs that are close to 10. 

Here's another question: 
How would you describe the collinearity in this model? 
This model definitely has a severe collinearity problem. 

How do we proceed now? 
We have many choices. 
For example, we could use other diagnostic tests for collinearity, 
but we won't do that here. 
One solid piece of advice is to use subject matter knowledge 
to decide which term to remove from the model. 
Let's ask the analyst for information. 
The analyst gave us this code, which shows how the variable Performance was calculated. 
Performance=260-round(10*runtime + 2*age + 4*(Gender='F')); 

Notice that Performance is actually a weighted combination of three variables, 
RunTime, Age, and Gender. No wonder this model contains collinearity. 
Now what? 
You might argue for keeping Performance as a measure and removing RunTime and Age from the model. On the other hand, Performance is not a straightforward measure like RunTime, and it's a more subjective measure based on the combined information of three variables. So you may feel more strongly about removing Performance from the model. Think about it: Which variable or variables would you remove? It's up to you, based on your knowledge of the variables in your model.
