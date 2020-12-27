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

// Add player to game
$join_game_query = 'INSERT INTO GameParticipations (GameID, PlayerID) VALUES (?, ?)';

// Check if user belongs to game
$user_state_query = 'SELECT g.GameTitle FROM Games g LEFT JOIN GameParticipations gp ON g.GameID = gp.GameID WHERE gp.PlayerID = ? ORDER BY gp.JoinTime DESC LIMIT 1';

// Load game state for user
$game_state_query = 'CALL GameState(?)';

// Store single answer
$store_answer_query = 'INSERT INTO PlayerAnswers (GameId, PlayerID, SongNumber, Year) VALUES (?, ?, ?, ?)';

// Show round score for $GameID, $Round
$round_score_query = 'CALL RoundScore(?, ?)';

// Show overall game score for $GameID, after $Round
$game_score_query = 'CALL QuizStandings(?, ?)';