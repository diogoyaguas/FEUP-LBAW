@extends('layouts.app', ['categories' => $categories])


@section('styles')

<link href="{{ asset('css/product.css') }}" rel="stylesheet">
<link href="{{ asset('css/print.css') }}" rel="stylesheet">
<script src="{{asset('js/product.js')}}" defer></script>
@endsection


@section('content')

<div class="mt-1">
    <nav aria-label="breadcrumb" id="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/homepage">Homepage</a></li>
            <li class="breadcrumb-item active" aria-current="page">Product</li>
        </ol>
    </nav>
</div>

</main>

@guest
<input type="hidden" id="userId" value=-1>
@else
<input type="hidden" id="userId" value={{Auth::user()->id}}>
@endguest

<div class="media pl-5">
    <div id="product-images" class="carousel slide carousel-fade" data-ride="carousel">
        <ol class="carousel-indicators">
            <li data-target="#product-images" data-slide-to="0" class="active"></li>
            <li data-target="#product-images" data-slide-to="1"></li>
            <li data-target="#product-images" data-slide-to="2"></li>
        </ol>
        <div class="carousel-inner">
            <div class="carousel-item active d-flex justify-content-center">
                <img src="{{asset('imgs/product'.$product['id'].'1.png')}}" class="center-block" alt="...">
            </div>
            <div class="carousel-item d-flex justify-content-center">
                <img src="{{asset('imgs/product'.$product['id'].'2.png')}}" class="center-block" alt="...">
            </div>
            <div class="carousel-item d-flex justify-content-center">
                <img src="{{asset('imgs/product'.$product['id'].'3.png')}}" class="center-block" alt="...">
            </div>
        </div>
        <a class="carousel-control-prev" href="#product-images" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#product-images" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>

    <input type="hidden" id="productId" value={{$product['id']}}>
    <input type="hidden" id="productPrice" value={{$product['price']}}>

    <div class="media-body pl-3">
        <h3 class="mt-0 product-title">{{$product['name']}} </h3>
        <div id="cart">
            <form id="AddToCartForm" class="product_form">
                <p id="product-price">
                    <span class="price">{{$product['price']}}€</span>
                    <br>
                    <label>{{$product->score}}/5</label>
                    <img src="{{asset('imgs/star.png')}}" alt="star" class="pontuation mt-4">
                </p>
                @if(Auth::check())

                @if(Auth::user()->isFav($product['id']))
                <p class="favorites" data-toggle="modal" data-target="#alertFavorite">
                    <i class="fas fa-heart pr-1"></i> Add to favorites</p>
                @else
                <p class="favorites" data-toggle="modal" data-target="#alertFavorite">
                    <i class="fas fa-heart ml-auto"></i> Remove from favorites</p>
                @endif
                @endif
                <div class="product-add">
                    <div class="form-group">
                        <label for="quantity">Quantity</label>
                        <input class="form-control" min="1" type="number" id="quantity" name="quantity" value="1">
                    </div>
                    <label for="quantity">Color</label>
                    <div class="form-group">
                        <select class="form-control w-25">
                            @foreach ($product->colors as $color)
                            <option>{{$color->name}}</option>
                            @endforeach
                        </select>
                    </div>
                    <label for="quantity">Size</label>
                    <div class="form-group">
                        <select class="form-control w-25">
                            @foreach ($product->sizes as $size)
                            <option>{{$size->name}}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                @if(Auth::check())<input type="submit" name="Submit" class="AddtoCart" value="Add to Cart">

                @else <span>login to buy</span>
                @endif
            </form>
            <div id="report" class="box d-flex flex-column last-card" data-toggle="modal" data-target="#alertAddToCart">
            </div>
            <div class="modal fade" id="alertAddToCart" tabindex="-1" role="dialog"
                aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
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
        </div>
    </div>
</div>

