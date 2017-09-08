/*
 * Lab 4.2: Requesting Specific Diagnostic Plots Using PROC REG
 *
 * Lesson 4: Model Post-Fitting for Inference
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
In the previous demonstration, we looked at the default PROC REG plots. 
This time, we'll run PROC REG again, but request specific plots instead. 

Here's the new PROC REG step. Let's focus on the PROC REG statement. 
In the PLOTS= option, the global plot option '(ONLY)' suppresses the default plots. 
- QQ requests a residual quantile-quantile plot to assess the normality of the residual error, 
- RESIDUALBYPREDICTED requests a plot of residuals by predicted values. 
- RESIDUALS requests a panel of plots of residuals by the predictor variables in the model. 

The rest of the code is the same. Let's submit the code and view the log.
*/

ods graphics / imagemap=on width=800;

proc reg data=statdata.fitness
         plots(only)=(QQ RESIDUALBYPREDICTED RESIDUALS); 
   PREDICT: model Oxygen_Consumption =
                  RunTime Age Run_Pulse Maximum_Pulse; 
   id Name; 
   title 'PREDICT Model of Oxygen_Consumption - Plots of Diagnostic Statistics';
run;
quit;

title;
/* Results:
Fine. In our results, we see that only the plots we requested appear, 
and they are produced full size.

In the plot (RESIDUALBYPREDICTED) of residuals versus predicted values, 
we can verify the equal variance assumption, the independence assumption, and model adequacy. 
We want to see a random scatter of residuals, with no patterns, above and below the 0 reference line. 

Here's a question: 
Does this plot look like a random scatter, above and below the reference line, 
with no patterns? Yes, this plot looks pretty good. 


Now let's look at the panel of the plots (RESIDUALS) 
of residuals versus each of the predictor variables in the model. 
Using these plots, we can check for equal variances and model adequacy. 
If any of these plots show signs of unequal variance, 
we can determine which predictor variable is involved in the problem. 
Any patterns in these plots would indicate an inadequate model. 

Try this question: 
Do any of these plots show unequal variances or a marked pattern? 
No, these plots look pretty good, too. 


Finally, let's look at the normal quantile plot of the residuals (QQ). 
Using this plot, we can verify the assumption 
that the errors are normally distributed. 

Try one more question: 
In this plot, do the residuals follow the normal reference line pretty closely? 
Yes, they do, so we can conclude that the errors are normally distributed.
*/