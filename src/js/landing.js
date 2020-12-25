document.addEventListener("DOMContentLoaded", function () {
    addButtonHandlers();
});

function addButtonHandlers() {
    const createButton = document.getElementById("create");
    const joinButton = document.getElementById("join");

    createButton.addEventListener("click", function () {
        alert("Ikke implementeret endnu");
    });

    joinButton.addEventListener("click", function () {
        window.location = "/join";
    })
}
