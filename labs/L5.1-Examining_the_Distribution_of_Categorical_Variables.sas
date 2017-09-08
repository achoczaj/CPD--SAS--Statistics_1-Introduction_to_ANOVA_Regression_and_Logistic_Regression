/*
 * Lab 5.1: Examining the Distribution of Categorical Variables
 * Lesson 5: Categorical Data Analysis
 * ECST131 - Statistics I: Introduction to ANOVA, Regression, and Logistic Regression
 */

/*
Examining the Distribution of Categorical Variables

A good starting point for any analysis is to get to know your data. When you're working with categorical variables, you'll want to know what the values are and the frequency of each value. For example, suppose you're working with data about the sinking of the Titanic ocean liner in 1912. You want to find out whether any of the characteristics of the people on board affected their survival.

In your data, the categorical response variable Survived indicates whether or not each person survived. One of the categorical predictor variables, Class, identifies each person's class of travel as crew, first, second, or third. Other categorical variables are Age and Gender.

You're wondering how people's class, age, and gender might have affected their survival. Using SAS, you can explore the distribution of your variables, both individually and in combination. By examining distributions, you can make a preliminary assessment of the relationships between the variables. 


One-Way Frequency Tables

When you examine the distribution of a categorical variable, you want to know the values of the variable and the frequency (or count) of each value in the data. You can view this information in a one-way frequency table. In SAS, a one-way frequency table is called simply a frequency table. For example, this SAS frequency table provides information about the distribution of the categorical variable Class. Class is a variable in the Titanic2 data set, which stores data about people on board the Titanic ocean liner when it sank in 1912. 

A SAS frequency table lists the distinct values of a variable in alphanumeric order. If the variable has a permanent format, the table displays the formatted values. In this frequency table, the Class variable has four distinct values. The values of a variable are also called the levels of the variable. From the list of values, you can tell at a glance whether the variable has any miscoded values. For example, if third was misspelled in an observation, it would appear as another value in the list. Missing values are not listed in a SAS frequency table. However, if a variable has missing values, the frequency, or number, of missing values is listed below the table. 

For each listed value, a frequency table displays its frequency, or count—the number of times that value appears for the variable in the data. Here's a question: Which value of Class appears most frequently? The value crew has the highest frequency: 885 people were crew members. The value second has the lowest frequency: only 285 passengers were in second class. 

A SAS frequency table also displays additional frequency statistics. Percent indicates the percentage of the total number of observations that have the value. The Percent value is 100 times the relative frequency. For example, the 885 crew members represent about 40% of all the people aboard the Titanic. The second-class passengers represent the smallest percentage of all people aboard the Titanic: approximately 13%. 

Cumulative Frequency shows the sum of the frequency counts for the current value and all other values listed above it in the table. Here's a question: How many people were in either the crew or first class? The cumulative frequency statistic for the value first is 1210, indicating that 1210 people were in either the crew or first class. The last value in the Cumulative Frequency column is the total number of observations in the data set that have a nonmissing value of the variable. In this data set, 2201 observations have a nonmissing value so, according to this data set, 2201 people were aboard the Titanic when it sank. 

Cumulative Percent shows the percentage of the total number of observations that have the current value and all other values listed above it in the table. The last row always displays 100; 100% of the observations contain the last value and all other values listed above it. Here's a question: What percent of people were in either the crew or first or second class? Approximately 68 percent of people aboard the Titanic were in the crew or first or second class.


Association between Categorical Variables

When you're exploring your data, you can identify possible associations among categorical variables. An association exists between two variables if the distribution of one variable changes when the value of the other variable changes. If there's no association, the distribution of the first variable is the same regardless of the level of the other variable. To look for associations, you examine the combinations of values of multiple variables.

Let's look at a simple example. Suppose you want to determine whether your manager's mood is affected by the weather. The categorical response variable is your manager's mood, and its values can be either happy or grumpy. The categorical predictor variable is the weather, and its values can be either sunny or cloudy. This simplified table shows frequency percentages for combinations of values of the two variables by row. On sunny days, your manager is happy 72% of the time and grumpy 28% of the time. Now look at the frequency percentages for your manager's mood on cloudy days. Here's a question: Is your manager's mood associated with the weather? The row percentages are the same in each column, indicating that there is no change in your manager's mood based on the weather. So, there is no association between these two variables.

Now suppose you're working with some different percentages. Here's a question: Based on these new numbers, is there an association between your manager's mood and the weather? The row percentages are different in each column. On sunny days, your manager is happy 82% of the time. But, on cloudy days, your manager is happy only 60% of the time. Your manager's mood changed based on the weather, so there appears to be an association between these two variables. You don't know whether the association is statistically significant. To determine statistical significance, you need to use other analytical tests, such as chi-square.


Crosstabulation Tables

To look for a possible association between two or more categorical variables, you can create a crosstabulation table. A crosstabulation table is also known as a contingency table. For example, you might want to know whether the gender of people on board the Titanic ocean liner affected their survival when the ship sank. A crosstabulation table shows frequency statistics for each combination of values (or levels) of the variables. This SAS crosstabulation table shows statistics for the combinations of the values of two variables: Gender (in the rows) and Survived (in the columns). A crosstabulation table that displays statistics for two variables can also be called a two-way frequency table. 

In a SAS crosstabulation table, the last cell in each row displays total frequency statistics for that row, and the last cell in each column displays total frequency statistics for that column. The legend at the upper left identifies the statistics that appear in each cell. 

Frequency indicates the number of observations that contain both the row variable value and the column variable value. The top left table cell indicates that 126 observations in the data set are for females who did not survive. 

Percent indicates the number of observations in each cell as a percentage of the total number of observations in the data set. At the bottom right, where the Total row and the Total column intersect, notice that the data set has a total of 2201 observations. Here's a question: What percentage of observations in the entire data set are for females who did not survive? Just under 6% of the people in the data set are females who did not survive. 

Row Pct indicates the number of observations in each cell as a percentage of the total number of observations in that row. The total number of observations for each row appears in the Total column for the row. In this table, the first cell indicates that the 126 observations for females who did not survive represent approximately 27% of all 470 females listed in the data set. 

Col Pct indicates the number of observations in each cell as a percentage of the total number of observations in that column. The total number of observations for each column appears at the bottom. Here's a question: What percent of all people who did not survive are female? Only about 8% of the 1490 people who did not survive are female.

Here's a question: Is there an association between Gender and Survived? About 73% of the females aboard the Titanic survived but only about 21% of the men survived. This crosstabulation table shows that the distribution of Survived does change with the levels of Gender, so these two variables appear to be associated. However, a crosstabulation table can't tell you whether an association is statistically significant.


The TABLES Statement in PROC FREQ

To create frequency and crosstabulation tables in SAS, you use the TABLES statement in the FREQUENCY procedure. The TABLES statement requests one or more frequency and crosstabulation tables and statistics for those tables. A table request for a one-way frequency table consists of a single variable name. In this basic PROC FREQ step, the TABLES statement creates one frequency table, which is for the Purchase variable in the Sales data set. 

You separate multiple table requests with a space. In this example, the TABLES statement requests individual frequency tables for three categorical variables: Purchase, Gender, and Income. To request a crosstabulation table, you specify an asterisk between the names of the variables that you want to appear in the table. For a two-way table, a table request consists of variable-1*variable-2. The first variable represents the rows, and the second variable represents the columns. For example, this TABLES statement now contains an additional table request for a crosstabulation of Gender by Purchase.

Let's go back to an earlier example that requests 3 one-way frequency tables—one each for Purchase, Gender, and Income. Here's a question: How would you request a three-way crosstabulation table for these three variables? To request a three-way crosstabulation, you replace each space between the variable names with an asterisk. 

When you write a PROC FREQ step to request frequency and crosstabulation tables, keep in mind that PROC FREQ can generate large volumes of output as the number of variables or the number of variable levels – or both – increases. In the TABLES statement, you can use many different options, which are listed in SAS Help and Documentation. Notice that a forward slash must appear before the list of options. You can use many of these options to request or suppress statistics and other table information in your PROC FREQ output.  

When ODS Graphics is enabled, you can use the PLOTS= option to request specific plots. Two distribution plots are associated with a frequency or crosstabulation table: a frequency plot and a cumulative frequency plot. In this example, the PLOTS= option tells ODS Graphics to produce a frequency plot for each table requested in the TABLES statement. After the equal sign, the request for the frequency plot appears in parentheses. When you specify only one plot request, the parentheses are optional. However, if you specify multiple plot requests, you must use parentheses and separate the plot requests by a space. 
*/

