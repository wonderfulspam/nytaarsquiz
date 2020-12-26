var USER_STATE;

document.addEventListener("DOMContentLoaded", async function () {
    await loadUserState();
    addButtonHandlers();
});

async function loadUserState() {
    await postData("/db/user_state.php", {}).then(data => USER_STATE = data);
}

function addButtonHandlers() {
    const createButton = document.getElementById("create");
    const joinButton = document.getElementById("join");
    const rejoinButton = document.getElementById("rejoin");

    if (USER_STATE.game) {
        rejoinButton.addEventListener("click", function () {
            window.location = "/game";
        });
    } else {
        rejoinButton.classList.add("disabled");
    }

    createButton.addEventListener("click", function () {
        alert("Ikke implementeret endnu");
    });

    joinButton.addEventListener("click", function () {
        window.location = "/join";
    })
}
