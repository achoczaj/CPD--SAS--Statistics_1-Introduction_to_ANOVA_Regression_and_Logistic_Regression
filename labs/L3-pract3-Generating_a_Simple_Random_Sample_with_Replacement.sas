/*
 * Practice 3: Generating a Simple Random Sample with Replacement
 * Lesson 3: Accessing Observations Directly
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
In this practice, you generate a simple random sample with replacement.

Reminder: Make sure you've defined the Orion library.
1. Write a DATA step to generate a simple random sample with replacement 
that contains 20 customers from orion.customerdim. 
Submit the DATA step and verify that the program executed 
without errors.

2. Print the CustomerID and CustomerName variables in the work.sample data set, with the observation numbers suppressed, as shown in this report.

Note: Your results will vary from this report.
*/

/* 1.*/
data sample;
   drop i;
   do i=1 to 20;
      PickIt=ceil(ranuni(0)*TotObs);
      set orion.customerdim point=PickIt 
                            nobs=TotObs;
      output;
    end;
    stop;
run;


/* 2.*/
proc print data=sample noobs;
   var CustomerID CustomerName; 
   title 'Sample of Customers';
run;
title;