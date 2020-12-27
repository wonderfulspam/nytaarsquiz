<?php

// Read the incoming data and parse it as JSON
$postData = json_decode(file_get_contents('php://input'), true);

$username = $postData['username'];
if (!$username) {
    echo json_encode(array('error' => 'No name specified'));
    return;
}

$password = $postData['password'];
if (!$password) {
    echo json_encode(array('error' => 'No password specified'));
    return;
}

$action = $postData['action'];
if ($action == 'create') {
    createUser($username, $password);
} else if ($action == 'login') {
    login($username, $password);
} else {
    echo json_encode(array('error' => 'Action not supported'));
}

function createUser($username, $password) {
    include_once('connection.php');

    // Check if user with given name already exists
    $sth = $connection->prepare($check_user_exists_query);
    $sth->execute(array($username));
    $existing_player = $sth->fetch();
    if ($existing_player) {
        echo json_encode(array('error' => 'Username already exists'));
        return;
    }

    // Generate a random token to associate with the player
    $token = bin2hex(random_bytes(16));

    // If we made it this far, we can go ahead and create the user
    $sth = $connection->prepare($create_user_query);
    $success = $sth->execute(array($username, $password, $token));

    if (!$success) {
        echo json_encode(array('error' => 'Failed to add player'));
    } else {
        $res = array(
            'playerName' => $username,
            'token' => $token
        );
        echo json_encode($res);
    }
}

function login($username, $password) {
    include_once('connection.php');

    $sth = $connection->prepare($login_query);
    $retval = $sth->execute(array($username, $password));
    $user = $sth->fetch(PDO::FETCH_ASSOC);

    error_log(json_encode(array($login_query, $username, $password, $retval, $user)));
    $token = $user['Token'];
    if (!$token) {
        echo json_encode(array('error' => 'Failed to log in'));
    } else {
        $res = array(
            'playerName' => $username,
            'token' => $token
        );
        echo json_encode($res);
    }
}