SET FOREIGN_KEY_CHECKS = 0;

/* Creates the table to be populated with players. Player names must be unique.
 * PlayerID is used when submitting scores and for generating scoreboards.
 */
DROP TABLE IF EXISTS Players;
CREATE TABLE Players (
   PlayerID		INT(5)		NOT NULL	AUTO_INCREMENT
  ,PlayerName		VARCHAR(50)	NOT NULL	UNIQUE
  ,PlayerPassword	VARCHAR(50)	NOT NULL	
  ,Token 		VARCHAR(50) 	NOT NULL 	UNIQUE
  ,IsAdmin 		BOOLEAN		DEFAULT FALSE
  ,PRIMARY KEY(PlayerID)
) ENGINE = InnoDB;


/* Creates the table to be populated by quizzes. The answers to the quiz are 
 * stored in the table QuizAnswers. StartYear and EndYear are used to populate
 * the dynamic game-site with the corresponding buttons, one for each year.
 */
DROP TABLE IF EXISTS Quizzes;
CREATE TABLE Quizzes (
   QuizID		INT(5)		NOT NULL	AUTO_INCREMENT
  ,StartYear		INT(4)		NOT NULL
  ,EndYear		INT(4)		NOT NULL
  ,CreatedByPlayerID	INT(5)		NOT NULL
  ,PRIMARY KEY(QuizID)
  ,FOREIGN KEY(CreatedByPlayerID) REFERENCES Players(PlayerID)
) ENGINE = InnoDB;


/* Creates the table to be populated by answers to the specific quizzes. 
 * The order of songs must be manually entered in the variable SongNumber.
 */
DROP TABLE IF EXISTS QuizAnswers;
CREATE TABLE QuizAnswers (
   QuizID	INT(5)		NOT NULL
  ,Year		INT(4)		NULL		
  ,Artist	VARCHAR(100)	NULL
  ,Title	VARCHAR(100)	NULL
  ,SongNumber	INT(2)		NULL		
  ,FOREIGN KEY(QuizID) REFERENCES Quizzes(QuizID)
) ENGINE = InnoDB;


/* Creates the table to be populated by games. Games are hosted by a player 
 * and must reference an existing quiz. This makes it possible for multiple 
 * players to play the same quiz, but compete only against selected players.
 */
DROP TABLE IF EXISTS Games;
CREATE TABLE Games (
   GameID		INT(5)		NOT NULL	AUTO_INCREMENT
  ,GamePassword 	VARCHAR(20)	NOT NULL	UNIQUE
  ,GameTitle  VARCHAR(100) NOT NULL
  ,QuizID		INT(5)		NOT NULL
  ,HostedByPlayerID	INT(5)		NOT NULL
  ,PRIMARY KEY(GameID)
  ,FOREIGN KEY(HostedByPlayerID) REFERENCES Players(PlayerID)
  ,FOREIGN KEY(QuizID) REFERENCES Quizzes(QuizID)
) ENGINE = InnoDB;


/* Create table to keep track of players' participations in games. One player
can participate in one game at a time but multiple games over the course of
their illustrious quiz careers.
*/
DROP TABLE IF EXISTS GameParticipations;
CREATE TABLE GameParticipations (
   PlayerID INT(5)  NOT NULL
  ,GameID INT(5)  NOT NULL
  ,JoinTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  ,PRIMARY KEY (PlayerID, GameID)
  ,FOREIGN KEY(PlayerID) REFERENCES Players(PlayerID)
  ,FOREIGN KEY(GameID) REFERENCES Games(GameID)
) ENGINE = InnoDB;

/* Creates the table to be populated by answers to specific games. 
 */
DROP TABLE IF EXISTS PlayerAnswers;
CREATE TABLE PlayerAnswers (
   AnswerID	INT(5)		NOT NULL	AUTO_INCREMENT
  ,GameID	INT(5)		NOT NULL
  ,PlayerID	INT(5)		NOT NULL
  ,SongNumber	INT(2)		NOT NULL
  ,Year		INT(4)		NOT NULL
  ,PRIMARY KEY(AnswerID)
  ,FOREIGN KEY(GameID) REFERENCES Games(GameID)
  ,FOREIGN KEY(PlayerID) REFERENCES Players(PlayerID)
) ENGINE = InnoDB;


/* Creates a tallytable for easy generating series of values,
 * useful for ex. procedures and dynamic scoreboard views.
 */ 
CREATE OR REPLACE VIEW generator_16
AS SELECT 0 n UNION ALL SELECT 1  UNION ALL SELECT 2  UNION ALL 
   SELECT 3   UNION ALL SELECT 4  UNION ALL SELECT 5  UNION ALL
   SELECT 6   UNION ALL SELECT 7  UNION ALL SELECT 8  UNION ALL
   SELECT 9   UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
   SELECT 12  UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL 
   SELECT 15;

