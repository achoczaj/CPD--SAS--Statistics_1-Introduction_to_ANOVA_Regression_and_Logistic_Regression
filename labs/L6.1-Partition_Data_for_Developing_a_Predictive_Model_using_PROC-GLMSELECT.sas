/*
 * Lab 6.1: Partition Data for Developing a Predictive Model using PROC GLMSELECT
 *			- into a training data set and a validation data set
 * Lesson 6: Model Building and Scoring for Prediction
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* 
Introduction to Predictive Modeling

Before you can predict values, you must first build a predictive model. 
To build a predictive model, you can use PROC GLMSELECT. 


What Is Predictive Modeling?

Predictive modeling uses historical data to predict future outcomes. These predictions can then be used to make sound strategic decisions for the future. For example, a predictive model can enable a business to make accurate predictions about customer behavior, such as a response to a promotion. Based on these predictions, the business can then identify effective strategies for influencing customer behavior. 

The process of building and scoring a predictive model has two main parts: building the predictive model on existing data, and then deploying the model to make predictions on new data (using a process called scoring). 

You'll learn about the two parts of this process in more detail later in this lesson. 

A predictive model consists of either a formula or rules (depending on the type of analysis that you use) based on a set of input variables that are most likely to predict the values of a target variable. 

The predictive models in this lesson are based on regression models, which are parametric and have formulas. 

Predictive models can also be based on non-parametric models such as decision trees, which have rules.

Let's take a quick look at some common business applications of predictive modeling: target marketing, credit scoring, and fraud detection.

Target marketing is a type of database marketing, which is marketing that uses customer data to improve sales promotions and product loyalty. In target marketing, a predictive model is based on historical customer data. The predictive model contains the inputs for customer attributes that are most likely to predict a customer's response to a promotion. 

For example, the inputs might include Income (a continuous variable) and Occupation (a nominal variable), among others. In this example, the target might be a binary variable that indicates whether the customer made a purchase in response to a promotion.

The business then applies the predictive model to new customer data to predict which segments of customers are most likely to respond to a new offer. Marketing efforts can then focus on those customers. 

Historic customer databases can also be used to predict who is likely to switch brands or cancel services (which is referred to as churn). Loyalty promotions can then be targeted at customers who are at risk of churn.

Credit scoring is used to decide whether to extend credit to applicants. The predictive model, which is built on historic applicant data, might be a logistic regression model. The model contains the inputs for applicant attributes (such as income and credit rating) that are most likely to predict the applicant's debt status (for example, whether the loan was paid or is in default).

Then the model is applied to new applicant data. The aim is to reduce defaults and serious delinquencies with new applicants for credit.

Predictive modeling is also useful in fraud detection. For example, businesses need to monitor for fraudulent transactions, such as credit card purchases or insurance claims. 

Based on historical transaction data, the predictive model contains, as inputs, the attributes of transactions or insurance claims that are most likely to predict the fraud status of the transaction.

Then the predictive model is applied to new transaction data. The aim is to anticipate fraud or abuse in new transactions or claims so that they can be investigated or impeded.

Model-based predictions are often called fact-based predictions. In contrast, decisions that are based completely on people's business expertise are often referred to as intuition-based decisions.

Predictive modeling takes the guesswork out of the prediction process.


Model Complexity

Whether you are doing predictive modeling or inferential modeling, you want to select a model that generalizes well – that is, the model that best fits the entire population. You assume that a sample that is used to fit the model is representative of the population. However, any given sample typically has idiosyncracies that are not found in the population.

The model that best fits a sample and the population is the model that has the right complexity.

Using this scatter plot as an example, let's see what happens when a model is too complex or when a model is not complex enough.

A naive modeler might assume that the most complex model should always outperform the others, but this is not the case. An overly complex model might be too flexible. This leads to overfitting – that is, accommodating nuances of the random noise (the chance relationships) in the particular sample. Overfitting leads to models that have higher variance when they are applied to a population. For regression, including more terms in the model increases complexity.

On the other hand, an insufficiently complex model might not be flexible enough. This leads to underfitting – that is, systematically missing the signal (the true relationships). This leads to biased inferences, which are inferences that are not true of the population.

A model with just enough complexity, which also means just enough flexibility, gives the best generalization. The important thing to realize is that there is not one perfect model; there is always a balance between too much flexibility (overfitting) and not enough flexibility (underfitting).


Building a Predictive Model

The first part of the predictive modeling process is building the model. There are two steps to building the model: fitting the model and then assessing model performance in order to select the model that will be deployed.

To build a predictive model, a method called honest assessment is commonly used to ensure that the best model is selected.

Honest assessment involves partitioning (that is, splitting) the available data—typically into two data sets: a training data set and a validation data set. 

Both data sets contain the inputs and the target. The training data set is used to fit the model.

In the training data set, an observation is called a training case. Other synonyms for "observation" are example, instance, and record.

The validation data set is a holdout sample that is used to assess model performance and select the model that has the best generalization. Honest assessment means that the assessment is done on a different data set than the one that was used to build the model. Using a holdout sample is an honest way of assessing how well the model generalizes to the population.

Sometimes, the data is partitioned into three data sets. The third data set is a test data set that is used to perform a final test on the model before the model is used for scoring. This final test can be referred to as a final honest estimate of generalization. Like the validation data set, the test data set is also referred to as a holdout data set. In practice, many analysts see no need for a final honest assessment of generalization based on a test data set. Instead, an optimal model is chosen using the validation data. The model assessment that is measured on the validation data is reported as an upper bound on the performance that is expected when the model is deployed for scoring.

In the examples and demonstrations in this lesson, the data is partitioned into two data sets; a test data set is not used.

Partitioning the data avoids the problem that typically results when you fit a model on a single data set—that is, selecting a model that is too complex. This problem is called overfitting. The classic example of overfitting is selecting linear regression models based on R square.

You might be wondering whether it is always best to partition the data set when you build a predictive model. This depends on the size of the data set. If you start with a small or medium-size data set, partitioning the data might not be efficient. 

The reduced sample size can severely degrade the fit of the model. In fact, computer-intensive methods, such as the cross-validation and bootstrap methods, were developed so that all the data can be used for both fitting and honest assessment.

However, predictive modeling usually involves very large data sets, so partitioning the data is usually appropriate.

Let's take a closer look at using honest assessment to build a predictive model. Later, you'll learn to use PROC GLMSELECT to perform this process. 

During model fitting, the training data is used to model the target. You can use one of several model selection methods. 

In this example, suppose the forward selection method is used. The forward selection process generates a number of possible models, which increase in complexity as variables are added to the model.

Variables continue to be added as long as they meet the criterion for inclusion. For example, if you use the AICC criterion, variables will be added as long as the criterion value continues to decrease. When the AICC criterion can no longer be reduced, which indicates that the model can no longer be improved, the process stops. 

In this example, five possible models of increasing complexity were generated. For simplicity, the complexity of each model is indicated by a number from 1 to 5.

Next, the validation data is used to assess the performance of each model. These performance measures are then used as one of the criteria for the selection of the best model. 

In this simplified example, the number of stars displayed for each model is a rating that indicates how well the model fits the validation data. The validation assessment rating of these five models ranges from one star to three stars. 

Two models received three-star ratings—models 3 and 4—so these are the best two models. However, you often must choose only one model.

When there is a tie or a near-tie, the most parsimonious model is typically chosen – in other words, the simplest model with the highest validation assessment. In this example, the model of complexity 3 is simpler than the model with complexity 4, so you choose model 3.
 */


