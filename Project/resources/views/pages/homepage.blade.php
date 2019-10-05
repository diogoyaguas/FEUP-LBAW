@extends('layouts.app', ['categories' => $categories])

@section('styles')
<link href="{{ asset('css/homepage.css') }}" rel="stylesheet">
<script src="{{asset('js/product.js')}}" defer></script>

@endsection

@section('content')

@guest
<input type="hidden" id="userId" value=-1>
@else
<input type="hidden" id="userId" value={{Auth::user()->id}}>
@endguest

<div>
  <div class="video1">
    <div class="overlay"></div>
    <div class="video-block block">
      <video src="{{asset('imgs/promovidANIMALS.mp4')}}" autoplay muted loop></video>
    </div>
    <div class="container h-100">
      <div class="d-flex h-100 text-center align-items-center">
        <div class="w-100 text-white">
          <h1 class="display-3">WILDLIFE FANATIC ?</h1>
        </div>
      </div>
    </div>
  </div>
</div>
<div id="report" class="box d-flex flex-column last-card" data-toggle="modal" data-target="#alertAddToCart">
</div>
<div class="modal fade" id="alertAddToCart" tabindex="-1" role="dialog" aria-hidden="true">
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
<div class="featuredproducts">
  <div class="mt-5 container">
    <h2>Featured Products</h2>
    <div class="row">
      @foreach ($featuredProducts as $product)
      <div class="mt-3 col-md-5 col-lg-4">
        <div class="box d-flex flex-column align-items-center">
          <img src="{{asset('imgs/product'.$product['id'].'1.png')}}" alt="product_image" class="center-block"
            onclick="window.location='product/'+{{$product['id']}}" style="cursor:pointer;">
          <h5 onclick="window.location='product/'+{{$product['id']}}" style="cursor:pointer;">{{$product['name']}}</h5>
          <span>{{$product['price']}} €</span>
          <input type="button" class="AddToCart" value="Add to Cart"
            onclick="sendAddToCartRelated({{$product['id']}}, {{$product['price']}})">
        </div>
      </div>
      @endforeach
    </div>
  </div>
</div>
<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
  <div class="carousel-inner" role="listbox">
    <!-- Slide One - Set the background image for this slide in the line below -->
    <div class="carousel-item active w-100" style="background-image:url({{asset('imgs/slide1.jpg')}}">
      <div class="carousel-caption d-md-block">
      </div>
    </div>
    <!-- Slide Two - Set the background image for this slide in the line below -->
    <div class="carousel-item" style="background-image: url({{asset('imgs/slide2.jpg')}})">
      <div class="carousel-caption d-none d-md-block">
      </div>
    </div>
    <!-- Slide Three - Set the background image for this slide in the line below -->
    <div class="carousel-item" style="background-image: url({{asset('imgs/slide3.png')}})">
      <div class="carousel-caption d-none d-md-block">
        <p class="lead">Any questions? Let us know!</p>
      </div>
    </div>
  </div>
  <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
<div class="video2">
  <div class="overlay h-100"></div>
  <div class="video-block block">
    <video src="{{url('imgs/promovidOUTDOORS.mp4')}}" autoplay muted loop></video>
  </div>
  <div class="container h-100">
    <div class="d-flex h-100 text-center align-items-center">
      <div class="w-100 text-white">
        <h1 class="display-3">OUTDOORS EXPERTISE</h1>
      </div>
    </div>
  </div>
</div>
</div>
<div class="saleproducts">
  <div class="mt-5 container">
    <h2>Products on Sale</h2>
    <div class="row">
      @foreach ($saleProducts as $product)
      <div class="mt-3 col-md-5 col-lg-4">
        <div class="box d-flex flex-column align-items-center">
          <img src="{{asset('imgs/product'.$product['id'].'1.png')}}" alt="product_image" class="center-block"
            onclick="window.location='product/'+{{$product['id']}}" style="cursor:pointer;">
          <h5 onclick="window.location='product/'+{{$product['id']}}" style="cursor:pointer;">{{$product['name']}}</h5>
          <span>{{$product['price']}} €</span>
          <input type="button" class="AddToCart" value="Add to Cart"
            onclick="sendAddToCartRelated({{$product['id']}}, {{$product['price']}})">
        </div>
      </div>
      @endforeach
    </div>
  </div>
</div>
</div>
</div>

<!-- Button trigger modal -->
<div class="container topright text-aling-top ml-0">
  <button type="button" class="btn" data-toggle="modal" data-target="#exampleModal">
    <i class="far topright fa-question-circle fa-2x text-top "></i>
  </button>
</div>
<!-- Modal -->
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
        <p>Welcome to <strong>aurora</strong>, where all things Country-Side offer the user <strong>unique experiences
          </strong> through Clothing, House Accessories or any materials for wildlife Activities.
          In the midst of the spectre that is “Nature”, it is important to <strong>help any users find their best
            tangible products</strong> so they can feel a <strong>sense of exploring</strong> and <strong>gain better
            values</strong> adapted to nature’s landscapes.
          Users can find the <strong>latest products inside</strong> the store through the <strong>“Featured Products”
            section</strong>.</p>
        <p>Any sales applied to our products based on seasons throughout the <strong>“Products on Sale” section</strong>
          are also available. </p>
        <p> On any occasion, users can look for products in the presented search-bar or pre-assigned categories such as
          ‘Clothing’, ‘House-Decor’ & ‘Activities’.</p>
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