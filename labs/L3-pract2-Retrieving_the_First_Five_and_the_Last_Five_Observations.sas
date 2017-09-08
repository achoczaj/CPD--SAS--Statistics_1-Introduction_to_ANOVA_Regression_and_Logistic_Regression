/*
 * Practice 2: Retrieving the First Five and the Last Five Observations
 * Lesson 3: Accessing Observations Directly
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
In this practice, you use the DATA step to directly access the first five and the last five observations from a data set.

Reminder: Make sure you've defined the Orion library.
1. Write a DATA step to create two data sets, 
work.highest and work.lowest.
- The data set work.highest will contain the five managers 
with the highest combined salary groups.
- The data set work.lowest will contain the five managers 
with the lowest combined salary groups.
- Use the data set orion.totalsalaries to retrieve the observations. 
Each observation in orion.totalsalaries represents 
one manager's total salary amount for all of his or her employees.

2.Submit the program and examine the log.

3. Print work.highest and work.lowest, with observation numbers suppressed, as shown in this report.
*/

/* 1.*/
proc sort data=orion.totalsalaries
          out=sortedtotalsalaries;
   by DeptSal;
run;

data lowest highest;
   do ReadsObs=1 to 5;
      set sortedtotalsalaries;
      output lowest;
   end;
   do ReadObs=(TotObs) to (TotObs-4) by -1;
      set sortedtotalsalaries 
          nobs=TotObs point=ReadObs;
      output highest;
   end;
   stop;
run;


/*3.*/
proc print data=highest noobs;
   title 'Top 5 Managers with the highest combined salary groups';
run;

proc print data=lowest noobs;
   title 'Bottom 5 managers with the lowest combined salary groups';
run;

title;