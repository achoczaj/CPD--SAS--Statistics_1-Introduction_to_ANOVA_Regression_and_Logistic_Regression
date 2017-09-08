/*
 * Lab 4.7: Dealing with Collinearity using PROC REG
 *
 * Lesson 4: Model Post-Fitting for Inference
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* 
*** Dealing with Collinearity ***

Let's say that based on our subject matter knowledge, 
we decided to remove Performance and rename the model NOPERF. 
We'll update the title, too. 

Now we need to check again for collinearity, so we'll run the new model 
and calculate VIFs for each of the predictors in the model.
*/
proc reg data=statdata.fitness;
   NOPERF: model Oxygen_Consumption = 
                 RunTime Age Weight
                 Run_Pulse Rest_Pulse Maximum_Pulse
                 /*add the VIF option to calculate variance inflation factors 
				   for each predictor in the model*/
                 / vif; 
   title 'Dealing with Collinearity';
run;
quit;

title;
/* Results:

Try this question: 
How do the VIFs for the remaining variables look now? 

They're much smaller. 
Only two variables, Run_Pulse and Maximum_Pulse, have VIFs that are close to 10. 

How should we interpret this information? 
Even though the VIFs for Run_Pulse and Maximum_Pulse are less than 10, 
they are still not as low as the VIFs for other variables, 
so the model still contains some collinearity. 

Actually, it's not too surprising that Run_Pulse and Maximum_Pulse 
are correlated with each other. 
Run_Pulse is the pulse rate at the end of the run, and, to a point, 
most people's heart rates increase the longer they run. 
So the maximum pulse rate is probably similar to the ending pulse rate. 

At this point, you might decide to stop, or you might decide 
to try removing either Run_Pulse or Maximum_Pulse from the model. 

Of the two variables involved in the collinearity problem, Maximum_Pulse 
has the less significant p-value. 
But if you felt strongly about removing Run_Pulse due to your subject matter knowledge, 
you could do that instead. 

Let's try removing Maximum_Pulse and calculating VIFs for the remaining predictors 
in the model. We'll call the new model NOPERFMAX.
*/
proc reg data=statdata.fitness;
   NOPERFMAX: model Oxygen_Consumption = 
                    RunTime Age Weight
                    Run_Pulse Rest_Pulse
                    / vif; 
   title 'Dealing with Collinearity';
run;
quit;

title;
/*
First, let's check the new VIFs for the remaining variables. How do the VIFs look? They're all small, which is good. Now check the overall p-value and adjusted R-square for the model. What do you see? The overall p-value is the same, but the adjusted R-square value went down. This means that removing Maximum_Pulse hurt our model a bit according to that criterion. 

What do you do now? You might want to go with the previous model that included Maximum_Pulse—or you might not. It's basically a judgment call at this point. No perfect model exists. Your goal is to find a good balance between diagnostic tests to find the best model for your needs.
*/