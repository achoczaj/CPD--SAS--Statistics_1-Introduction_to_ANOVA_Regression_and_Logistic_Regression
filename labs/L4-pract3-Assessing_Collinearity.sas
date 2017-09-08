/*
 * Practice 3: Assessing Collinearity
 * Lesson 4: Model Post-Fitting for Inference
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
Using Statdata.BodyFat2, run a regression of PctBodyFat2 on all the other numeric variables in the data set.
Reminder: Make sure you've defined the Statdata library.
1. Determine whether a collinearity problem exists in your model.

2. If so, decide how you want to proceed. Would you remove any variables? Why or why not?
*/

/* 1.*/
proc reg data=statdata.BodyFat2;
   FULLMODL: model PctBodyFat2 =
                   Age Weight Height
                   Neck Chest Abdomen Hip Thigh
                   Knee Ankle Biceps Forearm Wrist
                   / vif;
   title 'Collinearity -- Full Model';
run;
quit;

title;
/* There seems to be high collinearity with Weight and less so with Hip, Abdomen, Chest, and Thigh.

/*2.*/
/*
If so, decide how you want to proceed. Would you remove any variables? Why or why not?
- The answer is not easy. True, Weight is collinear with some set of the other variables. However, as you've seen before in your model-building process, Weight actually ends up as a relatively significant predictor in the "best" models.
 */