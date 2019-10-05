
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



let checkin = document.getElementById('addProduct');
checkin.addEventListener('submit', checkElems);

function checkElems(event) {


  let images = document.getElementById('img');
  console.log(images.files.length);

  if (images.files.length != 3) {
    console.log(images.parentElement);
    if (images.parentElement.children[4]) {
      images.parentElement.children[4].remove()
      images.parentElement.children[3].remove()

    }
    let lem = document.createElement('span');
    lem.innerHTML = 'Insert 3 elems'
    images.after(lem);
    lem.before(document.createElement('br'));
    event.preventDefault()
  
  }
  else {
    event.target.submit()
  }
}




let addDiscount = document.getElementById('addDiscount');
addDiscount.addEventListener('submit', createDiscount);


function createProductHandler() {
  if (this.status != 200) {
    console.log('ola')
    return;
  }

  let answer = JSON.parse(this.responseText);
  let form = document.getElementById('addProduct');
  form.reset();



  $('#addProductModal').modal('hide');
  $('.modal-backdrop').remove();
  $('body').removeClass('modal-open');

}


function createDiscount(event) {
  event.preventDefault(); 0

  let value = event.target[0].value
  let condition = event.target[1].value
  sendAjaxRequest('post', '/api/discount/add', { value: value, condition: condition }, createDiscountHandler)
}


function createDiscountHandler() {

  if (this.status != 200) {
    console.log(this.status);
    return;
  }

  let answer = JSON.parse(this.responseText);

  addDiscount(answer);

}



let cat = document.getElementById('cat').children[1];
cat.addEventListener('change', modifySub);

function modifySub(event) {
  let next = event.target.parentElement.nextElementSibling
  let subcat = document.getElementById('subcat');

  switch (event.target.value) {
    case 'Activities':
      if (next.id == 'sex') next.remove();

      subcat.children[1].innerHTML = '<option selected="selected">Climbing</option>' +
        '<option>Hiking</option>' +
        '<option>Running</option>' +
        '<option>Fishing</option>' +
        '<option>Hunting</option>'

      break;
    case 'House-Decor':
      if (next.id == 'sex') next.remove();

      subcat.children[1].innerHTML = '<option selected="selected">Kitchen</option>' +
        '<option>Bedroom</option>' +
        '<option>Living Room</option>' +
        '<option>Outdoor</option>'


      break;
    case 'Clothing':
      let sex = document.createElement('div');
      sex.id = "sex";
      sex.className = "form-group";
      sex.innerHTML = '<label for="review_title">Man</label>' +
        '<select name="sex" class="form-control">' +
        '<option selected="selected">Man</option>' +
        '<option>Woman</option>' +
        ' </select>';

      subcat.before(sex);
      subcat.children[1].innerHTML = '  <option selected="selected">Tops</option>' +
        ' <option>Bottoms</option>' +
        '<option>Shoes</option>' +
        ' <option>Acessoires</option>'
      break;
  }

}
