<?php

$sth = $connection->prepare($get_user_id_from_token);
$sth->execute(array($_COOKIE["token"]));
$playerId = $sth->fetch()['PlayerID'];

$sth = $connection->prepare($game_state_query);
$sth->execute(array($playerId));
$game_state = $sth->fetch(PDO::FETCH_ASSOC);