$(".1").click(function () {
  let sort_by_name = function (a, b) {
    return a.getAttribute('data-name').toLowerCase().localeCompare(b.getAttribute('data-name').toLowerCase());
  }

  let list = document.querySelectorAll(".products_onrow");
  let list_param = document.querySelectorAll(".products_onrow .product_onrow");

  let list_paramArr = [].slice.call(list_param).sort(sort_by_name);


  for (let i = 0; i < list.length; i++) {
    list[i].appendChild(list_paramArr[i]);
  }

})

$(".2").click(function () {
  let sort_by_price = function (a, b) {
    return b.getAttribute('data-name').toLowerCase().localeCompare(a.getAttribute('data-name').toLowerCase());
  }
  let list = document.querySelectorAll(".products_onrow");
  let list_param = document.querySelectorAll(".products_onrow .product_onrow");
  let list_paramArr = [].slice.call(list_param).sort(sort_by_price);


  for (let i = 0; i < list.length; i++) {
    list[i].appendChild(list_paramArr[i]);
  }
})

$(".3").click(function () {
  let sort_by_price = function (a, b) {
    return parseInt($(a).find("span").text(), 10) - parseInt($(b).find('span').text(), 10);
  }
  let list = document.querySelectorAll(".products_onrow");
  let list_param = document.querySelectorAll(".products_onrow .product_onrow");

  let list_paramArr = [].slice.call(list_param).sort(sort_by_price);


  for (let i = 0; i < list.length; i++) {
    list[i].appendChild(list_paramArr[i]);
  }
})

let filterBrands = [];
let filterColors = [];
let filterSizes = [];
let allProducts = document.querySelectorAll('.mt-3.col-md-5.col-lg-4.products_onrow');
let productBrands = document.querySelectorAll('input[class=productBrand]');
let productColors = document.querySelectorAll('input[class=productColor]');
let productSizes = document.querySelectorAll('input[class=productSize]');

let brands = document.querySelectorAll("input[class=brand]");

[].forEach.call(brands, function (e) {
  e.addEventListener('change', filterBrand);
});

function filterBrand(event) {
  let brandID = event.path[0].value;
  if (this.checked) {
    filterBrands.push(brandID);
    updateProducts();
  } else {
    filterBrands = remove(filterBrands, brandID);
    updateProducts();
  }
}

let colors = document.querySelectorAll("input[class=color]");

[].forEach.call(colors, function (e) {
  e.addEventListener('change', filterColor);
});

function filterColor(event) {
  let colorID = event.path[0].value;
  if (this.checked) {
    filterColors.push(colorID);
    updateProducts();
  } else {
    filterColors = remove(filterColors, colorID);
    updateProducts();
  }
}

let sizes = document.querySelectorAll("input[class=size]");

[].forEach.call(sizes, function (e) {
  e.addEventListener('change', filterSize);
});

function filterSize(event) {
  let sizeID = event.path[0].value;
  if (this.checked) {
    filterSizes.push(sizeID);
    updateProducts();
  } else {
    filterSizes = remove(filterSizes, sizeID);
    updateProducts();
  }
}

function updateProducts() {

  let filters = [];

  productBrands.forEach(function (pb) {
    filterBrands.forEach(function (b) {
      if (pb.value == b) {
        filters.push(pb.parentElement);
      }
    })
  });
  productColors.forEach(function (pc) {
    filterColors.forEach(function (c) {
      if (pc.value == c) {
        filters.push(pc.parentElement);
      }
    })
  });
  productSizes.forEach(function (ps) {
    filterSizes.forEach(function (s) {
      if (ps.value == s) {
        filters.push(ps.parentElement);
      }
    })
  });

  let unique = [...new Set(filters)];
  if (unique.length == 0 && filterBrands.length == 0 && filterColors.length == 0 && filterSizes.length == 0) {
    unique = allProducts;
  }
  drawProducts(unique);
}

function drawProducts(products) {

  let div = "";
  let count = 0;
  let finalProducts = document.querySelector('.col-md-8.col-lg-9');
  if (products.length == 0) {
    finalProducts.innerHTML = '<div class="col text-center pt-5"><h1>Sorry! No match!</h1></div>';
  } else {
    products.forEach(function (e) {
      if (count % 3 == 0) {
        div += '<div class="row">';
      }
      count++;
      div += e.outerHTML;
      if (count % 3 == 0) {
        div += '</div>';
      }
    });
    finalProducts.innerHTML = div;
  }
}

function remove(arr) {
  var what, a = arguments, L = a.length, ax;
  while (L > 1 && arr.length) {
    what = a[--L];
    while ((ax = arr.indexOf(what)) !== -1) {
      arr.splice(ax, 1);
    }
  }
  return arr;
}