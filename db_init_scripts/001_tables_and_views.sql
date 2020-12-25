SET FOREIGN_KEY_CHECKS = 0;

/* Creates the table to be populated with players. Player names must be unique.
 * PlayerID is used when submitting scores and for generating scoreboards.
 */
DROP TABLE IF EXISTS Players;
CREATE TABLE Players (
   PlayerID		INT(5)		NOT NULL	AUTO_INCREMENT
  ,PlayerName		VARCHAR(50)	NOT NULL	UNIQUE
  ,PlayerPassword	VARCHAR(50)	NOT NULL	
  ,Token VARCHAR(50) NOT NULL UNIQUE
  ,IsAdmin Boolean DEFAULT FALSE
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
  ,GamePassword 	VARCHAR(20)	NOT NULL
  ,QuizID		INT(5)		NOT NULL
  ,HostedByPlayerID	INT(5)		NOT NULL
  ,PRIMARY KEY(GameID)
  ,FOREIGN KEY(HostedByPlayerID) REFERENCES Players(PlayerID)
  ,FOREIGN KEY(QuizID) REFERENCES Quizzes(QuizID)
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

DELIMITER //
  CREATE TRIGGER after_quiz_update
  AFTER INSERT ON Quizzes FOR EACH ROW
  BEGIN
    CALL PrepareQuizAnswers(NEW.QuizID);
  END
//
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

/* View til resultater runde for runde med stilling for runden og samlet stilling til og med den givne runde.
CREATE OR REPLACE VIEW GameResults
AS
SELECT 
	 gm_ans.GameID
	,gm_ans.SongNumber
	,
FROM QuizAnswers gm_ans
INNER JOIN PlayerAnswers pl_ans;
*/
