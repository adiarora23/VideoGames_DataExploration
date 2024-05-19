/*
Project Four: SQL Data Exploration - Video Game Reviews & Sales

According to https://www.statista.com/outlook/dmo/digital-media/video-games/worldwide, the video games industry is projected to reach a revenue of $282.30bn.
It is also expected to grow at an annual rate of 8.76%, making the industry very lucrative for its time.

In this project, we will explore valuable insights on some of the best video games ever produced from 1977 to 2020.
*/

SELECT *
FROM GameReviews

SELECT *
FROM GameSales

-- We will be using all the columns in the dataset for this project!

-- Looking at top 10 best selling video games of all time and the year it was produced:
-- Note that we see the best selling video game of all time was Wii Sports (made in 2006), as it came packaged with the purchase of a Wii console.

SELECT TOP 10 *
FROM GameSales
ORDER BY Total_Shipped DESC -- Wanted highest to lowest amount

-- Looking at Top 10 best selling video games based on Popular platforms!

-- Wii:

SELECT TOP 10 *
FROM GameSales
WHERE Platform = 'Wii'
ORDER BY Total_Shipped DESC

-- PS2:

SELECT TOP 10 *
FROM GameSales
WHERE Platform = 'PS2'
ORDER BY Total_Shipped DESC

-- PC:

SELECT TOP 10 *
FROM GameSales
WHERE Platform = 'PC'
ORDER BY Total_Shipped DESC

-- Looking at the top 10 years with the highest average critic scores and many hits produced:
-- To do this, we will need to look at the GameReviews table, and join this with the GameSales table.

-- Looking at which games have no scores from both critics AND users <-- important so our insights can be as accurate as possible:
-- Note that only 42 games have no critic and user scores, which is manageable to work with (358 games WITH scores!)

SELECT COUNT(GameSales.Name)
FROM GameSales
LEFT JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
WHERE Critic_Score IS NULL AND User_Score IS NULL

-- Now, we can continue looking at the top 10 years with the highest average critic scores:
-- Notice that 1990 had the highest average critic score, but how many hits were actually produced?

SELECT TOP 10 Year, ROUND(AVG(Critic_Score), 2) AS Avg_critic_score
FROM GameSales
JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
GROUP BY Year
ORDER BY Avg_critic_score DESC

-- To answer this, we will take a deeper look at how many games were produced during these years to give a better analysis:
-- Note that 6 out of the top 10 years produced 5 or more hits, which means we should look at the top 10 years with the highest average critic score based on 5 or more produced hits!

SELECT TOP 10 Year, ROUND(AVG(Critic_Score), 2) AS Avg_critic_score, COUNT(GameSales.Name) AS Hits_produced
FROM GameSales
JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
GROUP BY Year
ORDER BY Avg_critic_score DESC

-- To do this, we will further expand the above query:
-- Note that some of the years have changed, but this would be a much more accurate representation of the top 10 years with the highest average critic scores of 5 or more hits produced!

SELECT TOP 10 Year, ROUND(AVG(Critic_Score), 2) AS Avg_critic_score, COUNT(GameSales.Name) AS Hits_produced
FROM GameSales
JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
GROUP BY Year
HAVING COUNT(GameSales.Name) >= 5
ORDER BY Avg_critic_score DESC

-- Now, since we have looked at the top 10 years with the highest average critic score, it's time to also consider the top 10 years with the highest average user scores!
-- This will give us a closer analysis of what years gamers really enjoyed versus those that were professionally critiqued:

SELECT TOP 10 Year, ROUND(AVG(User_Score), 2) AS Avg_user_score, COUNT(GameSales.Name) AS Hits_produced
FROM GameSales
JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
GROUP BY Year
ORDER BY Avg_user_score DESC

-- Note that these years include less than 5 games produced, so to fix this we will modify this query:
-- Again, as seen previously, the years may have changed slightly, but this is a much more accurate analysis of the top 10 years with the highest average user score of 5 or more hits!

SELECT TOP 10 Year, ROUND(AVG(User_Score), 2) AS Avg_user_score, COUNT(GameSales.Name) AS Hits_produced
FROM GameSales
JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
GROUP BY Year
HAVING COUNT(GameSales.Name) >= 5
ORDER BY Avg_user_score DESC

-- Now that we have looked at both the critic scores and user scores separately, we can now look at the best years with the highest scores combined!

SELECT TOP 10 Year, ROUND(AVG(Critic_Score), 2) AS Avg_critic_score, ROUND(AVG(User_Score), 2) AS Avg_user_score, COUNT(GameSales.Name) AS Hits_produced
FROM GameSales
JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
GROUP BY Year
HAVING COUNT(GameSales.Name) >= 5
ORDER BY Avg_critic_score DESC, Avg_user_score DESC

-- Finally, we look at the number of games sold in the best video game years:
-- Note that 2013 had the highest amount of games shipped, with over 434 million sold!

SELECT TOP 10 Year, SUM(Total_Shipped) AS total_games_shipped
FROM GameSales
JOIN GameReviews
	ON GameSales.Name = GameReviews.Name
GROUP BY Year
HAVING COUNT(GameSales.Name) >= 5
ORDER BY total_games_shipped DESC