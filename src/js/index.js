var LOGIN_OR_CREATE = "";

document.addEventListener("DOMContentLoaded", function () {
    if (getCookie("token") !== null) {
        window.location = "/landing";
    }
    addButtonHandlers();
});

function addButtonHandlers() {
    const loginButton = document.getElementById("login");
    const signupButton = document.getElementById("signup");

    loginButton.addEventListener("click", function () {
        LOGIN_OR_CREATE = "login";
        showNameInput();
    });

    signupButton.addEventListener("click", function () {
        LOGIN_OR_CREATE = "create";
        showNameInput();
    });

    addEnterHandler(document.getElementById("password"), document.getElementById("submit"));
}

function showNameInput() {
    document.getElementById("login").classList.toggle("invisible");
    document.getElementById("signup").classList.toggle("invisible");
    document.getElementById("username").classList.remove("invisible");
    document.getElementById("password").classList.remove("invisible");
    document.getElementById("submit").classList.remove("invisible");
}

function loginOrCreate() {
    let username = document.getElementById("username").value;
    let password = document.getElementById("password").value;
    password = md5(password);
    console.log(password);
    postData("/api/login_or_create.php", { username: username, password: password, action: LOGIN_OR_CREATE })
        .then(data => handleResponse(data));
}

function handleResponse(data) {
    if (error = data.error) {
        alert(error);
        return;
    }
    let token = data.token;
    setCookie("token", token, 365);
    window.location = "/landing";
}