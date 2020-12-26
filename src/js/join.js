document.addEventListener("DOMContentLoaded", function () {
    addEnterHandler(document.getElementById("pin"), document.getElementById("verify"));
});

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
        window.location = "/game";
    }
}