<div id="informations">
    <ul class="list-group list-group-flush">
        <li class="list-group-item pt-4">
            <h6>Description</h6>
            <p>{{$product['description']}}</p>
        </li>
        <li class="list-group-item pt-4">
            <div id="reviews" class="jumptarget">
                <h6>Reviews</h6>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item pt-4">
                        <form id="makeReview">
                            <h6>Make your review</h6>
                            <div class="form-group" id="reviewTitle">Title<br />
                                <input type="text" class="form-control" required />
                            </div>
                            <div class="form-group">Rating<br />
                                <div class="getValue d-flex justify-content-center">
                                    <span class="value">1</span>
                                    <input type="range" class="custom-range" id="formControlRange" min=1 max=5>
                                    <span class="value">5</span>
                                </div>
                            </div>
                            <div class="form-group">Review<br />
                                <textarea rows="5" maxlength="250" placeholder="Maximum 250 characters..."
                                    class="form-control"></textarea>
                            </div>
                            <div>
                                @if(Auth::check())
                                <input name="Submit" value="Submit" type="submit" />
                                @else <span> Login to be able to make a review </span>
                                @endif
                            </div>
                        </form>
                    </li>
                    @foreach ($reviews as $review)
                    <li class="list-group-item pt-4">
                        <div id="review-{{$review->id}}" class="jumptarget">
                            <h5>{{$review->title}}</h5>
                            <div class="pontuation">
                                <label>{{$review->score}}/5</label>
                                <img src="{{asset('imgs/star.png')}}" alt="star">
                            </div>
                            <p>{{$review->description}}</p>
                            <h5 class="author">{{$review->name}}</h5>
                        </div>
                        <div class="report mt-1 pt-5 ml-auto d-flex align-items-end justify-content-end">
                            <div id="report" class="box d-flex flex-column last-card" data-toggle="modal"
                                data-target="#alertReview"
                                onclick="reportReview({{$review->id}}, {{$review->id_user}}, {{Auth::user()->id}})">
                                Report Review
                            </div>
                        </div>
                    </li>
                    @endforeach
                </ul>
            </div>
        </li>

        <div class="modal fade" id="alertReview" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle">Review Reported!</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <li class="list-group-item mb-3">
            <div class="featuredproducts">
                <div class="mt-3 container">
                    <h6>Related Products</h6>
                    <div class="row">
                        @foreach ($product->relatedProducts as $Rproduct)
                        <div class="mt-3 col-md-5 col-lg-4">
                            <div class="box d-flex flex-column align-items-center">
                                <img src="{{asset('imgs/product'.$Rproduct['id'].'1.png')}}" alt="product_image"
                                    class="center-block" onclick="window.location={{$Rproduct['id']}}"
                                    style="cursor:pointer;">
                                <h5 onclick="window.location={{$Rproduct['id']}}" style="cursor:pointer;">
                                    {{$Rproduct['name']}}
                                </h5>
                                <span>{{$Rproduct['price']}} €</span>
                                @if(Auth::check())<input type="button" class="AddToCart" value="Add to Cart"
                                    onclick="sendAddToCartRelated({{$Rproduct['id']}}, {{$Rproduct['price']}})">
                                @else<input type="button" class="AddToCart" value="Add to Cart"
                                    onclick="{{route('login')}}">
                                @endif
                            </div>
                        </div>
                        @endforeach
                    </div>
                </div>
        </li>
    </ul>
</div>
</main>

<!-- Modal OnlineHelp -->
<p class="text-secondary">
    <button type="button" class="btn" data-toggle="modal" data-target="#exampleModal">
        <div class="container topright text-aling-top">
            <i class="far topright fa-question-circle fa-2x text-top "></i>
        </div>
    </button>
</p>
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
                <p>When in search for a specific product, users are able to <strong>assert their desired color and
                        size</strong>, if available.</p>
                <p>Whenever in need to speak about a certain product’s quality, a <strong>dedicated area to
                        reviews</strong> is presented. If a user wishes to review some
                    product, a <strong>score submission between 1-5</strong> is mandatory in exception for comments.</p>
                <p>Related products to the actual product search are shown to maintain versatility in stock</p>
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