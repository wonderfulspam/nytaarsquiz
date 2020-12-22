const START_YEAR = 1999;
const END_YEAR = 2010;

document.addEventListener("DOMContentLoaded", function () {
    createTable();
    addButtonHandler();
    setButtonState();
});

function createTable() {
    const table = document.getElementById("years");
    for (var i = START_YEAR; i <= END_YEAR; i++) {
        let button = document.createElement("button");
        button.textContent = i.toString();
        table.appendChild(button);
    }
}

function addButtonHandler() {
    const table = document.getElementById("years");
    table.addEventListener("click", function (event) {
        // Click handler is on the whole <div> so make sure we clicked a button which is not disabled
        if (event.target.tagName !== "BUTTON" || event.target.classList.contains("disabled")) return;
        let year = event.target.textContent;
        event.target.classList.add("disabled");
        registerChoice(year);
        checkIfDone();
    });
}

// Append answer to list of answers and save state
function registerChoice(year) {
    let answers = JSON.parse(localStorage.getItem("answers") || "[]");
    answers.push(year);
    localStorage.setItem("answers", JSON.stringify(answers));
}

function checkIfDone() {
    let count = document.querySelectorAll("button.disabled").length;
    if (count >= (END_YEAR - START_YEAR + 1)) {
        document.getElementById("years").classList.toggle("invisible");
        document.getElementById("submit").classList.remove("invisible");
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