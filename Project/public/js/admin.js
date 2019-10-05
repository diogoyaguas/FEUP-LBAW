
function encodeForAjax(data) {
    if (data == null) return null;
    return Object.keys(data).map(function (k) {
        return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
    }).join('&');
}

function sendAjaxRequest(method, url, data, handler) {
    let request = new XMLHttpRequest();

    request.open(method, url, true);
    request.setRequestHeader('X-CSRF-TOKEN', document.querySelector('meta[name="csrf-token"]').content);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    request.addEventListener('load', handler);
    request.send(encodeForAjax(data));
}

function sendDeleteUser(userId) {

    sendAjaxRequest('delete', "/api/admin/" + userId, null, deleteHandler);
}

let review;

function sendDeleteUserReview(userId, reviewId) {

    review = reviewId;
    sendAjaxRequest('delete', "/api/admin/" + userId, null, deleteReviewHandler);
}

function sendReviewDelete(reviewId) {

    let element = document.querySelectorAll('[name="report-' + reviewId + '"]');

    element.forEach(function (e) {
        e.remove();
    })
}

function deleteHandler() {

    if (this.status != 200) {
        console.log(this.status);
        return;
    }
    let id = JSON.parse(this.responseText);
    let element = document.querySelector("#user" + id);
    element.remove();
}

function deleteReviewHandler() {

    if (this.status != 200) {
        console.log(this.status);
        return;
    }
    let id = JSON.parse(this.responseText);
    let element = document.querySelector("#user" + id);
    element.remove();

    sendAjaxRequest('delete', "/api/review/" + review, null, reviewHandler);
}

function reviewHandler() {

    if (this.status != 200) {
        console.log(this.status);
        return;
    }
    let id = JSON.parse(this.responseText);
    let element = document.querySelectorAll('[name="report-' + id + '"]');

    element.forEach(function (e) {
        e.remove();
    })
}

let submitAdd = document.querySelectorAll('#addStoreManager');
[].forEach.call(submitAdd, function (e) {
    e.addEventListener('submit', sendCreateEmployee);
})

function sendCreateEmployee(event) {

    event.preventDefault();

    let id = document.querySelector("#userId").value;
    let employeeName = event.target[0].value;
    let userPassword = event.target[1].value;

    sendAjaxRequest('post', "/api/storeManager", { employeeName: employeeName, userPassword: userPassword, idUser: id }, createHandler);
}

function createHandler() {

    if (this.status != 200) {
        console.log(this.status);
        return;
    }

    let cardRow = document.querySelector("#listEmployees");
    let html = createRow(JSON.parse (this.responseText));
    cardRow.innerHTML += html;
}

function createRow(text) {

    console.log(text);

    let div = '<div class="mt-4 col-md-6 col-lg-3" id="' + text[0] + '">';
    div += '<div class="box d-flex flex-column">';
    div += '<i class="fas fa-trash-alt ml-auto employees" onclick="sendDeleteUser(' + text[0] + '"></i>';
    div += '<div class="d-flex flex-row address-header">';
    div += '<i class="fas fa-user-tie pr-1"></i>';
    div += '<h6>' + text[1] + '</h6>';
    div += '</div><h6>Store Manager</h6></div></div>';
    return div;
}