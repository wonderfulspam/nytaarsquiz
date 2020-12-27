<?php

// If no token present, redirect to front page
if (!isset($_COOKIE['token'])) {
    header('Location: /');
    return;
}

$token = $_COOKIE['token'];
include_once('connection.php');

$sth = $connection->prepare($auth_query);
$success = $sth->execute(array($token));
if (!$success) {
    error_log("Failed to match token");
    // We got a token, but the token doesn't match anyone we know
    // Blank the cookie and return to front page
    setcookie("token", "", time() - 3600, '/');
    header('Location: /');
    return;
}
