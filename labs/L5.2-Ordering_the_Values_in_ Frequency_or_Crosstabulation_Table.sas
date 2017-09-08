/*
 * Lab 5.2: Ordering the Values in a Frequency or Crosstabulation Table
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Ordering the Values of an Ordinal Variable

When you're working with ordinal variables, such as Income, 
it's important to order the values logically 
before you run statistical tests. 
If you don't order the values logically, 
you're treating an ordinal variable as nominal
and that can reduce the power of statistical tests. 

When ordinal values are not ordered logically, 
you are limited to using statistical tests 
that can indicate only a general association between variables. 

To use more powerful statistical tests that can detect linear associations, 
you must first arrange the values logically.


In PROC FREQ output, the default order for character values is alphanumeric. 
In this frequency table, the values of Income are listed by default 
as High, Low, and Medium instead of in a logical order, by magnitude. 

In other words, Income is treated as a nominal variable 
instead of an ordinal variable. 
When you order values logically, your output tables and graphs 
are easier to read and interpret. 

One way of reordering the values of an ordinal variable like Income 
in your PROC FREQ output is to create a new variable 
in which the values are stored in logical order. 

You start by creating a copy of the original data set. 
In this example, Income is a variable in the Sales data set. 
In the new data set, you create another version of the ordinal column, 
which has values that sort in logical order by default. 

In this example, the new IncLevel column uses the integers 1, 2, and 3 
to indicate the three income levels. 
The alphanumeric order of these values is also the logical order. 

To reorder the values of an ordinal variable in your PROC FREQ output, 
you can also apply a temporary format to the original variable. 
For more information about this method, click the information button.
 */

/*
Let's see a demonstration of ordering the values in a frequency table. 

In the tables and plots that we created in the last demonstration, the values are shown in the default order, which is alphanumeric but not logical. Let's create new results in which the income levels are ordered logically. 

Our SAS program starts with a DATA step that creates a new version of the Sales data set and names it Sales_Inc.
*/
data statdata.sales_inc;
   set statdata.sales;
   if Income='Low' then IncLevel=1;
   else If Income='Medium' then IncLevel=2;
   else If Income='High' then IncLevel=3;
run;

ods graphics / width=500;

proc freq data=statdata.sales_inc;
   tables IncLevel*Purchase / plots=freq;
   format IncLevel incfmt. Purchase purfmt.;
   title1 'Create variable IncLevel to correct Income';
run;

title;
/* The new data set has an additional variable named IncLevel that stores the three income levels. Instead of the character values used for the variable Income, which did not sort logically, IncLevel uses the numeric values 1, 2, and 3 to designate the levels. In the PROC FREQ step, the TABLES statement requests a crosstabulation table and a frequency plot for IncLevel by Purchase. To make the values easier to read in the output, we're using the FORMAT statement to apply a format to IncLevel. This format already exists. Notice the character strings that will display instead of the numeric values of IncLevel. The FORMAT statement also applies an existing format to the Purchase values, as in the last demonstration. 

Let's run the code. The log shows that our program ran without errors. 

In the crosstabulation table, the income levels are displayed in logical order, from low to high. The row percentages indicate that there probably is an association between income level and purchasing behavior. For example, 48% of the high-income customers made purchases of $100 or more compared to 32% of the low‑income customers and 32% of the medium-income customers. Notice that there is not much difference between the row percentages for low- and medium-income customers. However, of the customers who spent $100 or more, it's likely that the number of high-income customers is statistically different from the number of low- or medium-income customers. Determining the statistical significance of the difference will require a formal test of association. 

Below the table, the frequency plot displays the count of observations at each level of the two variables.
 */