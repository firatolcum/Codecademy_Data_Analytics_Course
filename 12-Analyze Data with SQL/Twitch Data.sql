
USE Twitch;


-- A. PROJECT SCOPE---------------------------------------------------------------------------

/* Twitch is the world’s leading live streaming platform for gamers, with 15 million daily active users. 
   Using data to understand its users and products is one of the main responsibilities of the Twitch Data Science Team.

   In this project, you will be working with two tables that contain Twitch users’ stream viewing data and chat room usage data.
		- Stream viewing data: stream table
		- Chat usage data: chat table */



-- A. GETTING STARTED-------------------------------------------------------------------------

/* 1. Start by getting a feel for the stream table and the chat table. 
      Select the first 20 rows from each of the two tables.
	  What are the column names? */

	SELECT TOP(20) *
	FROM chat;

	SELECT TOP(20) *
	FROM [stream];

/*  ANSWER :
	device_id, time, login, channel, country, player, game, stream_fromat, subscriber. */

/* 2. What are the unique games in the stream table? */
	
	SELECT DISTINCT(game)
	FROM stream;

/*  ANSWER :
	Heroes of the Storm, Fallout 3, Super Mario Bros. 3, DayZ, The Sims 4, Depth, H1Z1,
    League of Legends, Duck Game, Music, Cities: Skylines, Hektor, Gaming Talk Shows,
	Reign Of Kings, Bridge Constructor Medieval, Blackjack, You Must Build A Boat,
	Agar.io, Block N Load, The Last of Us, Choice Chamber, Lucius, Super Mario Bros.,
	Dota 2, Hearthstone: Heroes of Warcraft, SpeedRunners, Devil May Cry 4: Special Edition,
	The Elder Scrolls V: Skyrim, Counter-Strike: Global Offensive, Rocket League,
	The Binding of Isaac: Rebirth, Mortal Kombat X, Grand Theft Auto V, World of Tanks,
	The Witcher 3: Wild Hunt, Senran Kagura: Estival Versus, ARK: Survival Evolved,
	Batman: Arkham Knight, Breaking Point, Risk of Rain, Besiege */

/* 3. What are the unique channels in the stream table? */

	SELECT DISTINCT(channel)
	FROM stream;

/*	ANSWER :
	kramer, helen, george, newman, frank, estelle, susan, elaine, morty, jerry */


-- B. AGGREGATE FUNCTIONS---------------------------------------------------------------------

/* 4. What are the most popular games in the stream table?
	  Create a list of games and their number of viewers using GROUP BY. */

	SELECT game, COUNT(DISTINCT device_id) AS count_
	FROM stream
	GROUP BY game
	ORDER BY count_ DESC

/*	ANSWER :
	League of Legends, Dota 2, Counter-Strike: Global Offensive, DayZ, Heroes of the Storm. */


/* 5. These are some big numbers from the game League of Legends (also known as LoL).
	  Where are these LoL stream viewers located?
	  Create a list of countries and their number of LoL viewers using WHERE and GROUP BY. */

	SELECT country, COUNT(DISTINCT device_id) AS count_of_user
	FROM stream
	WHERE game = 'League of Legends'
	GROUP BY country
	ORDER BY count_of_user DESC;

/*	ANSWER:
	US, CA, DE, GB, TR. */
	


/* 6. The player column contains the source the user is using to view the stream (site, iphone, android, etc).
	  Create a list of players and their number of streamers. */

	SELECT player, COUNT(DISTINCT device_id) AS count_of_user
	FROM stream
	GROUP BY player
	ORDER BY count_of_user DESC;



/* 7. Create a new column named genre for each of the games.
	  Group the games into their genres: Multiplayer Online Battle Arena (MOBA), First Person Shooter (FPS), Survival, and Other.
	  Using CASE, your logic should be:
			- If League of Legends → MOBA
			- If Dota 2 → MOBA
			- If Heroes of the Storm → MOBA
			- If Counter-Strike: Global Offensive → FPS
			- If DayZ → Survival
			- If ARK: Survival Evolved → Survival
			- Else → Other
	  Use GROUP BY and ORDER BY to showcase only the unique game titles. */

	WITH CTE AS(
				SELECT 
					CASE
						WHEN game = 'League of Legends' THEN 'MOBA'
						WHEN game = 'Dota 2' THEN 'MOBA'
						WHEN game = 'Heroes of the Storm' THEN 'MOBA'
						WHEN game = 'Counter-Strike: Global Offensive' THEN 'FPS'
						WHEN game = 'DayZ' THEN 'Survival'
						WHEN game = 'ARK: Survival Evolved' THEN 'Survival'
						ELSE 'Other'
					END AS genre
				FROM stream
				)
	SELECT genre, COUNT(genre) AS count_
	FROM CTE
	GROUP BY genre
	ORDER BY count_ DESC;


-- C. HOW DOES VIEW COUNT CHANGE IN THE COURSE OF A DAY?--------------------------------------

/* 8. Before we get started, 
	  let’s run this query and take a look at the time column from the stream table:*/

	  SELECT TOP 100 [time]
	  FROM stream

	/* The data type of the time column is DATETIME. 
	   It is for storing a date/time value in the database.
	   Notice that the values are formatted like: 2015-01-01 18:33:52
	   So the format is: YYYY-MM-DD HH:MM:SS */


/* 9. SQL Server comes with a DATEPART() function - a very powerful function that allows you to return a formatted date.
	  It takes two arguments: DATEPART(format, column)
	  Let’s test this function out: */

	  SELECT time, DATEPART(SECOND, [time]) AS [second]
	  FROM stream;


/* 10. Okay, now we understand how DATEPART() works. 
       Let’s write a query that returns two columns:
	      - The hours of the time column
		  - The view count for each hour
	   Lastly, filter the result with only the users in your country using a WHERE clause. */

	   SELECT DATEPART(HOUR, [time]) AS [hour], COUNT(DISTINCT device_id) count_of_device
	   FROM stream
	   WHERE country = 'TR'
	   GROUP BY DATEPART(HOUR, [time])
	   ORDER BY count_of_device DESC;

-- D. JOINING TWO TABLES----------------------------------------------------------------------

/* 11. The stream table and the chat table share a column: device_id.
	   Let’s join the two tables on that column. */

	   SELECT *
	   FROM chat c
	   INNER JOIN stream s
	   ON c.device_id = s.device_id