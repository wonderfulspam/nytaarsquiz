/* Inserts og updates til test */
INSERT INTO Players (PlayerName, PlayerPassword, Token, IsAdmin) VALUES ('Chrelle', md5("pass"), "RANDOM_STRING", True), ('Emil', md5("pass"), "DIFFERENT_RANDOM_STRING", True);

INSERT INTO Quizzes (StartYear, EndYear, CreatedByPlayerID) VALUES (2019, 2020, 1);
INSERT INTO Games (GamePassword, QuizID, HostedByPlayerID) VALUES ('pass', 1, 1);

UPDATE QuizAnswers
SET Artist = 'Eminem', Title = 'Godzilla', SongNumber = 1
WHERE Year = 2020 AND QuizID = 1;

UPDATE QuizAnswers
SET Artist = 'Weyes Blood', Title = 'Andromeda', SongNumber = 2
WHERE Year = 2019 AND QuizID = 1;

/* Uncomment to prepopulate answers
INSERT INTO PlayerAnswers (GameID, PlayerID, SongNumber, Year) VALUES 
   (1, 1, 1, 1998)
  ,(1, 1, 2, 2019)
  ,(1, 2, 1, 2018)
  ,(1, 2, 2, 2017)
;
*/