DROP TABLE IF EXISTS TallyTable;
CREATE TABLE TallyTable (n INT(2)) ENGINE=InnoDB;
INSERT INTO TallyTable (n)
SELECT ( ( hi.n << 4 ) | lo.n ) AS n
FROM generator_16 lo, generator_16 hi
WHERE ( ( hi.n << 4 ) | lo.n ) BETWEEN 0 AND 99;
			       
DROP VIEW IF EXISTS generator_16;


/* Created the procedure to create a row for every year in the
 * QuizAnswers table after creating a Quiz with StartYear and
 * EndYear.
 */
DROP PROCEDURE IF EXISTS PrepareQuizAnswers;
DELIMITER //
  CREATE PROCEDURE PrepareQuizAnswers(
    IN in_QuizID	INT(5)
  )
  BEGIN
    DELETE FROM QuizAnswers WHERE QuizID = in_QuizID;
    
    SET @StartYear = (SELECT MAX(StartYear) FROM Quizzes WHERE QuizID = in_QuizID);
    SET @NumberOfYears = (SELECT MAX(EndYear) - MAX(StartYear) + 1 FROM Quizzes WHERE QuizID = in_QuizID);

    INSERT INTO QuizAnswers (QuizID, Year)
    SELECT 1 AS QuizID, n + @StartYear	AS Year
    FROM TallyTable
    WHERE n < @NumberOfYears;

  END
//
DELIMITER ;
			       
CREATE TRIGGER after_quiz_update
  AFTER INSERT ON Quizzes FOR EACH ROW
  CALL PrepareQuizAnswers(NEW.QuizID);


CREATE OR REPLACE VIEW QuizScores AS
SELECT
   pl.PlayerName
  ,pl_ans.GameID
  ,pl_ans.SongNumber
  ,pl_ans.Year
  ,ABS(qz_ans.Year - pl_ans.Year) AS SongScore
FROM PlayerAnswers pl_ans
INNER JOIN Players pl
  ON pl.PlayerID = pl_ans.PlayerID
INNER JOIN Games gm
  ON gm.GameID = pl_ans.GameID
INNER JOIN Quizzes qz
  ON qz.QuizID = gm.QuizID
INNER JOIN QuizAnswers qz_ans
  ON qz_ans.QuizID = qz.QuizID AND qz_ans.SongNumber = pl_ans.SongNumber;

DROP PROCEDURE IF EXISTS GameState;
DELIMITER //
  CREATE PROCEDURE GameState(
     IN in_playerID INT(5)
  )
  BEGIN
    SELECT g.GameID, g.GameTitle, GROUP_CONCAT(pa.Year) as Years, q.StartYear, q.EndYear
    FROM Games g
    LEFT JOIN GameParticipations gp
    ON g.GameID = gp.GameID
    LEFT JOIN PlayerAnswers pa
    ON in_playerID = pa.PlayerID
    LEFT JOIN Quizzes q
    ON g.QuizID = q.QuizID
    WHERE gp.PlayerID = in_playerID
    GROUP BY gp.GameID, gp.PlayerID
    ORDER BY gp.JoinTime DESC
    LIMIT 1;
  END
//
DELIMITER ;

/* Gets the scores of a given round */
DROP PROCEDURE IF EXISTS RoundScore;
DELIMITER //
  CREATE PROCEDURE RoundScore(
     IN in_GameID	INT(5)
    ,IN in_SongNumber	INT(2)
  )
  BEGIN
    SELECT PlayerName, Year, SongScore
    FROM QuizScores
    WHERE GameID = in_GameID AND SongNumber = in_SongNumber
    ORDER BY PlayerName ASC;
  END
//
DELIMITER ;

/* Gets the standings up to and including a given round 
 * Only includes players that have answered all questions up until the given round.
 */
DROP PROCEDURE IF EXISTS QuizStandings;
DELIMITER //
  CREATE PROCEDURE QuizStandings (
     IN in_GameID	INT(5)
    ,IN in_SongNumber	INT(2)
  )
  BEGIN
    SELECT PlayerName, SUM(SongScore) AS TotalScore
    FROM QuizScores
    WHERE GameID = in_GameID AND SongNumber <= in_SongNumber
    GROUP BY PlayerName
    HAVING COUNT(PlayerName) >= in_SongNumber
    ORDER BY TotalScore ASC, PlayerName ASC;
  END
//
DELIMITER ;

-- Example: Scores of round 2 of GameID = 1:
CALL RoundScore(1, 2);

-- Example: Standings of GameID = 1 after round 2:
CALL QuizStandings(1, 2);
			       

SET FOREIGN_KEY_CHECKS = 1;