/*
Scenario: Testing for Associations and Fitting a Logistic Model

Suppose you work for a company that sells products through a catalog. The company wants to offer credit cards to a subset of customers: those who are likely to spend $100 or more on merchandise in a six-month period. Your job is to determine the characteristics that predict which customers purchase the target amount so that the company can send credit card offers to the biggest spenders. You'll be working with the Sales data set, which contains information about a representative sample of the company's customers from the last six months. To complete your assignment, you need to perform several tasks. These include: examining the distribution of the variables, testing for associations, and fitting a model that explains the relationship between your predictor variables and the response variable. 

Let's take a closer look at the Sales data. Click the information button to view the data. Each observation in Sales stores information about a single customer. The data set has four variables. Purchase has two values: 1 indicates that the customer's purchases totaled $100 or more. 0 indicates that the customer's purchases totaled less than $100. Gender indicates the customer's gender as either Male or Female. Income categorizes the annual income of the customer into one of three categories: Low, Medium, or High. Age specifies the age of the customer in years.

To select the appropriate type of analysis later in the process, it's important to identify the scale of measurement of your variables. First, you determine whether each variable is categorical or continuous. Here's a question: Which of the variables in Sales are categorical? Purchase, Gender, and Income are categorical variables because each has only a few discrete values. Age is a continuous variable. 

Remember that there are two types of categorical variables: nominal and ordinal. Here's a question: Which of the categorical variables Purchase, Gender, and Income are ordinal? Income is an ordinal variable because its three values can be ordered logically by magnitude: Low, Medium, and High. The two values of Purchase can also be ordered logically by magnitude. However, Purchase is a binary variable—a variable that has two distinct values. It doesn't matter whether you treat binary variables as ordinal or nominal in your analysis. 

Here's another question: What is the response variable for your analysis? Purchase is the response variable because you want to find out which customer characteristics are associated with a purchase amount of $100 or more. The remaining variables are potential predictor variables. You want to see whether a customer's gender, income, and age are associated with the amount of money the customer spends on merchandise.
 */

