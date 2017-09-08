/*******************************************************************************

Analysis of Variance (ANOVA) - a collection of snippets

from Summary of Lesson 2: Analysis of Variance (ANOVA)
SAS Statistics I: Introduction to ANOVA, Regression, and Logistic Regression

*******************************************************************************/


/*******************************************************************************
1. Graphical Analysis
*******************************************************************************/
/*
Graphical Analysis
Part of knowing your data is to get a general idea of any associations between predictor variables and the response variable. You can do this by conducting a graphical analysis of your data using box plots.
*/
/*******************************************************************************
2. Two-Sample t-Tests
*******************************************************************************/
/*
The two-sample t-test is a hypothesis test for answering questions about the means of two populations. You can examine the differences between populations for one or more continuous variables and assess whether the means of the two populations are statistically different from each other.

The null hypothesis for the two-sample t-test is that the means for the two groups are equal. The alternative hypothesis is the logical opposite of the null and is typically what you suspect or are trying to show. It is usually a hypothesis of inequality. The alternative hypothesis for the two-sample t-test is that the means for the two groups are not equal.
*/
/* 2.1 Three assumptions for the two-sample t-test */
/*
The three assumptions for the two-sample t-test are:
- the observations are independent observations,
- normality,
- and equal variances.

*/
/* 2.2 F-test for equality of variances */
/*
You use the F-test for equality of variances to evaluate the assumption of equal variances in the two populations. You calculate the F statistic, which is the ratio of the maximum sample variance of the two groups to the minimum sample variance of the two groups.

p-value F-test > alpha
If the p-value of the F-test is greater than your alpha, you fail to reject the null hypothesis and can proceed as if the variances are equal between the groups.
p-value F-test < alpha
If the p-value of the F-test is less than your alpha, you reject the null hypothesis and can proceed as if the variances are not equal.

one-sided tests
With one-sided tests, you look for a difference in one direction. For instance, you can test to determine whether the mean of one population is greater than or less than the mean of another population. An advantage of one-sided tests is that they can increase the power of a statistical test.
*/
/* 2.3 PROC TTEST for two-sample t-test and the one-sided test*/
/*
To perform the two-sample t-test and the one-sided test, you can use PROC TTEST.

You add the PLOTS option to the PROC TTEST statement to control the plots that ODS produces. You add the SIDES=U or SIDES=L option to specify an upper or lower one-sided test.
*/
/*******************************************************************************
3. One-Way ANOVA
*******************************************************************************/
/*
You can use ANOVA to determine whether there are significant differences between the means of two or more populations.

In this model, you have a continuous dependent, or response, variable and a categorical independent, or predictor, variable.

With ANOVA, the null hypothesis is that all of the population means are equal. The alternative hypothesis is that not all of the population means are equal. In other words, at least one mean is different from the rest.

One way to represent the relationship between the response and predictor variables in ANOVA is with a mathematical ANOVA model.

ANOVA analyzes the variances of the data to determine whether there is a difference between the group means. You can determine whether the variation of the means is large enough relative to the variation of observations within the group.
To do this, you calculate three types of sums of squares: between group variation (SSM), within group variation (SSE), and total variation (SST).
The SSM and SSE represent pieces of the total variability.
If the SSM is larger than the SSE, you reject the null hypothesis that all of the group means are equal.
*/
/* 3.1 Three assumptions for ANOVA test */
/*
Before you perform the hypothesis test, you need to verify the three ANOVA assumptions:
- the observations are independent observations,
- the error terms are normally distributed,
- and the error terms have equal variances across groups.

The residuals that come from your data are estimates of the error term in the model. You calculate the residuals from ANOVA by taking each observation and subtracting its group mean. Then you verify the two assumptions regarding normality and equal variances of the errors.

To verify the ANOVA assumptions and perform the ANOVA test, you use PROC GLM.
  PROC GLM DATA=SAS-data-set <options>;
    CLASS variables </ option> ;
    MODEL dependent-variables=independent-effects </ options> ;
    MEANS effects </ options>;
  RUN;
  QUIT;

In the MODEL statement, you specify the dependent and independent variables for the analysis. The MEANS statement computes unadjusted means of the dependent variable for each value of the specified effect. You can add the HOVTEST option to the MEANS statement to perform Levene's test for homogeneity of variances. If the resulting p-value of Levene's test is greater than 0.05 (typically), then you fail to reject the null hypothesis of equal variances.
*/
/*******************************************************************************
4. ANOVA with Data from a Randomized Block Design
*******************************************************************************/
/*
In a controlled experiment, you can design the analysis prospectively and control for other factors, nuisance factors, that affect the outcome you're measuring. Nuisance factors can affect the outcome of your experiment but are not of interest in the experiment. In a randomized block design, you can use a blocking variable to control for the nuisance factors and reduce or eliminate their contribution to the experimental error.

One way to represent the relationship between the response and predictor variables in ANOVA is with a mathematical ANOVA model. You can also include a blocking variable in the model.

Along with the three original ANOVA assumptions of independent observations, normally distributed errors, and equal variances across treatments, you make two more assumptions when you include a blocking factor in the model. You assume that the treatments are randomly assigned within each block, and you assume that the effects of the treatment factor are constant across levels of the blocking factor.

You use PROC GLM to perform ANOVA with a blocking variable. You list the blocking variable in the CLASS statement and in the MODEL statement.
*/
/*******************************************************************************
5. ANOVA Post Hoc Tests
*******************************************************************************/
/*
A pairwise comparison examines the difference between two treatment means.

If your ANOVA results suggest that you reject the null hypothesis that the means are equal across groups, you can conduct multiple pairwise comparisons in a post hoc analysis to learn which means differ.

The chance that you make a Type I error increases each time you conduct a statistical test.
The comparisonwise error rate, or CER, is the probability of a Type I error on a single pairwise test.
The experimentwise error rate, or EER, is the probability of making at least one Type I error when performing all of the pairwise comparisons. The EER increases as the number of pairwise comparisons increases.

You can use the Tukey method to control the EER.
This test compares all possible pairs of means, so it can only be used when you make pairwise comparisons.

Dunnett's method is a specialized multiple comparison test that enables you to compare a single control group to all other groups.

You request all of the multiple comparison methods with options in the LSMEANS statement in PROC GLM.
You use the PDIFF=ALL option to request p-values for the differences between all of the means. With this option, SAS produces a diffogram.
You use the ADJUST= option to specify the adjustment method for multiple comparisons. When you specify the ADJUST=Dunnett option, SAS produces multiple comparisons using Dunnett's method and a control plot.
*/
/*******************************************************************************
5. Two-Way ANOVA with Interactions between Predictor Variables
*******************************************************************************/
/*
When you have two categorical predictor variables and a continuous response variable, you can analyze your data using two-way ANOVA.

With two-way ANOVA, you can examine the effects of the two predictor variables concurrently.

You can also determine whether they interact with respect to their effect on the response variable. An interaction means that the effects on one variable depend on the value of another variable.
If there is no interaction, you can interpret the test for the individual factor effects to determine their significance.
If an interaction exists between any factors, the test for the individual factor effects might be misleading due to the masking of these effects by the interaction.

You can include interactions and more than one predictor variable in the ANOVA model.

You can graphically explore the relationship between the response variable and the effect of the interaction between the two predictor variables using PROC SGPLOT.

You can use PROC GLM to determine whether the effects of the predictor variables and the interaction between them are statistically significant.
*/
/*******************************************************************************
6. Using STORE statement to save your analysis results
*******************************************************************************/
/*
When running PROC GLM, you can add a STORE statement to save your analysis results.

By using the STORE statement, you can run postprocessing analyses on the stored results, even if you no longer have access to the original data set.

The STORE statement requests that the procedure save the context and results of the statistical analysis into an item store.

To perform post-fitting statistical analyses and plotting for the contents of the store item, you use the PLM procedure.
*/
/*******************************************************************************
Syntax
*******************************************************************************/
/*
PROC TTEST DATA=SAS-data-set<options>;
  CLASS variable;
  VAR variable(s);
RUN;

Selected Options in PROC TTEST
Statement	Option
PROC TTEST	PLOTS(SHOWNULL)=INTERVAL
SIDES=U
SIDES=L

/*****************************************/
PROC GLM DATA=SAS-data-set<options>;
  CLASS variable(s);
  MODEL dependents=independents </options>;
  MEANS effects </options>;
  LSMEANS effects </options>;
  STORE <OUT=>item-store-name </ LABEL='label'>;