/************************************************************
Using PROC GLMSELECT to Partition Data for a Predictive Model
*************************************************************/
/*
Using honest assessment with a holdout data set (that is, a validation data set), 
PROC GLMSELECT can build a model in two ways. 
The method that you use depends on the state of your data before model building begins.

If your data is already partitioned into a training data set 
and a validation data set, you can simply reference both data sets in the procedure. 
If you start with a single imput data set, PROC GLMSELECT can partition the data for you.
Let's look at the syntax for both methods.


*** Method 1 - validation data set already exists ***

If a training and validation data sets already exist, 
you use the PROC GLMSELECT syntax shown here:

	PROC GLMSELECT DATA=training-data-set
                   VALDATA=validation-data-set;
  		MODEL target(s) = input(s) </ options>;
	RUN;

In the PROC GLMSELECT statement, the DATA= option specifies 
the training data set 
and the VALDATA= option specifies the validation data set. 

The MODEL statement specifies the variables to include in the model. 
When the MODEL statement syntax was shown in an earlier lesson about regression, 
the variables were specified as dependent and regressor. 
Here, the MODEL statement syntax uses 
the predictive modeling terms: target and input. 

In addition to specifying the validation data set name in the VALDATA= option, 
you also need to specify options in the MODEL statement 
to tell PROC GLMSELECT to use the validation data for model building. 
You'll learn more about these MODEL statement options in the next demonstration.


*** Method 2 - validation data set does not exist ***

If you start with a data set that is not yet partitioned, 
you use the PROC GLMSELECT syntax shown here, 
and PROC GLMSELECT partitions the data for you:

	PROC GLMSELECT DATA=input-data-set
                               <SEED=number>;
  	MODEL target(s)=input(s) </ options>;
  	PARTITION FRACTION(<TEST=fraction> <VALIDATE=fraction>);
RUN;


In the PROC GLMSELECT statement, the DATA= option specifies the input data set. 
PROC GLMSELECT will use 
some of the cases in this data set to train the model 
and others to validate, 
and in some cases, test the model. 

The MODEL statement is the same as before. 

The PARTITION statement specifies how PROC GLMSELECT logically partitions the cases 
in the input data set into holdout samples for model validation and, 
if desired, testing. 
In the method shown here, the FRACTION option specifies 
the fraction (that is, the proportion) of cases in the input data set 
that are randomly assigned a testing role and a validation role. 
The sum of the specified fractions must be less than 1 
and the remaining fraction of the cases in the input data set 
are assigned the training role.

So, what is the purpose of the SEED= option in the PROC GLMSELECT statement? 
The PARTITION statement requires a pseudo-random number generator 
to start the random selection process. 
The pseudo-random number generator requires a starting "seed," 
which must be an integer.
If you need to be able to reproduce your results in the future, 
you specify an integer that is greater than zero in the SEED= option. 
Then, whenever you run the PROC GLMSELECT step and use that seed value, 
the pseudo-random selection process is replicated and you get the same results. 

If the SEED= value specifies an invalid value or no value, 
the seed is automatically generated from reading the time of day from the computer's clock. 

In most situations, it is recommended that you use the SEED= option 
and specify an integer greater than zero.
 */

	
proc glmselect data=housing;
   class fireplace lot_shape;
   model Sale_price = fireplace lot_shape;
   /*partitions the cases in the input data set for test and validate data sets.
     the rest cases stay as training data set*/
   partition fraction (test=0 validate=.20);
run;