/**************************************************
Examining the Distribution of Categorical Variables
***************************************************/
/*
Let's see a demonstration of examining the distribution of categorical variables. 
We'll take a look at the program before we run it.
*/
ods graphics / width=500;

proc freq data=statdata.sales;
   tables Purchase Gender Income
          Gender*Purchase
          Income*Purchase  
          		/ plots=(freqplot); 
   format Purchase purfmt.;
   title1 'Frequency Tables for Sales Data';
run;
table;

ods select histogram probplot;  

proc univariate data=statdata.sales;
   var Age;
   histogram Age / normal (mu=est
                   sigma=est); 
   probplot Age / normal (mu=est
                  sigma=est);
   title1 'Distribution of Age'; 
run;

title;
/*
In the PROC FREQ step, the TABLES statement requests individual frequency tables 
for the categorical variables Purchase, Gender, and Income in the Sales data set. 
The TABLES statement also requests crosstabulation tables for Gender by Purchase 
and Income by Purchase. The PLOTS= option requests a frequency plot for each frequency and crosstabulation table. 

The FORMAT statement applies a user-defined format to the values of Purchase. This format already exists. To see why the format is useful, let's look at the values of Purchase in Sales. Notice that the stored values are coded: they consist of ones and zeros. The Purchase format specifies easy-to-read character strings for the stored values. Wherever the values of Purchase appear in the output, these character strings will appear instead of ones and zeroes. Remember that applying a format in a PROC FREQ step changes only the output; the stored values remain the same. 

Next, we examine the distribution of the continuous variable Age. The PROC UNIVARIATE step and the ODS SELECT statement above it request a histogram and a probability plot for this variable. 

Let's run the code. The log shows that the code ran without errors. 

At the top of the PROC FREQ output are the frequency table and plot for Purchase. As expected, the values of Purchase are shown as character strings. Of the 431 customers in the data set, notice that only 162—or about 38%—spent $100 or more. The frequency table and plot for Gender show that more of the customers in the data set—about 56%—are female. The customers are fairly evenly divided into the three income groups: High, Low, and Medium. 155 have a high income, 132 have a low income, and 144 have a medium income. Remember that PROC FREQ is an excellent tool for detecting any miscoded data. Unusual values would be easy to spot in the output. However, these frequency tables have no unusual data values that could indicate coding errors. 

Now let's look at the crosstabulation tables. These tables can provide a preliminary indication of an association between the response variable Purchase and each of the predictor variables, Gender and Income. First, we see whether the values of Purchase are different based on the values of Gender. Remember that the key for the statistics in each cell appears in the upper left corner of the table. We're interested in people who spent more than $100, so we'll start with the second column. 101 females spent $100 or more, and this represents about 23% of the data. The row percent is 42.08%, which indicates that approximately 42% of females spent $100 or more. The column percent is 62.35%, so approximately 62% of people who spent $100 or more were female. 61 males spent $100 or more, which is about 14.15% of the data. The row percent 31.94 for males tells us that approximately 32% of males spent $100 or more. The column percent 37.65 tells us that approximately 38% of the people who spent $100 or more were male. Here's a question: Is gender associated with purchasing habits? The row probabilities are different, so there appears to be an association between gender and purchasing habits. 42% of females spent at least $100 as compared with only 32% of males. However, we can't tell whether this difference is significant until we perform a more formal test of association. 

Now let's look at the crosstabulation table and frequency plot for Income by Purchase. Remember that Income is an ordinal variable. Here's a question: Are the values of Income displayed in a logical order? The values of Income are not displayed in a logical order. The order of the levels will make a difference when we perform more formal tests of association later. Before we can examine this relationship further, we'll have to reorder the levels of Income. 

Finally, we'll take a quick look at the distribution of Age. The first plot shows that Age is normally distributed. Normality of the predictor variables is not an assumption in regression; we're just getting to know our data. In the second plot, also, the distribution of Age appears approximately normal. There are no obvious outliers. 
 */