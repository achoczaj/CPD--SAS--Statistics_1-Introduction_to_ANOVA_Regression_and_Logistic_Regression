/*
 * Practice 2: Producing Descriptive Statistics and Box Plots
 * Lesson 1: Introduction to Statistics
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/* Task:
You need to determine if the variables BodyTemp and HeartRate in the Statdata.NormTemp data set are normally distributed and if average body temperature is truly 98.6 degrees.
Reminder: Make sure you've defined the Statdata library.

1. Determine the minimum, maximum, mean, and standard deviation for the variables BodyTemp and HeartRate in the NormTemp data set. Also calculate the skewness and kurtosis statistics. Do the variables appear to be normally distributed? 

2. Create box plots for the BodyTemp and HeartRate variables. Use ID to identify outliers. For BodyTemp, display a reference line at 98.6 degrees. Does the average body temperature seem to be 98.6 degrees? 

3. In the NormTemp data set, which of the following phrases best describes the distributions of BodyTemp and HeartRate?
	pretty close to normal
	left-skewed
	right-skewed
	to have high positive kurtosis
	to have high negative kurtosis. 
*/

/* 1.*/
/*You use the NOPRINT option in both the PROC UNIVARIATE and HISTOGRAM statements 
to suppress the printing of the tabular output. 
Because the statistics are being reported in the insets of the plots, 
they are not needed in the output tables.*/
proc univariate data=statdata.normtemp noprint;
   var BodyTemp HeartRate;
   histogram BodyTemp HeartRate / normal(mu=est sigma=est noprint);
   inset min max skewness kurtosis / position=ne;
   probplot BodyTemp HeartRate / normal(mu=est sigma=est);
   inset min max skewness kurtosis;
   title 'Descriptive Statistics Using PROC UNIVARIATE';
run;
title;
/* The distributions for both variables look approximately normal.*/

/* 2.*/
proc sgplot data=statdata.normtemp;
   refline 98.6 / axis=y lineattrs=(color=blue);
   vbox BodyTemp / datalabel=ID;
   format ID 3.;
   title "Box Plots of Body Temps";
run;
proc sgplot data=statdata.normtemp;
   vbox HeartRate / datalabel=ID;
   format ID 3.;
   title "Box Plots of Heart Rate";
run;
title;
/* The average body temperature seems to be somewhat less than 98.6 degrees. */

/* 3. */
/*The correct answer is pretty close to normal. 
Because the histograms are bell shaped and the data follows 
the diagonal reference lines in the normal probability plots, 
the variables BodyTemp and HeartRate are both normally distributed. 

The skewness and kurtosis statistics are fairly close to zero 
for both variables as well, which tells us that BodyTemp and HeartRate 
are approximately normal.*/