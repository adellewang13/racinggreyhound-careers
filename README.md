# racinggreyhound-careers
Name: Adelle Wang

Anticipated graduation month/year: May 2024

Capstone Advisor: Eni Mustafaraj

Draft Title: What can predict the length of a racing greyhound’s career?

Github Link: https://github.com/adellewang13/racinggreyhound-careers

State an interesting question that can be answered with data: 
To what extent can a racing greyhound’s career length (in number of races) be predicted by variables including sex of the dog, percentage of races won, distance run per race, number of years active, and number of races placed in top 3? 

Get the data:
Data source: https://www.greyhound-data.com/
Collection: Looking at 5 sets of 100 top dogs in USA from 2016 to 2021 (an average career spans from 1.5 to 3.5 years, range of 5 years was chosen from 4 years ago to eliminate greyhounds that have not yet run all their career races). Number of career races is collected by scraping each dog’s webpage.

Explore and Visualize the data: 
	The data is well organized with no missing data. Data processing involves transfer from webpage to a workable file, and collecting response values (number of career races). Data cleaning is needed after individual data is collected by eliminating duplicates across years. 
	Below are sample scatter plots created with the top 20 dogs from 2016, demonstrating potential relationships between career length and number of races they placed top 3, and percent of races won in 2016.  


Model the data: 
I will test models of multiple linear regression and ensemble tree-based methods to determine the best model and combination of variables to predict career length. Lasso and ridge penalized models may be applicable to address multicollinearity. Box-Cox transformation may be used if data is not suitable for regression. Predictors: sex of dog, percentage of races won, distance run per race, number of years active, and number of top 3 placements. 

Summarize the results so far: 
	Tentative results with small subsets: Positive correlation between career length and the number of races placed in the top 3; negative correlation between career length and the number of races won. This may demonstrate that a generally successful dog will have a longer career, but a dog pushed to place 1st may need to retire earlier due to health decline. 
	Limitations: Predictor variables with redundant information may affect cleaning or overfitting.
	Further questions: Could other predictors such as characteristics of owner or kennel, and of sire or dam, influence career length? Could comparing dogs at different stages in their career (start, peak, decline) bias results?

Data ethics:
Concerns of animal welfare: Ensuring that this project does not encourage harmful greyhound racing practices.

Data privacy: The data is posted publicly online. This project will not access private information of owners or breeders. 

Is this capstone a continuation of a class project? NA

Is this capstone based on an internship? NA

https://www.greyhound-data.com/db.php?z=q2zkBK&masterbreeders=8&raceland=US&year=2016&mindist=0&maxdist=unlimited&go=+Calculate+statistic+
