<?php

// Read the incoming data and parse it as JSON
$postData = json_decode(file_get_contents('php://input'), true);

$name = $postData['name'];
if (!$name) {
    echo json_encode(array('error' => 'No name specified'));
    return;
}

include_once('connection.php');

// Check if user with given name already exists
$sth = $connection->prepare($check_user_exists_query);
$sth->execute(array($name));
$existing_player = $sth->fetch();
if ($existing_player) {
    echo json_encode(array('error' => 'Username already exists'));
    return;
}

// If we made it this far, we can go ahead and join
$sth = $connection->prepare($join_query);
$sth->execute(array($name));
$player = $sth->fetch(PDO::FETCH_ASSOC);

if (!$player) {
    echo json_encode(array('error' => 'Failed to add player'));
} else {
    $res = array(
        'playerId' => $game['PlayerID'],
        'playerName' => $name
    );
    echo json_encode($res);
}