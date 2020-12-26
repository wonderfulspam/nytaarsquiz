<?php

// Read the incoming data and parse it as JSON
$postData = json_decode(file_get_contents('php://input'), true);

$pin = $postData['pin'];
if (!$pin) {
    echo json_encode(array('error' => 'No pin specified'));
    return;
}

include_once('connection.php');

$sth = $connection->prepare($find_game_query);
$sth->execute(array($pin));
$game = $sth->fetch(PDO::FETCH_ASSOC);

if (!$game) {
    echo json_encode(array('error' => 'Game not found'));
    return;
}

// Find playerID and register their participation
$sth = $connection->prepare($get_user_id_from_token);
$sth->execute(array($_COOKIE["token"]));
$playerId = $sth->fetch()['PlayerID'];

$sth = $connection->prepare($join_game_query);
$success = $sth->execute(array($game['GameID'], $playerId));

// Tell the client all went well
if ($success) {
    echo json_encode(array('message' => 'OK'));
} else {
    echo json_encode(array('error' => 'Failed to add player to game'));
}