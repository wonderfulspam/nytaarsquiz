/* Inserts og updates til test */
INSERT INTO Players (PlayerName, PlayerPassword, Token, IsAdmin) VALUES 
    ('Chrelle', md5("pass"), "RANDOM_STRING", True)
   ,('Emil', md5("pass"), "DIFFERENT_RANDOM_STRING", True);

INSERT INTO Quizzes (StartYear, EndYear, CreatedByPlayerID) VALUES 
   (2014, 2020, 1);
   
INSERT INTO Games (GamePassword, GameTitle, QuizID, HostedByPlayerID) VALUES 
   ('gudbevaredanmark', "Chrelles nytår 2021", 1, 1);

CREATE TEMPORARY TABLE QuizAnswersTemp (Year INT(4), Artist VARCHAR(50), Title VARCHAR(50), SongNumber INT(2));
INSERT INTO QuizAnswersTemp VALUES
    (2014, 'Angel Olsen', 'White Fire', 2)
   ,(2015, 'Joanna Newsom', 'You Will Not Take My Heart Alive', 3)
   ,(2016, 'Solange', 'Cranes in the Sky', 1)
   ,(2017, 'Lorde', 'Homemade Dynamite', 7)
   ,(2018, 'Mitski', 'Two Slow Dancers', 4)
   ,(2019, 'Lana Del Rey', 'The Greatest', 6)
   ,(2020, 'Adrianne Lenker', 'Anything', 5);

UPDATE QuizAnswers qa
INNER JOIN QuizAnswersTemp temp
  ON  qa.QuizID = 1 AND qa.Year = temp.Year
SET 
   qa.Artist = temp.Artist
  ,qa.Title = temp.Title
  ,qa.SongNumber = temp.SongNumber;
