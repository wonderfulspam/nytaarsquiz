var GAME_INFO;

document.addEventListener("DOMContentLoaded", function () {
    getGameInfo();
    createTable();
    addButtonHandlers();
    setButtonState();
});

function getGameInfo() {
    GAME_INFO = JSON.parse(document.getElementById("game_state").innerHTML);
}

function createTable() {
    const table = document.getElementById("years");
    for (var i = GAME_INFO.StartYear; i <= GAME_INFO.EndYear; i++) {
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
        let success = registerChoice(year);
        if (success) {
            event.target.classList.add("disabled");
            checkIfDone();
        }
    });

    /*
    const submitButton = document.getElementById("showResults");
    submitButton.addEventListener("click", function () {
        window.location = "/results";
    })
    */
}

async function registerChoice(year) {
    // Elem is disabled _after_ submit, so we correct off-by-one error
    const answerNumber = document.querySelectorAll("button.disabled").length + 1;
    const data = {
        gameId: GAME_INFO.GameID,
        songNumber: answerNumber,
        year: year
    }
    return await postData("/api/store_answer.php", data)
        .then(data => handleResponse(data));
}

function handleResponse(data) {
    if (error = data.error) {
        alert(error);
        return false;
    }
    return true;
}

function checkIfDone() {
    let count = document.querySelectorAll("button.disabled").length;
    if (count >= (GAME_INFO.EndYear - GAME_INFO.StartYear + 1)) {
        document.getElementById("years").classList.toggle("invisible");
        // document.getElementById("submit").classList.remove("invisible");
    } else {
        document.getElementById("song_number_text").textContent = count + 1;
    }
}

// Set button state from localstorage (ie. previous visits)
function setButtonState() {
    let answers = GAME_INFO.Years;
    if (answers) {
        answers = answers.split(","); // Load state
    } else {
        answers = [];
    }
    Array.from(document.querySelectorAll("button")) // Create array of all button elements
        .filter(button => answers.includes(button.textContent)) // Filter by ones whose year exist in answers
        .forEach(button => button.classList.toggle("disabled")); // Set class on all of them

    const songNumberElement = document.getElementById("song_number_text");
    if (answers.length >= (GAME_INFO.EndYear - GAME_INFO.StartYear + 1)) {
        songNumberElement.textContent = "";
    } else {
        songNumberElement.textContent = answers.length + 1; // Set current guess no.
    }
}