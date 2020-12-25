<?php

$postData = json_decode(file_get_contents('php://input'), true);

include_once('connection.php');

$sth = $connection->prepare($get_user_id_from_token);
$sth->execute(array($_COOKIE["token"]));
$userId = $sth->fetch()['PlayerID'];

$sth = $connection->prepare($store_answer_query);
$sth->execute(array(
    $postData['gameId'],
    $userId,
    $postData['songNumber'],
    $postData['year'],
));

echo json_encode(array('message' => 'OK'));
