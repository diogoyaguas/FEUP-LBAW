let itemCheckers = document.querySelectorAll('i.fas.fa-trash-alt.ml-auto.addr');
[].forEach.call(itemCheckers, function (checker) {
  checker.addEventListener('click', sendDeleteAddress);
});

let submitAddress = document.querySelectorAll('#newAddress');
[].forEach.call(submitAddress, function (form) {
  form.addEventListener('submit', sendCreateAddress);
})

let faves = document.getElementsByClassName("fas fa-heart ml-auto");
[].forEach.call(faves, function (elem) {
  elem.addEventListener('click', sendRemoveFav);
});

let infoChange = document.getElementById('alterInfoUser');
infoChange.addEventListener('submit', sendUpdatePersonalInfo);

let del = document.querySelector('.col-lg-auto.col-md-auto.col-sm-12.text-sm-right')
del.addEventListener('click', () => { sendAjaxRequest('delete', '/profile/delete', null, handlerDel) })

function handlerDel() {

  if (this.status != 200) {
    console.log('merdou')
    return;
  }

  let ans = JSON.parse(this.responseText)
  window.location.replace('homepage');

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

function sendDeleteAddress(event) {
  let idAddr = event.target.getAttribute('value');
  sendAjaxRequest('delete', "/api/address/" + idAddr, null, addressDeletedHandler);
}

function addressDeletedHandler() {
  if (this.status != 200) {
    console.log(this.status);
    return;
  }
  let item = JSON.parse(this.responseText);
  let element = document.querySelector("#address-" + item['id']);
  element.remove();
}

function sendCreateAddress(event) {
  event.preventDefault();
  let id = document.querySelector("#userId").value;

  let city = event.target[4].value;
  let street = event.target[2].value;
  let zipCode = event.target[3].value;
  let type_address = event.target[0].value.toLowerCase();
  let country = event.target[5].value;
  let door_number = event.target[1].value;




  sendAjaxRequest('post', "/api/profile" + "/address", { type_address: type_address, country: country, city: city, zipCode: zipCode, street: street, door_number: door_number }, addressCreateHandler)

}

function addressCreateHandler() {
  if (this.status != 200) {
    console.log(this.status);
  }

  clearFormAddress();
  let addr = JSON.parse(this.responseText);

  let obj = document.querySelector('#addresses_title').parentElement;

  let innerHTML = createAddress(addr);
  obj.children[1].innerHTML += innerHTML;

  let itemCheckers = document.querySelectorAll('i.fas.fa-trash-alt.ml-auto.addr');

  [].forEach.call(itemCheckers, function (checker) {
    checker.addEventListener('click', sendDeleteAddress);
  });

}

function clearFormAddress() {
  let form = document.getElementById('newAddress')
  form.reset();
  $('#addAddressModal').modal('hide')
  $('.modal-backdrop').remove();
  $('body').removeClass('modal-open');
}

function createAddress(addr) {
  let div = '<div class="mt-2 col-md-6 col-lg-3" id="address-' + addr[0]['id'] + '">';
  div += '<div class="box d-flex flex-column"> <i class="fas fa-trash-alt ml-auto addr" value="' + addr[0]['id'] + '"></i>'

  div += '<div class="d-flex flex-row address-header">';

  if (addr[0]['type_address'] == 'home') {
    div += '<i class="fas fa-home pr-1"></i><h6>Home</h6>';
  } else if (addr['type_address'] == 'work') {
    div += '<i class="fas fa-briefcase pr-1"></i><h6>Work</h6>';
  } else {
    div += '<i class="fab fa-bandcamp pr-1"></i><h6>Other</h6>';
  }


  div += '</div> <h6> ' + addr[0]['door_number'] + " " + addr[0]['street'] + ", " + addr[0]['zipcode'] + " " + addr[1] + " - " + addr[2] + ' </h6></div></div>'

  return div;
}


function sendRemoveFav(event) {
  let id = document.querySelector("#userId").value;
  let helper = event.target.parentElement.parentElement;
  let idProduct = helper.getAttribute('id').split('-')[1];

  sendAjaxRequest('delete', "/api/profile/products/" + idProduct, null, removeFavHandler);
}

function removeFavHandler() {
  if (this.status != 200) {
    console.log("implementa tudo");
  }

  let info = JSON.parse(this.responseText);
  if (info === 0) return;
  removeCard(info);
}

function removeCard(id) {
  let i = document.getElementById("favorite-" + id)
  i.remove();

}


function sendUpdatePersonalInfo(event) {
  event.preventDefault();


  Array.from(event.target.firstElementChild.children).forEach(element => {
    if (element.children[2] != undefined) element.children[2].remove();
  });

  let name = event.target[0].value;
  let username = event.target[1].value;
  let email = event.target[2].value;
  let password = event.target[3].value;
  let newpassword = event.target[4].value;


  if (!checkParams({ name: name, username: username, email: email, password: password })) return;

  sendAjaxRequest('put', '/api/profile', { name: name, username: username, email: email, password: password, newpassword: newpassword }, changeInfoHandler)
}


function checkParams(obj) {

  let trueable = {}

  for (let item in obj) {

    if (obj[item] == "") {
      let span = document.createElement('span')
      span.innerHTML = item + " can't be empty";
      document.getElementById('edit-' + item).after(span)
      trueable.item = item;
    }
  }


  return Object.entries(trueable).length === 0 && trueable.constructor === Object
}


function changeInfoHandler() {
  if (this.status != 200) {
    console.log(this);
    let answer = JSON.parse(this.responseText);
    console.log(answer)
    return;
  }

  let answer = JSON.parse(this.responseText);

  if (answer['errors'] != undefined) {

    for (let a in answer['errors']) {
      document.getElementById('edit-' + a).after(document.createElement('span').appendChild(document.createTextNode(answer['errors'][a][0])))

    }

    return
  }

  document.getElementById('alterInfoUser').reset();

  document.getElementById('profile_username').childNodes[0].nodeValue = answer['username'];
  document.getElementById('profile_name').childNodes[0].nodeValue = answer['name'];
  document.getElementById('profile_email').childNodes[0].nodeValue = answer['email'];

  $('#alterInformationModal').modal('hide');
  $('.modal-backdrop').remove();
  $('body').removeClass('modal-open');
}