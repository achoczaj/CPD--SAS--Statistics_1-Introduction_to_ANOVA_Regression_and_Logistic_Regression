/*
 * Lab 6.3: Scoring Predictive Models
 * 
 * Lesson 6: Model Building and Scoring for Prediction
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* 
Scoring Predictive Models

After you build a predictive model, you are ready to deploy the model. 

To score new data — referred to here as scoring data - you can use PROC GLMSELECT and PROC PLM.
 */

/*
Preparing for Scoring

Before you start using a newly-built model to score data, some preparation of the model, the data, or both, is usually required. 

For example, in some applications, such as fraud detection, the model might need to be integrated into an online monitoring system before it can be deployed.

It is essential for the scoring data to be comparable to the training and validation data that were used to build the model. Before the model is built, modifications are often made to the training data, such as missing value imputation, transformations, and derivation of inputs through standardization or the creation of composite variables from existing variables. The same modifications must be made to the validation data before validating the model and to the scoring data before scoring. 

Making the same modifications becomes more complex if the original modifications were based on parameters derived from the training data set, such as the mean or standard deviation. 

Remember that the process of preparing the data for scoring can be time- and resource-intensive. For example, the data might be stored in a different format on a different system and use different software. 

Also, in some applications, the amount of data to be scored is much larger than the data that was used to develop the model.


Methods of Scoring

When you score, you do not rerun the algorithm that was used to build the model. Instead, you apply the score code—that is, the equations obtained from the final model—to the scoring data. 

Let's look at three methods of scoring your data. 
1. In the first method, a SCORE statement is added to the PROC GLMSELECT step that is used to create the model. 
2. The second method uses a STORE statement in the PROC GLMSELECT step and then a SCORE statement in PROC PLM. 
3. The third method uses a STORE statement in PROC GLMSELECT, a CODE statement in PROC PLM to output SAS code for scoring, and then a DATA step to do the scoring. 

*** method 1 ***
Use a single PROC GLMSELECT step to build and score your model 
This method is useful because you can build and score a model in one step. 
However, this method is inefficient if you want to score more than once 
or use a large data set to build a model. 
With this method, the model must be built from the training data each time the program is run. 

*** method 2 ***
The second method enables you to build the model only once, along with an item store, 
using PROC GLMSELECT. You can then use PROC PLM to score new data using the item store. 

Separating the code for model building and model scoring is especially helpful 
if your model is based on a very large training data set or if you want to score more than once. 

One potential problem with this method is that others might not be able to use this code 
with earlier versions of SAS or you might not want to share the entire item store. 

*** method 3 ***
The third method solves these problems by using PROC PLM 
to write detailed scoring code, based on the item store, 
that is compatible with earlier versions of SAS. 

You can provide this code to others without having to share other information 
that is in the item store. 
The DATA step is then used for scoring. 
In the demonstration, you learn the syntax for these methods.
 */

/*
Scenario: Scoring Data

You've already built a predictive model to predict the sale prices of homes 
in Ames, Iowa that are 1500 square feet or less. 
Now you want to score data for new homes. 

You will score the cases in the AmesHousing4 data set, 
which was not used to build the model. Fortunately, this data requires no modification.
 */

/*
In the previous demonstration, we used this PROC GLMSELECT step 
to build a model and save the parameters in an item store. 
Now, let's use that item store to score data.*/


/* If you started a new SAS session after running the code for the 
previous demonstration, you must rerun that code before the
current demonstration code. To do this, remove the comment codes
around this code block and run the entire program.

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
              Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
                 Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
                 Masonry_Veneer Lot_Shape_2 Central_Air;

ods graphics;

proc glmselect data=statdata.ameshousing3
               plots=all 
               valdata=statdata.ameshousing4;
   class &categorical / param=glm ref=first;
   model SalePrice=&categorical &interval / 
                   selection=backward
                   select=sbc 
                   choose=validate;
   store out=work.amesstore;
title "Selecting the Best Model using Honest Assessment";
run;
title;
*/ 