RUN;
QUIT;

Selected Options in PROC GLM
Statement	Option
PROC GLM	PLOTS(ONLY)
DIAGNOSTICS(UNPACK)
MEANS
HOVTEST
LSMEANS
PDIFF=ALL
ADJUST=

/*****************************************/
PROC PLM RESTORE=item-store-specification<options>;
  EFFECTPLOT <plot-type <(plot-definition options)>>
            </ options>;

  LSMEANS <model-effects > </ options>;
  LSMESTIMATE model-effect <'label'> values
            <divisor=n><,...<'label'> values
            <divisor=n>> </ options>;
  SHOW options;
  SLICE model-effect </ options>;
  WHERE expression;
RUN;

Selected Option in PROC PLM
Statement	Option
PROC PLM
RESTORE

*/
/*******************************************************************************
Sample Programs
*******************************************************************************/
/* 1. Exploring Associations with Box Plots */
proc sgplot data=statdata.ameshousing3;
   vbox SalePrice / category=Central_Air
                    connect=mean;
   title "Sale Price Differences across Central Air";
run;

proc sgplot data=statdata.ameshousing3;
   vbox SalePrice / category=Fireplaces
                    connect=mean;
   title "Sale Price Differences across Fireplaces";
run;

proc sgplot data=statdata.ameshousing3;
   vbox SalePrice / category=Heating_QC
                    connect=mean;
   title "Sale Price Differences across Heating Quality";
run;


/* 2. Running PROC TTEST in SAS */
proc ttest data=statdata.testscores plots(shownull)=interval;
   class Gender;
   var SATScore;
   title 'Two-Sample t-Test Comparing Girls to Boys';
