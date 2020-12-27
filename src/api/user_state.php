<?php

include_once('connection.php');

$sth = $connection->prepare($get_user_id_from_token);
$sth->execute(array($_COOKIE["token"]));
$playerId = $sth->fetch()['PlayerID'];

if (!$playerId) {
    echo json_encode(array('game' => null));
    return;
}

$sth = $connection->prepare($user_state_query);
$sth->execute(array($playerId));
$gameTitle = $sth->fetch()['GameTitle'];

if (!$gameTitle) {
    echo json_encode(array('game' => null));
    return;
}

echo json_encode(array('game' => $gameTitle));