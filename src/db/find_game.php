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
} else {
    $res = array(
        'gameId' => $game['GameID'],
        'startYear' => $game['StartYear'],
        'endYear' => $game['EndYear']
    );
    echo json_encode($res);
}