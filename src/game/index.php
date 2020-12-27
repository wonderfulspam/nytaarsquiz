<?php
include_once('../api/auth_check.php');
include_once('../api/initialize_game_state.php');
?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="/style.css">
    <script type="text/javascript" src="/js/common.js"></script>
    <script type="text/javascript" src="/js/game.js"></script>
    <title><?php echo $game_state['GameTitle']; ?></title>
</head>

<body>
    <div class="sticky">
        <table>
            <tr>
                <td style="text-align:right">
                    <p>JERES GÆT PÅ SANG NR:</p>
                </td>
                <td style="text-align:center">
                    <h1 id="song_number_text"></h1>
                </td>
            </tr>
        </table>
    </div>
    <div id="years">
    </div>
    <div id="game_state" style="display:none;"><?php echo json_encode($game_state) ?></div>
</body>

</html>