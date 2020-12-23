DROP TABLE IF EXISTS Players;
CREATE TABLE Players (
   PlayerID		INT(5)		NOT NULL	AUTO_INCREMENT
  ,PlayerName		VARCHAR(50)	NOT NULL	UNIQUE
  ,PlayerPassword	VARCHAR(50)	NOT NULL	
  ,PRIMARY KEY(PlayerID)
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS Games;
CREATE TABLE IF NOT EXISTS Games (
   GameID		INT(5)		NOT NULL	AUTO_INCREMENT
  ,GamePassword 	VARCHAR(20)	NOT NULL
  ,StartYear		INT(4)		NOT NULL
  ,EndYear		INT(4)		NOT NULL
  ,CreatedByPlayerID	INT(5)		NOT NULL
  ,PRIMARY KEY(GameID)
)
ENGINE = InnoDB;

/* Evt ny tabel: QuizAnswers, der mapper Quiz->Game */

DROP TABLE IF EXISTS GameAnswers;
CREATE TABLE IF NOT EXISTS GameAnswers (
   GameID	INT(5)		NOT NULL
  ,Year		INT(4)		NULL		
  ,SongNumber	INT(2)		NULL		
  ,Artist	VARCHAR(100)	NULL
  ,Title	VARCHAR(100)	NULL
)
ENGINE = InnoDB;

DROP TABLE IF EXISTS PlayerAnswers;
CREATE TABLE IF NOT EXISTS PlayerAnswers (
   GameID	INT(5)	NOT NULL
  ,PlayerID	INT(5)	NOT NULL
  ,SongNumber	INT(2)	NOT NULL
  ,Year		INT(4)	NOT NULL	
)
ENGINE = InnoDB;

CREATE OR REPLACE VIEW generator_16
AS SELECT 0 n UNION ALL SELECT 1  UNION ALL SELECT 2  UNION ALL 
   SELECT 3   UNION ALL SELECT 4  UNION ALL SELECT 5  UNION ALL
   SELECT 6   UNION ALL SELECT 7  UNION ALL SELECT 8  UNION ALL
   SELECT 9   UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
   SELECT 12  UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL 
   SELECT 15;

CREATE OR REPLACE VIEW TallyTable
AS SELECT ( ( hi.n << 4 ) | lo.n ) AS n
FROM generator_16 lo, generator_16 hi
WHERE ( ( hi.n << 4 ) | lo.n ) BETWEEN 0 AND 99;

DROP PROCEDURE IF EXISTS PrepareGameAnswers;
DELIMITER //
  CREATE PROCEDURE PrepareGameAnswers(
    IN in_GameID	INT(5)
  )
  BEGIN
    DELETE FROM GameAnswers WHERE GameID = in_GameID;
    
    SET @StartYear = (SELECT MAX(StartYear) FROM Games WHERE GameID = in_GameID);
    SET @NumberOfYears = (SELECT MAX(EndYear) - MAX(StartYear) + 1 FROM Games WHERE GameID = in_GameID);

    INSERT INTO GameAnswers (GameID, Year)
    SELECT 1 AS GameID, n + @StartYear	AS Year
    FROM TallyTable
    WHERE n < @NumberOfYears;

  END
//
DELIMITER ;

DELIMITER //
  CREATE TRIGGER after_game_update
  AFTER INSERT ON Games FOR EACH ROW
  BEGIN
    CALL PrepareGameAnswers(NEW.GameID);
  END
//
DELIMITER ;

/* View til resultater runde for runde med stilling for runden og samlet stilling til og med den givne runde.
CREATE OR REPLACE VIEW GameResults
AS
SELECT 
	 gm_ans.GameID
	,gm_ans.SongNumber
	,
FROM GameAnswers gm_ans
INNER JOIN PlayerAnswers pl_ans;
*/