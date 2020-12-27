<?php

// Declare necessary variables in advance
$db_host = $db_user = $db_password = $db_name = '';
$db_type = 'mysql';

// If ENV is provided, load db credentials from there
if ($_ENV['DB_HOST']) {
    $db_host = $_ENV['DB_HOST'];
    $db_user = $_ENV["MYSQL_USER"];
    $db_password = $_ENV["MYSQL_PASSWORD"];
    $db_name = $_ENV["MYSQL_DATABASE"];
// Otherwise look for file on server
} else {
    include_once('db_credentials.php');
    /* Example content:
    $db_host = 'localhost';
    $db_user = 'dbuser';
    $db_password = 'dbpassword';
    $db_name = 'quizdb';
    */
}

$connection = new PDO("$db_type:host=$db_host;dbname=$db_name", $db_user, $db_password);

// Load prepared statements
include_once('queries.php');