<?php
include_once('../db/auth_check.php');
?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="/style.css">
    <script type="text/javascript" src="/js/common.js"></script>
    <script type="text/javascript" src="/js/join.js"></script>
</head>

<body>
    <div id="main">
        <input type="password" class="half-width" id="pin" placeholder="Kode" />
        <button class="half-width" id="verify" onclick="submitPin()">Deltag</button>
    </div>
</body>

</html>