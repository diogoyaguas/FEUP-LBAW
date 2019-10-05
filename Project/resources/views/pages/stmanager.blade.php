<div class="mt-1">
    <nav aria-label="breadcrumb" id="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.html">Homepage</a></li>
            <li class="breadcrumb-item active" aria-current="page">Store Manager</li>
        </ol>
    </nav>
</div>

<div class="container">
    <div class="container scroll_nav">
        <div class="row">
            <h1 class="col-lg col-md col-sm-12">
                Store Manager Area
            </h1>
            <a href="#product_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Manage Products
            </a>
            <a href="#discounts_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Manage Discounts
            </a>
        </div>
    </div>
</div>

<main>
    <div class="container">

        <section class="py-5" id="products-section">

            <div id="products_title" class="jumptarget">
                <div class="cards row">
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-end justify-content-left">
                        <div class="box d-flex flex-column last-card">
                            <h2>Manage Products</h2>
                        </div>
                    </div>
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-center justify-content-end">
                        <div id="addAlterButton" class="box d-flex flex-column last-card" data-toggle="modal"
                            data-target="#addProductModal">
                            &#10010; Add Product
                        </div>
                    </div>
                </div>
            </div>
    </div>

    <div class="row">
        <div class="mt-3 col-md-5 col-lg-4">
            <div class="box d-flex flex-column align-items-center">
                <img src="assets/pants.png" alt="product_image" class="center-block"
                    onclick="window.location='product.html'" style="cursor:pointer;">
                <h5 id="productName" onclick="window.location='product.html'" style="cursor:pointer;">Men's
                    Sprag
                    5-pocket Pants</h5>
                <div class="details">
                    <span>Price: 32,00€</span>
                    <span>Color: Beige</span>
                    <span>Size: 40</span>
                    <span>Sub-Category: Pants</span>
                    <span>In Stock: 43</span>
                </div>
                <span id="pencil" class="ml-auto" data-toggle="modal" data-target="#addProductModal">&#9998;</span>
            </div>
        </div>
        <div class="mt-3 col-md-5 col-lg-4">
            <div class="box d-flex flex-column align-items-center">
                <img src="assets/jacket2.png" alt="product_image" class="center-block"
                    onclick="window.location='product.html'" style="cursor:pointer;">
                <h5 id="productName" onclick="window.location='product.html'" style="cursor:pointer;">Men's
                    Gotham Jacket
                    III</h5>
                <div class="details">
                    <span>Price: 89,90€</span>
                    <span>Color: Black</span>
                    <span>Size: 42</span>
                    <span>Sub-Category: Shoes</span>
                    <span>In Stock: 61</span>
                </div>
                <span id="pencil" class="ml-auto" data-toggle="modal" data-target="#addProductModal">&#9998;</span>
            </div>
        </div>
        <div class="mt-3 col-md-5 col-lg-4">
            <div class="box d-flex flex-column align-items-center">
                <img src="assets/boots.png" alt="product_image" class="center-block"
                    onclick="window.location='product.html'" style="cursor:pointer;">
                <h5 id="productName" onclick="window.location='product.html'" style="cursor:pointer;">Men's
                    Tsumoru Boot</h5>
                <div class="details">
                    <span>Price: 122,00€</span>
                    <span>Color: Camel</span>
                    <span>Size: 42</span>
                    <span>Sub-Category: Shoes</span>
                    <span>In Stock: 27</span>
                </div>
                <span id="pencil" class="ml-auto" data-toggle="modal" data-target="#addProductModal">&#9998;</span>
            </div>
        </div>
    </div>
    </section>
    </div>

    <div class="modal fade" id="addProductModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Add/Edit Product</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    </button>
                    <span aria-hidden="true">&times;</span>
                </div>
                <form id="addProduct" method="POST" action="{{url('/product/add')}}" enctype="multipart/form-data">

                    {{ csrf_field() }}

                    <div class="modal-body section-container mt-0">
                        <div class="form-group">
                            <label for="review_title">Name</label>
                            <input type="text" name="name" class="form-control" placeholder="Product Name" required>
                        </div>
                        <div class="form-group">
                            <label for=image>Product Images</label> <br>
                            <input type="file" name="image[]" id="img" accept="image/*" multiple required>
                        </div>
                        <div class="form-group">
                            <label for="review_title">Price</label>
                            <input type="number" name="price" class="form-control" placeholder="Product Price" min="0.1"
                                step="0.1" title="the price needs to be higher then 0.1€" required>
                        </div>
                        <div class="form-group">
                            <label for="review_title">Color</label>
                            <input type="text" name="color" class="form-control" placeholder="Product Stock" required>
                        </div>
                        <div class="form-group">
                            <label for="review_title">Description</label>
                            <textarea name="description" rows="4" cols="10" class="form-control" placeInsert product
                                descriptionholder="Insert product description" style="  resize: none;" pattern=".{20,}"
                                required title="20 characters minimum"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="review_title">Size</label>
                            <select name="size" class="form-control">
                                <option selected="selected">3XS</option>
                                <option>XXS</option>
                                <option>XS</option>
                                <option>S</option>
                                <option>M</option>
                                <option>L</option>
                                <option>XL</option>
                                <option>XXL</option>
                                <option>3XL</option>
                            </select>
                        </div>


                        <div class="form-group">
                            <label for="review_title">Stock</label>
                            <input name="stock" type="number" pattern='\d' class="form-control"
                                placeholder="Product Stock" required>
                        </div>

                        <div id="cat" class="form-group">
                            <label for="review_title">Category</label>
                            <select name="category" class="form-control">
                                <option selected="selected">Clothing</option>
                                <option>House-Decor</option>
                                <option>Activities</option>
                            </select>
                        </div>

                        <div id="sex" class="form-group">

                            <label for="review_title">Man</label>
                            <select name="sex" class="form-control">
                                <option selected="selected">Man</option>
                                <option>Woman</option>
                            </select>
                        </div>

                        <div id="subcat" class="form-group">
                            <label for="review_title">Sub-Category</label>
                            <select name="subcategory" class="form-control">
                                <option selected="selected">Tops</option>
                                <option>Bottoms</option>
                                <option>Shoes</option>
                                <option>Acessoires</option>
                            </select>
                        </div>



                    </div>
                    <div class="modal-footer">
                        <input type="button" data-dismiss="modal" value="Close"></input>
                        <input type="submit" class="black-button" value="Save"></input>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="container pt-5">

        <section class="py-5" id="discounts-section">

            <div id="discounts_title" class="jumptarget">

                <div class="cards row">
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-end justify-content-left">
                        <div class="box d-flex flex-column last-card">
                            <h2>Manage Discounts</h2>
                        </div>
                    </div>
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-center justify-content-end">
                        <div id="addAlterButton" class="box d-flex flex-column last-card" data-toggle="modal"
                            data-target="#addDiscountModal">
                            &#10010; Add Discount
                        </div>
                    </div>
                </div>
            </div>

            <div class="cards row">
                <div class="mt-4 col-md-6 col-lg-3">
                    <div class="box d-flex flex-column">
                        <i class="fas fa-trash-alt ml-auto"></i>
                        <div class="d-flex flex-row address-header">
                            <i class="fas fa-tag pr-1"></i>
                            <h6>-20%</h6>
                        </div>
                        <h6>In purchases higher than 50€</h6>
                    </div>
                </div>
                <div class="mt-4 col-md-6 col-lg-3">
                    <div class="box d-flex flex-column">
                        <i class="fas fa-trash-alt ml-auto"></i>
                        <div class="d-flex flex-row address-header">
                            <i class="fas fa-tag pr-1"></i>
                            <h6>-35€</h6>
                        </div>
                        <h6>In purchases higher than 100€</h6>
                    </div>
                </div>
            </div>

        </section>
    </div>

    <div class="modal fade" id="addDiscountModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Add Discount</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    </button>
                    <span aria-hidden="true">&times;</span>
                </div>
                <form id="addDiscount">
                    <div class="modal-body section-container mt-0">
                        <div class="form-group">
                            <label for="review_title">Value</label>
                            <input type="text" class="form-control" placeholder="Discount value">
                        </div>
                        <div class="form-group">
                            <label for="review_title">Condition</label>
                            <input type="text" class="form-control" placeholder="Discount ondition">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" data-dismiss="modal" value="Close">
                        <input type="submit" class="black-button" value="Save">
                    </div>
                </form>
            </div>
        </div>
    </div>


</main>