/* In this demonstration, we use code that scores the data in two different ways 
and then compares the output from the two methods. 

First, the PROC PLM step uses the SCORE statement to score the data. 
The second method generates scoring code by using the CODE statement in PROC PLM, 
and then uses a DATA step to do the scoring. 
For demonstration purposes, we'll score the validation data set 
from the previous demonstration Statdata.AmesHousing4. 
However, when you score data in your work environment, you'll be scoring data 
that was not used in either training or validation. 
*/

proc plm restore=work.amesstore;
   score data=statdata.ameshousing4 out=scored;
   code file="my-file-path/scoring.sas";
run;
/*
In PROC PLM, the RESTORE= option specifies the name of the item store 
that contains the model information —in this example, Work.Amesstore. 
(Remember that item stores are usually stored in a permanent library.) 

The SCORE statement uses the DATA= option to specify the new data 
to be scored: Statdata.AmesHousing4. 
The OUT= option specifies the name of the output data set — that is, 
the data set that the SCORE statement will create. 
The output data set contains the scored data, 
which is the input data set with predicted values added. 
In this example, the output data set is a temporary data set named Scored.

The CODE statement writes the scoring instructions 
(that is, SAS DATA step programming code) to a file
 The FILE= option specifies the full name of the output SAS program file, 
 including the location. 
 The output file specification must be enclosed in quotation marks. 

Let's submit the PROC PLM step. 
 */
/*Results:
The log shows that two files were successfully created: the output data set Work.Scored 
and the output SAS program file scoring.sas. 

In the results, the Store Information table shows the model parameters 
in the item score that was used for scoring. 
*/

/*/*
The SAS program file created by PROC PLM does not contain a DATA statement 
or a RUN statement, so we also need a DATA step for the second scoring method. 

Here, the DATA statement specifies a temporary data set named Scored2 
as the output data set. 
The SET statement specifies the Statdata.AmesHousing4 data set 
as the input data set (that is, the data to be scored). 

The %INCLUDE statement accesses the scoring code. 

The %INCLUDE statement must specify the same location and the name of the SAS program file 
that was created in the CODE statement in PROC PLM. 
Remember that, if we had made any transformations to the original data set 
before building the model, we would need to perform those transformations 
here in the DATA step before the %INCLUDE statement. 

Let's submit the DATA step.
*/
data scored2;
   set statdata.ameshousing4;
   %include "my-file-path/scoring.sas";
run;
/* Results:
The log shows that the output data set Work.Scored2 was successfully created. 
Now we're ready to see whether the two methods scored the data the same way. 
 

The PROC COMPARE step compares the values of the scored variable 
in the two output data sets, Scored and Scored2.  
 */
proc compare base=scored compare=scored2 criterion=0.0001;
   var Predicted;
   with P_SalePrice;
run;
/*
There's no need to do any preliminary matching or sorting in this case 
because the output data sets are based on the same input data set; 
they have the same number of variables and observations, in the same order. 

In the PROC COMPARE statement, the BASE= option specifies 
the first output data set - Scored, 
and the COMPARE= option specifies the second data set - Scored2. 

By default, the criterion for judging 
the equality of the numeric values is .00001. 
If you want to specify a different criterion, you can use the CRITERION= option. 
In this example, the CRITERION= option specifies 0.0001, 
which is less stringent than the default criterion. 

The scored variable has a different name in the two data sets, 
so the two names are specified in the VAR and WITH statements, respectively. 

The VAR statement specifies the name of the scored variable 
in the BASE= data set Scored, which PROC PLM created. 
By default, the SCORE statement in PROC PLM uses the name 'Predicted' 
for the scored variable, as shown here in the VAR statement. 
The WITH statement specifies the name of the scored variable 
in the Scored2 data set, which is P-underscore-SalePrice. 

As you can see, the DATA step names added P-underscore to the original variable name. 

Let's submit the PROC COMPARE step. 
*/

/* Results:
The log shows that PROC COMPARE read observations from the two data sets. 
In the results, we want to look at the Values Comparison Summary 
to see whether the two methods produced similar predictions. 

There are no values that are compared as unequal. Some values are not exactly equal but, as the maximum difference criterion value indicates, the differences are too small to be important. Of course, if we used the more stringent default criterion, the results would likely show more differences.