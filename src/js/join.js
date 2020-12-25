function submitPin() {
    const pin = document.getElementById("pin").value;
    const data = { pin: pin };
    postData("/db/find_game.php", data)
        .then(data => handleGameResponse(data));
}

function handleGameResponse(data) {
    if (error = data.error) {
        alert(error);
    } else {
        saveGameInfo(data);
        window.location = "/game";
    }
}

function saveGameInfo(gameInfo) {
    localStorage.setItem("gameId", gameInfo.gameId);
    localStorage.setItem("startYear", gameInfo.startYear);
    localStorage.setItem("endYear", gameInfo.endYear);
}