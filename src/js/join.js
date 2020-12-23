function submitPin() {
    const pin = document.getElementById("pin").value;
    const data = { pin: pin };
    fetch("/db/join_game.php", {
        method: "POST",
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    }).then(res => res.text())
        .then(data => console.log(data))
}