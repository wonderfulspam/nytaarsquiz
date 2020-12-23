/* Inserts og updates til test */
INSERT INTO Games (GamePassword, StartYear, EndYear, CreatedByPlayerID) VALUES ('pass', 2019, 2020, 1);

UPDATE GameAnswers
SET Artist = 'Eminem', Title = 'Godzilla', SongNumber = 1
WHERE Year = 2020;

UPDATE GameAnswers
SET Artist = 'Weyes Blood', Title = 'Andromeda', SongNumber = 2
WHERE Year = 2019;

INSERT INTO Players (PlayerName, PlayerPassword) VALUES ('Chrelle', 'pass'), ('Emil', 'pass');

INSERT INTO PlayerAnswers (GameID, PlayerID, SongNumber, Year) VALUES 
   (1, 1, 1, 1998)
  ,(1, 1, 2, 2019)
  ,(1, 2, 1, 2018)
  ,(1, 2, 2, 2017)
;

