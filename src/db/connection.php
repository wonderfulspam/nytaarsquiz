<?php

$db_host = "db";
$db_user = $_ENV["MYSQL_USER"];
$db_password = $_ENV["MYSQL_PASSWORD"];
$db_name = $_ENV["MYSQL_DATABASE"];

$connection = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_password);