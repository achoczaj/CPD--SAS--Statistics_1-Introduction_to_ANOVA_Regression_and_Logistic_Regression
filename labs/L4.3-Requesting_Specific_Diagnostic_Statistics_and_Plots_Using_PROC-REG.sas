/*
 * Lab 4.3: Requesting Specific Diagnostic Statistics and Plots Using PROC REG
 *
 * Lesson 4: Model Post-Fitting for Inference
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Program 1 - Request only specific diagnostic plots*/
proc reg data=statdata.bodyfat2 
			/* request only specific diagnostic plots*/
			plots(only)=
              (QQ RESIDUALBYPREDICTED RESIDUALS); 
   PREDICT: model PctBodyFat2 = 
                  Abdomen Weight Wrist Forearm;
   id Case;
   title1 'PREDICT Model of PctBodyFat2 - Plots of Diagnostic Statistics';
   title2 'Program 1';
run;
quit;

title;


/* Program 2 - Request specific diagnostic statistics 
as well as diagnostic plots*/
proc reg data=statdata.bodyfat2 
			/* request only specific diagnostic plots*/
			plots(only)=
              (RSTUDENTBYPREDICTED(LABEL)
               COOKSD(LABEL)
               DFFITS(LABEL)
               DFBETAS(LABEL)); 
   PREDICT: model PctBodyFat2 = 
                  Abdomen Weight Wrist Forearm
                  /*request specific diagnostic statistics*/
                  / r influence;
   id Case;
   title1 'PREDICT Model of PctBodyFat2';
   title2 'Specific diagnostic statistics as well as diagnostic plots';
   title3 'Program 2';
run;
quit;

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