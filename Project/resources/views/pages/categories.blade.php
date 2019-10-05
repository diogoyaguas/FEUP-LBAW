@extends('layouts.app', ['categories' => $categories])


@section('styles')

<link href="{{ asset('css/categories.css') }}" rel="stylesheet">
<script src="{{asset('js/categories.js')}}" defer></script>
<script src="{{asset('js/product.js')}}" defer></script>

@endsection

@section('content')

@guest
<input type="hidden" id="userId" value=-1>
@else
<input type="hidden" id="userId" value={{Auth::user()->id}}>
@endguest

@if (isset($name))
<div class="mt-1">
    <nav aria-label="breadcrumb" id="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href={{url('/')}}>Homepage</a></li>
            <li class="breadcrumb-item"><a href={{ url('/products' . "/" . $name. '/all')}}>{{$name}}</a></li>
            <li class="breadcrumb-item active" aria-current="page">{{$subname}}</a></li>
        </ol>
    </nav>
</div>

@endif

<main>
    <div class="container">
        <div class="products row align-items-center container">
            <div class="col text-right">
                <h1>{{ucfirst($subname)}}</h1>
            </div>
            <div class="col text-right">
                <span>{{(count($products) - 1) * 3  + count($products[count($products) - 1])  }}
                    Products</span></div>
            <div class="dropdown col w-auto text-center">
                <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownSort" data-toggle="dropdown"
                    aria-haspopup="true" aria-expanded="false">
                    Sort By
                </button>
                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                    <a class="dropdown-item 1">Alphabetically </a>
                    <a class="dropdown-item 2">Reversed</a>
                    <a class="dropdown-item 3">Price Ascending</a>
                </div>
            </div>

            <div class="row mt-3 container px-0" id="products">
                <div class="mt-4 col-md-4 col-lg-3 px-0">

                    <h5>Filters</h5>

                    <div class="filters d-flex flex-column ">

                        <h6>Brand</h6>
                        <div class="">
                            @foreach ($brands as $brand)

                            <div class="form-check pl-0" id="brand{{$brand['id']}}">
                                <label class="form-check-label pt-1">
                                    <input type="checkbox" class="brand" value="{{$brand['id']}}">  {{$brand['name']}}<br>
                                </label>
                            </div>

                            @endforeach
                        </div>
                    </div>

                    <div class="filters d-flex flex-column mh-25 mt-3">
                        <h6>Size</h6>
                        <div>
                            @foreach ($sizes as $size)

                            <div class="form-check pl-0" id="size{{$size['id']}}">
                                <label class="form-check-label pt-1">
                                    <input type="checkbox" class="size" value="{{$size['id']}}">  {{$size['name']}}<br>
                                </label>
                            </div>
                            @endforeach
                        </div>
                    </div>
                    <div class="filters d-flex flex-column mt-3">
                        <h6>Color</h6>

                        <div>
                            @foreach ($colors as $color)

                            <div class="form-check pl-0" id="color{{$color['id']}}">
                                <label class="form-check-label pt-1">
                                    <input type="checkbox" class="color" value="{{$color['id']}}">  {{$color['name']}}<br>
                                </label>
                            </div>

                            @endforeach
                        </div>

                    </div>
                </div>

                <div class="col-md-8 col-lg-9">

                    @foreach ($products as $p3)
                    <div class="row">
                        @foreach ($p3 as $product)

                        <div class="mt-3 col-md-5 col-lg-4 products_onrow " id="product{{$product['id']}}">
                            @foreach ($product['brand'] as $brand)
                            <input type="hidden" class="productBrand" value="{{$brand->id_brand}}">
                            @endforeach
                            @foreach ($product['color'] as $color)
                            <input type="hidden" class="productColor" value="{{$color->id_color}}">
                            @endforeach
                            @foreach ($product['size'] as $size)
                            <input type="hidden" class="productSize" value="{{$size->id_size}}">
                            @endforeach
                            <div data-name="{{$product['name']}}"
                                class="box d-flex flex-column align-items-center product_onrow">
                                <img src="{{asset('imgs/product'.$product['id'].'1.png')}}" alt={{$product['name']}}
                                    class="center-block" onclick="window.location='{{url('product/' .$product['id'])}}'"
                                    style="cursor:pointer;">
                                <h5 onclick="window.location='{{url('product/' . $product['id'])}}'"
                                    style="cursor:pointer;">
                                    {{$product['name']}}</h5>
                                <span>{{$product['price']}} €</span>
                                <input type="button" class="AddToCart" value="Add to Cart"
                                    onclick="sendAddToCartRelated({{$product['id']}}, {{$product['price']}})">
                            </div>
                        </div>

                        @endforeach

                    </div>
                    @endforeach
                </div>
            </div>
        </div>
    </div>
</main>

<div id="report" class="box d-flex flex-column last-card" data-toggle="modal" data-target="#alertAddToCart">
</div>
<div class="modal fade" id="alertAddToCart" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Successfully added!</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal OnlineHelp -->
<div class="button_online">
    <p class="text-secondary">
        <button type="button" class="btn" data-toggle="modal" data-target="#exampleModal">
            <div class="container topright text-aling-top">
                <i class="far topright fa-question-circle fa-2x text-top "></i>
            </div>
        </button>
    </p>
</div>
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">What's the purpose of this page?</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>When <strong>searching</strong> inside a list of possible options, users are given the
                    <strong>ability to filter roles</strong>.</p>
                <p>Included roles are <strong>Size</strong>, <strong>Brand</strong> or <strong>Color</strong> in order
                    to <strong>give specificity in choice
                        of products</strong> by limiting the original amount in the product list. Sorting items through
                    fields regarding time and name is also a complement to a better
                    interaction between the user and store.</p>
                <p>Adding the products to the cart is an option aswell.</p>
            </div>
            <div class="modal-footer">
                <div class="container">
                    <div class="modal-body">
                        <span><a href="{{route('faq')}}"> More Questions? </a></span> </div>
                </div>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Got it, thanks!</button>
            </div>
        </div>
    </div>
</div>
@endsection