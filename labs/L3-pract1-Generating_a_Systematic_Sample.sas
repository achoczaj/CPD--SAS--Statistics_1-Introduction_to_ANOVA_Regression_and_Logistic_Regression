/*
 * Practice 1: Generating a Systematic Sample
 * Lesson 3: Accessing Observations Directly
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
In this practice, you generate a systematic sample.

Reminder: Make sure you've defined the Orion library.
1. Write a DATA step to generate a systematic sample 
by selecting every 10th supplier, starting with observation 10, 
from the data set orion.productdim. 
The sample should contain only the variables 
ProductLine, ProductID, ProductName, and SupplierName. 
Name the output data set productsample. 

2. Submit the DATA step and examine the log to confirm 
that productsample was created with 48 observations and 4 variables.

3. Print the first five observations of productsample. 
Omit the observation numbers from the report.
*/

/* 1.*/
data productsample;
   do i=10 to TotObs by 10;
      set orion.productdim
          (keep=ProductLine ProductID
                ProductName SupplierName)
          nobs = TotObs 
          point = i;
      output;
   end;
   stop;
run;


/*3.*/
proc print data=productsample(obs=5) noobs;
   title "Systematic Sample of Products";
run;
title;