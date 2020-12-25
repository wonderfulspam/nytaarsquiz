<?php

// Authorize access based on cookie
$auth_query = 'SELECT 1 from Players where Token = ?';

// Authorize admin access based on cookie
$admin_auth_query = 'SELECT 1 from Players where Token = ? and IsAdmin = 1';

// Check if username already exists
$check_user_exists_query = 'SELECT 1 from Players where PlayerName = ?';

// Get UserID from token stored in cookie
$get_user_id_from_token = 'SELECT PlayerID from Players where Token = ?';

// Create user (not linked to any game)
$create_user_query = 'INSERT INTO Players (PlayerName, PlayerPassword, Token) VALUES (?, ?, ?)';

// Log user in
$login_query = 'SELECT Token from Players where PlayerName = ? and PlayerPassword = ?';

// Look up game by password
$find_game_query = 'SELECT q.StartYear, q.EndYear, g.GameID from Games g LEFT JOIN Quizzes q ON g.QuizID = q.QuizID where g.GamePassword = ?';

// Store single answer
$store_answer_query = 'INSERT INTO PlayerAnswers (GameId, PlayerID, SongNumber, Year) VALUES (?, ?, ?, ?)';