run;
title;

/* Performing a One-Sided t-Test */
proc ttest data=statdata.testscores plots(shownull)=interval
           h0=0 sides=U;
   class Gender;
   var SATScore;
   title 'One-Sided t-Test Comparing Girls to Boys';
run;
title;


/* 3. Comparing Group Means with One-Way ANOVA */
/* 3.1 Examining Descriptive Statistics across Groups */
proc means data=statdata.mggarlic printalltypes maxdec=3;
   var BulbWt;
   class Fertilizer;
   title 'Descriptive Statistics of Garlic Weight';
run;

proc sgplot data=statdata.mggarlic;
   vbox BulbWt / category=Fertilizer datalabel=BedID;
   format BedID 5.;
   title 'Box Plots of Garlic Weight';
run;
title;

/* 3.2 Using the GLM Procedure */
proc glm data=statdata.mggarlic plots(only)=diagnostics(unpack);
   class Fertilizer;
   model BulbWt=Fertilizer;
   means Fertilizer / hovtest;
   title 'Testing for Equality of Means with PROC GLM';
run;
quit;
title;


/* 4. Performing ANOVA with Blocking */
proc glm data=statdata.mggarlic_block plots(only)=diagnostics(unpack);
   class Fertilizer Sector;
   model BulbWt=Fertilizer Sector;
   title 'ANOVA for Randomized Block Design';
run;
quit;
title;


/* 5. Performing a Post Hoc Pairwise Comparison */
ods select lsmeans diff meanplot diffplot controlplot;

proc glm data=statdata.mggarlic_block;
   class Fertilizer Sector;
   model BulbWt=Fertilizer Sector;
   lsmeans Fertilizer / pdiff=all adjust=tukey;
   lsmeans Fertilizer / pdiff=controlu('4') adjust=dunnett;
   lsmeans Fertilizer / pdiff=all adjust=t;
   title 'Garlic Data: Multiple Comparisons';
run;
quit;
title;

/* Examining Your Data with PROC MEANS */
proc format;
   value dosef
   1="Placebo"
   2="100mg"
   3="200mg"
   4="500mg";
run;

proc means data=statdata.drug mean var std printalltypes;
   class Disease DrugDose;
   var BloodP;
   output out=means mean=BloodP_Mean;
   format DrugDose dosef.;
   title 'Selected Descriptive Statistics for Drug Data Set';
run;
title;

/* Examining Your Data with PROC SGPLOT */
proc sgplot data=means;
   where _TYPE_=3;
   scatter x=DrugDose y=BloodP_Mean
           / group=Disease markerattrs=(size=10);
   series x=DrugDose y=BloodP_Mean
          / group=Disease lineattrs=(thickness=2);
   xaxis integer;
   format DrugDose dosef.;
   title 'Plot of Stratified Means in Drug Data Set';
run;
title;


/* 6. Performing Two-Way ANOVA with Interactions */
proc glm data=statdata.drug;
   class DrugDose Disease;
   model Bloodp=DrugDose Disease DrugDose*Disease;
   format DrugDose dosef.;
   title1 'Analyze the Effects of DrugDose and Disease';
   title2 'including Interactions';
run;
quit;
title;


/* 7. Performing a Post Hoc Pairwise Comparison */
proc format;
   value dosef
   1="Placebo"
   2="100mg"
   3="200mg"
   4="500mg";
run;

ods select meanplot lsmeans slicedanova;

proc glm data=statdata.drug;
   class DrugDose Disease;
   model Bloodp=DrugDose Disease DrugDose*Disease;
   lsmeans DrugDose*Disease / slice=Disease;
   format DrugDose dosef.;
   title 'Analyze the Effects of DrugDose at Each Level of Disease';
run;
quit;
title;

/* 8. Performing Two-Way ANOVA with an Interaction by Using PROC GLM */

ods graphics on;

proc glm data=statdata.ameshousing3
         order=internal
         plots(only)=intplot;
   class Season_Sold Heating_QC;
   model SalePrice=Heating_QC Season_Sold Heating_QC*Season_Sold;
   lsmeans Heating_QC*Season_Sold / diff slice=Heating_QC;
   format Season_Sold Season.;
   store out=interact;
   title "Model with Heating Quality and Season as Interacting "
         "Predictors";
run;

/* Performing Postprocessing Analysis by Using PROC PLM */

ods graphics on;

/* previous program */
/* must be run in the same SAS session*/
/*
proc glm data=statdata.ameshousing3
         order=internal
         plots(only)=intplot;
   class Season_Sold Heating_QC;
   model SalePrice=Heating_QC Season_Sold Heating_QC*Season_Sold;
   lsmeans Heating_QC*Season_Sold / diff slice=Heating_QC;
   format Season_Sold Season.;
   store out=interact;
   title "Model with Heating Quality and Season as Interacting "
         "Predictors";
run;
*/

proc plm restore=interact plots=all;
   slice Heating_QC*Season_Sold / sliceby=Heating_QC adjust=tukey;
   effectplot interaction(sliceby=Heating_QC) / clm;
run;
