<?php

// Read the incoming data and parse it as JSON
$postData = json_decode(file_get_contents('php://input'), true);

$pin = $postData['pin'];
if (!$pin) {
    return json_encode(array('error' => 'No pin specified'));
}

include_once('connection.php');

$sth = $connection->prepare('SELECT GameID from Games where GamePassword = ?');
$sth->execute(array($pin));
$game = $sth->fetch();

if (!$game) {
    echo json_encode(array('error' => 'Game not found'));
} else {
    echo json_encode(array('game' => $game['GameID']));
}