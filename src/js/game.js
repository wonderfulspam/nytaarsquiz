var PLAYER_ID;
var GAME_ID;
var START_YEAR;
var END_YEAR;

document.addEventListener("DOMContentLoaded", function () {
    getGameInfo();
    createTable();
    addButtonHandlers();
    setButtonState();
});

function getGameInfo() {
    PLAYER_ID = localStorage.getItem("playerId");
    GAME_ID = localStorage.getItem("gameId");
    START_YEAR = localStorage.getItem("startYear");
    END_YEAR = localStorage.getItem("endYear");
}

function createTable() {
    const table = document.getElementById("years");
    for (var i = START_YEAR; i <= END_YEAR; i++) {
        let button = document.createElement("button");
        button.textContent = i.toString();
        table.appendChild(button);
    }
}

function addButtonHandlers() {
    const table = document.getElementById("years");
    table.addEventListener("click", function (event) {
        // Click handler is on the whole <div> so make sure we clicked a button which is not disabled
        if (event.target.tagName !== "BUTTON" || event.target.classList.contains("disabled")) return;
        let year = event.target.textContent;
        event.target.classList.add("disabled");
        registerChoice(year);
        checkIfDone();
    });

    /*
    const submitButton = document.getElementById("showResults");
    submitButton.addEventListener("click", function () {
        window.location = "/results";
    })
    */
}

function registerChoice(year) {
    const answerNumber = document.querySelectorAll("button.disabled").length;
    const data = {
        playerId: PLAYER_ID,
        gameId: GAME_ID,
        songNumber: answerNumber,
        year: year
    }
    postData("/db/store_answer.php", data)
        .then(data => handleResponse(data));
}

function handleResponse(data) {
    if (error = data.error) {
        alert(error);
    }
}

// Append answer to list of answers and save state
function _registerChoiceLocal(year) {
    let answers = JSON.parse(localStorage.getItem("answers") || "[]");
    answers.push(year);
    localStorage.setItem("answers", JSON.stringify(answers));
}

function checkIfDone() {
    let count = document.querySelectorAll("button.disabled").length;
    if (count >= (END_YEAR - START_YEAR + 1)) {
        document.getElementById("years").classList.toggle("invisible");
        // document.getElementById("submit").classList.remove("invisible");
    } else {
        document.getElementById("song_number_text").textContent = count + 1;
    }
}

// Set button state from localstorage (ie. previous visits)
function setButtonState() {
    let answers = JSON.parse(localStorage.getItem("answers") || "[]"); // Load state
    if (answers.length >= (END_YEAR - START_YEAR + 1)) { // If we're in a done state, reset everything
        localStorage.setItem("answers", "[]");
        return;
    }
    Array.from(document.querySelectorAll("button")) // Create array of all button elements
        .filter(button => answers.includes(button.textContent)) // Filter by ones whose year exist in answers
        .forEach(button => button.classList.toggle("disabled")); // Set class on all of them
    document.getElementById("song_number_text").textContent = answers.length + 1; // Set current guess no.
}