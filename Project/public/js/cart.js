let itemCheckers = document.querySelectorAll('i.fas.fa-trash-alt.ml-auto');
[].forEach.call(itemCheckers, function (checker) {
    checker.addEventListener('click', sendDeleteLine);
});

function sendDeleteLine(event) {
    let line = event.target.getAttribute('value').split("-");
    let idLine = line[0];
    let priceLine = line[1];
    sendAjaxRequest('delete', "/api/line/" + idLine, { idLine: idLine, price: priceLine }, lineDeletedHandler);
}

function lineDeletedHandler() {
    if (this.status != 200) {
        console.log(this.status);
        return;
    }
    let line = JSON.parse(this.responseText);
    let element = document.querySelector("#line" + line['idLine']);
    let total = document.querySelector(".justify-content-right.total").innerHTML.split(" ");
    total[0] -= line['price'];
    let finalTotal = total[0];
    document.querySelector(".justify-content-right.total").innerHTML = finalTotal.toFixed(2) + " €";
    let discount = total[0]*0.7;
    document.querySelector(".justify-content-right.newTotal").innerHTML = discount.toFixed(2) + " €";
    element.remove();
}

let invoiceAddress;
let idUser;
let newLines = [];
let total;
let street;
let city;
let zipCode;
let country;
let type_address;
let door_number;
let streetS;
let cityS;
let zipCodeS;
let countryS;
let door_numberS;

function completePurchase(lines, t) {

    for (i = 0; i < lines.length; i++) {
        newLines[i] = lines[i].id;
    }

    if (!checkFields()) {
        return false;
    }

    total = t;
    idUser = document.querySelector('#userId').value;
    street = document.querySelector('#iStreet').value;
    city = document.querySelector('#iCity').value;
    zipCode = document.querySelector('#iZip').value;
    country = document.querySelector('#iCountry').value;
    type_address = 'other';
    door_number = document.querySelector('#iDoor').value;

    if (document.querySelector('#shippingAddress').getAttribute('aria-expanded') == 'true') {

        streetS = document.querySelector('#sStreet').value;
        cityS = document.querySelector('#sCity').value;
        zipCodeS = document.querySelector('#sZip').value;
        countryS = document.querySelector('#sCountry').value;
        door_numberS = document.querySelector('#sDoor').value;

        if(streetS == '' || city == '' || zipCodeS == '' || country == '' || door_numberS == '') return false;

        sendAjaxRequest('post', "/api/profile/" + idUser + "/address", { type_address: type_address, country: country, city: city, zipCode: zipCode, street: street, door_number: door_number }, shippingCreateHandler)

    }

    sendAjaxRequest('post', "/api/profile/" + idUser + "/address", { type_address: type_address, country: country, city: city, zipCode: zipCode, street: street, door_number: door_number }, orderHandler);
}

function shippingCreateHandler() {

    if (this.status != 200) {
        console.log(this.status);
        return;
    }

    let addr = JSON.parse(this.responseText);

    invoiceAddress = addr[0].id;

    sendAjaxRequest('post', "/api/profile/" + idUser + "/address", { type_address: type_address, country: countryS, city: cityS, zipCode: zipCodeS, street: streetS, door_number: door_numberS }, orderHandler);

}

function orderHandler() {
    if (this.status != 200) {
        console.log(this.status);
        return;
    }

    let addressId;
    let addr = JSON.parse(this.responseText);

    if (invoiceAddress == null) {
        invoiceAddress = addr[0].id;
        addressId = null;
    } else
        addressId = addr[0].id;

    sendAjaxRequest('post', "/api/order", { idUser: idUser, lines: newLines, total: total, invoiceAddress: invoiceAddress, addressId: addressId }, finaldHandler);
}

function finaldHandler() {
    if (this.status != 200) {
        console.log(this.status);
        return;
    }

    window.location.href = "/profile";
}

function checkFields() {

    let fn = document.querySelector('#iName').value;
    let ln = document.querySelector('#iLast').value;
    let em = document.querySelector('#iEmail').value;
    let s = document.querySelector('#iStreet').value;
    let ct = document.querySelector('#iCity').value;
    let z = document.querySelector('#iZip').value;
    let c = document.querySelector('#iCountry').value;
    let d = document.querySelector('#iDoor').value;
    let card = document.querySelector('#cardNumber').value;
    let exp = document.querySelector('#expDate').value;
    let ccv = document.querySelector('#ccv').value;

    if (fn == '' || ln == '' || em == '' || s == '' || ct == '' || z == '' || c == '' || d == '' || card == '' || exp == '' || ccv == '' || newLines.length == 0) return false;
    else return true;
}

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