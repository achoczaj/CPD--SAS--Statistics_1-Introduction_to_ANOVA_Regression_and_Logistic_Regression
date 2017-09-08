/*
 * Practice 1: Examining Distributions
 * Lesson 5: Categorical Data Analysis
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
An insurance company wants to relate the safety of vehicles to several other variables. A score has been given to each vehicle model, using the frequency of insurance claims as a basis. The Statdata.Safety data set contains the data about vehicle safety.
Reminder: Make sure you've defined the Statdata library.
1. Write and submit a PROC FREQ step that creates one-way frequency tables for the variables Unsafe, Type, and Region. Add an appropriate title.
2. What is the measurement scale of each variable in the data set?
3. What is the proportion of cars made in North America?
4.Do the variables Unsafe, Type, and Region have any unusual values that warrant further investigation?
*/

/* 1.*/
proc freq data=statdata.safety;
   tables Unsafe Type Region;
   title 'Safety Data Frequencies';
run;
title;
/*
2. What is the measurement scale of each variable in the data set?
Unsafe – Categorical, Ordinal
Size – Categorical, Ordinal
Weight – Quantitative, Discrete
Region – Categorical, Nominal
Type – Categorical, Nominal

3. What is the proportion of cars made in North America?
63.54%

4. Do the variables Unsafe, Type, and Region have any unusual values that warrant further investigation?
No
*/