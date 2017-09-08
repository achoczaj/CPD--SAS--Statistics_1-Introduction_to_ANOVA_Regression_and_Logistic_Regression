/*
 * Practice 2: Performing Tests and Measures of Association
 * Lesson 5: Categorical Data Analysis
 * ECPG393 - SAS Programming 3 - Advanced Techniques and Efficiencies
 */
/* Task:
The insurance company wants to determine whether a vehicle's safety score is associated with either the region in which it was manufactured or the vehicle's size. The Statdata.Safety data set contains the data that you need.

Reminder: Make sure that you have defined the Library and Statdata libraries.

Write a PROC FREQ step that generates the crosstabulation of the variables Region by Unsafe. Along with the default output, generate the expected frequencies, the chi-square test of association, and the odds ratio. To clearly identify the values of Unsafe, apply the SAFEFMT. format. (This format is defined in the setup program for this course.) Add an appropriate title. Submit the code and check the log.


For the cars made in Asia, what percentage had a below-average safety score?


For the cars with an average or above safety score, what percentage were made in North America?


Do you see a statistically significant association (at the 0.05 level) between Region and Unsafe?


What does this odds ratio compare? What does it say about the difference in odds between Asian and North American cars?


Write another PROC FREQ step that generates the crosstabulation of the variables Size by Unsafe. Along with the default output, generate the measures of ordinal association. To clearly identify the values of Unsafe, apply the SAFEFMT. format. Add an appropriate title. Submit the code and check the log. 


What statistic do you use to detect an ordinal association between Size and Unsafe?


Do you reject or fail to reject the null hypothesis at the 0.05 level?


What is the strength of the ordinal association between Size and Unsafe?


What is the 95% confidence interval around the statistic that measures the strength of the ordinal association?
*/

/* 1.*/
proc freq data=statdata.safety;
   tables Region*Unsafe / chisq relrisk expected;
   format Unsafe safefmt.;
   title "Association between Unsafe and Region";
run;

title;
/*
2. For the cars made in Asia, what percentage had a below-average safety score?
Region is a row variable, so look at the row percent value in the Below Average cell of the Asia row. 42.86% of the cars made in Asia had a below-average safety score.

3. For the cars with an average or above safety score, what percentage were made in North America?
Look at the column percent value for the cell for North America in the column for Average or Above. 69.70% of the cars with an average or above safety score were made in North America.

4. Do you see a statistically significant association (at the 0.05 level) between Region and Unsafe?
The association is not statistically significant at the 0.05 alpha level. The p-value is 0.0631.

5. What does this odds ratio compare? What does it say about the difference in odds between Asian and North American cars?
The odds ratio compares the odds of below average safety for North America versus Asia. The odds ratio of 0.4348 means that cars made in North America have 56.52 percent lower odds for being unsafe than cars made in Asia.

6. Write another PROC FREQ step that generates the crosstabulation of the variables Size by Unsafe. Along with the default output, generate the measures of ordinal association. To clearly identify the values of Unsafe, apply the SAFEFMT. format. Add an appropriate title. Submit the code and check the log. */
proc freq data=statdata.safety;
   tables Size*Unsafe / chisq measures cl;
   format Unsafe safefmt.;
   title "Association between Unsafe and Size";
run;

title;
/*
7. What statistic do you use to detect an ordinal association between Size and Unsafe?
The Mantel-Haenszel chi-square detects an ordinal association.

8. Do you reject or fail to reject the null hypothesis at the 0.05 level?
You reject the null hypothesis at the 0.05 level.

9. What is the strength of the ordinal association between Size and Unsafe?
The Spearman Correlation is -0.5425.

10. What is the 95% confidence interval around the statistic that measures the strength of the ordinal association?
The confidence interval is (-0.6932 , -0.3917).
*/