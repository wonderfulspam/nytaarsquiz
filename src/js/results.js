var SCORE_DATA;

document.addEventListener("DOMContentLoaded", function () {
    SCORE_DATA = await loadResults();
    createDOM();
    addButtonHandlers();
    setButtonState();
});

async function loadResults() {
    return postData("/api/scores.php").then(data => { return data });
}

function createDOM() {
    // TODO
}

function addButtonHandlers() {
    // TODO
}

function setButtonState() {
    // TODO
}