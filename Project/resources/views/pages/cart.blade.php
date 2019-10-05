@extends('layouts.app', ['categories' => $categories])

@section('styles')

<link href="{{ asset('css/cart.css') }}" rel="stylesheet">
<script src="{{url('js/cart.js')}}" defer></script>
<script src="{{url('js/script.js')}}" defer></script>

@endsection


@section('content')

@guest
<input type="hidden" id="userId" value=-1>
@else
<input type="hidden" id="userId" value={{Auth::user()->id}}>
@endguest

<main class="cart">
  <section class="container">
    <div class="row my-3">
      <h1 class="my-2"> Checkout </h1>
    </div>
    <ul class="nav nav-tabs navbar-expand-md flex-column flex-sm-row" id="cart">
      <li class="nav-item">
        <a class="nav-link active" id="address-tab" data-toggle="tab" href="#address" role="tab" aria-controls="Address"
          aria-selected="true">Address</a>
      </li>

      <li class="nav-item">
        <a class="nav-link" id="payment-tab" data-toggle="tab" href="#payment" role="tab" aria-controls="Payment Method"
          aria-selected="false">Payment Method</a>
      </li>

      <li class="nav-item">
        <a class="nav-link" id="review-tab" data-toggle="tab" href="#review" role="tab" aria-controls="Order Review"
          aria-selected="false">Order Review</a>
      </li>
    </ul>

    <div class="tab-content" id="cartContent">

      <div class="tab-pane fade show active" id="address" role="tabpanel" aria-labelledby="address-tab">

        <div class="progress" style="height: 2px;">
          <div class="progress-bar" role="progressbar" style="width: 25%;" aria-valuenow="25" aria-valuemin="0"
            aria-valuemax="100"></div>
        </div>

        <div class="my-3">
          <h4>Invoice</h4>
        </div>


        <form class="addressForm">
          <div class="row">
            <div class="form-group col-lg-6 col-xs-12">
              <label for="FirstName"> First Name </label>
              <input type="text" class=form-control id="iName" required>
            </div>

            <div class="form-group col-lg-6">
              <label for="LastName"> Last Name </label>
              <input type="text" class=form-control id="iLast" required>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-lg-4 col-xs-12">
              <label for="Email"> Email </label>
              <input type="email" class=form-control id="iEmail" required>
            </div>

            <div class="form-group col-lg-8 col-xs-12">
              <label for="StreetAdress"> Street Address </label>
              <input type="text" class=form-control id="iStreet" required>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-lg-3 col-xs-12">
              <label for="City"> City </label>
              <input type="text" class=form-control id="iCity" required>
            </div>

            <div class="form-group col-lg-3 col-xs-12">
              <label for="ZIPCode"> ZIP Code </label>
              <input type="number" class=form-control id="iZip" required>
            </div>
          </div>

          <div class="row">
            <div class="form-group col-lg-3 col-xs-12">
              <label for="country"> Country </label>
              <input type="text" class=form-control id="iCountry" required>
            </div>

            <div class="form-group col-lg-3 col-xs-12">
              <label for="door"> Door Number </label>
              <input type="number" class=form-control id="iDoor" required>
            </div>
          </div>
          <div class="form-group mt-3">
            <input type="checkbox" name="shippingAddress" id="differentSAdd" data-toggle="collapse"
              data-target="#shippingAddress" aria-controls="shippingAddress">
            <label for="differentSAdd" name="differentSAdd" data-toggle="collapse" data-target="#shippingAddress"
              aria-controls="shippingAddress">
              Give a different address for shipping
            </label>
          </div>

          <div id="shippingAddress" class="collapse" aria-expanded="false">
            <div class="my-3">
              <h4>Shipping Address</h4>
            </div>

            <div class="row">
              <div class="form-group col-md-6 col-xs-12 ">
                <label for="FirstName"> First Name </label>
                <input type="text" class=form-control id="sName">
              </div>

              <div class="form-group col-md-6 col-xs-12">
                <label for="LastName"> Last Name </label>
                <input type="text" class=form-control id="sLast">
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-4 col-xs-12">
                <label for="Email"> Email </label>
                <input type="email" class=form-control id="sEmail">
              </div>

              <div class="form-group col-md-8 col-xs-12">
                <label for="StreetAdress"> Street Address </label>
                <input type="text" class=form-control id="sStreet">
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-3 col-xs-12">
                <label for="City"> City </label>
                <input type="text" class=form-control id="sCity">
              </div>

              <div class="form-group col-md-3 col-xs-12">
                <label for="ZIPCode"> ZIP Code </label>
                <input type="number" class=form-control id="sZip">
              </div>
            </div>

            <div class="row">
              <div class="form-group col-md-3 col-xs-12">
                <label for="country"> Country </label>
                <input type="text" class=form-control id="sCountry">
              </div>

              <div class="form-group col-md-3 col-xs-12">
                <label for="door"> Door Number </label>
                <input type="number" class=form-control id="sDoor">
              </div>
            </div>
          </div>

          <div class="row">
            <button id="addressBtn" type="button" class="btn col-md-6 col-lg-2 offset-md-8 next">
              <span class="text-justify"> Payment Method <i class="fas fa-chevron-right pl-2"></i> </span>
            </button>
          </div>
        </form>
      </div>
      <div class="tab-pane fade" id="payment" role="tabpanel" aria-labelledby="payment-tab">
        <div class="progress" style="height: 2px;">
          <div class="progress-bar" role="progressbar" style="width: 66%;" aria-valuenow="66" aria-valuemin="0"
            aria-valuemax="100"></div>
        </div>

        <form class="row" action="#">
          <div class="container pt-3">
            <div class="col-lg-6 col-xs-12">

              <div class="form-group">
                <label class="form-label" for="cardNumber"> Card Number </label>
                <input class="form-control" type="number" id="cardNumber">
              </div>
              <div class="form-group">
                <label for="expDate"> Expiration Date </label>
                <input id="expDate" type="date" class="form-control" placeholder="Your expiration date">
              </div>

              <div class="form-group">
                <label for="ccv"> CCV </label>
                <input class="form-control" type="number" id="ccv">
              </div>
            </div>
          </div>
        </form>

        <div class="row">
          <button type="button" id="back-button" class="btn col-lg-2 offset-md-2 back-button col-xs-2">
            <a>Back</a>
          </button>
          <button id="paymentBtn" type="button" class="btn col-lg-2 offset-md-4 col-xs-2 next">
            <span class="text-justify">Order Review <i class="fas fa-chevron-right pl-2"></i> </span>
          </button>
        </div>
      </div>

      <div class="tab-pane fade" id="review" role="tabpanel" aria-labelledby="review-tab">
        <div class="progress" style="height: 2px;">
          <div class="progress-bar" role="progressbar" style="width: 100%;" aria-valuenow="100" aria-valuemin="0"
            aria-valuemax="100"></div>
        </div>
        <table class="table table-responsive-sm">
          <thead>
            <tr>
              <th scope="col">Product</th>
              <th scope="col">Name</th>
              <th scope="col">Price</th>
              <th scope="col">Quantity</th>
              <th scope="col">Total</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody>
            @foreach ($lines as $line)
            <tr id="line{{$line['id']}}">
              <th scope="row"><img class="img-fluid w-25 h-20"
                  src="{{asset('imgs/product'.$line['id_product'].'1.png')}}" alt="product_image"></th>
              <td class="name">{{$line['name']}}</td>
              <td class="price">{{$line['single_price']}}€</td>
              <td class="quantity">{{$line['quantity']}}</td>
              <td class="subtotal">{{$line['price']}}€</td>
              <td class="trash"><i class="fas fa-trash-alt ml-auto" value="{{$line['id']}}-{{$line['price']}}"></i></td>
            </tr>
            @endforeach
            <td colspan="4" class="justify-content-left"> Total</th>
            <td colspan="2" class="justify-content-right total">{{number_format((float)$total, 2, '.', '')}} €</th>
              @if(Auth::user()['type_user'] == 'premium' )
              </tr>
            <td colspan="4" class="justify-content-left">Premium Discount</th>
            <td colspan="2" class="justify-content-right total">-30%</th>
            </tr>
            <td colspan="4" class="justify-content-left">New Total</th>
            <td colspan="2" class="justify-content-right newTotal">{{number_format((float)$total*0.7, 2, '.', '')}} €</th>
              @endif
              </tr>
          </tbody>
        </table>

        <div class="row mt-2">
          <button type="button" id="back-button" class="btn col-lg-2 col-md-3 offset-md-2 back-button">
            <a>Back</a>
          </button>
          <button id="checkoutBtn" type="button" class="btn col-lg-2 col-md-3 offset-md-4 justify-content-center next"
            onclick="completePurchase({{json_encode($lines)}}, {{$total}})">
            <span class="text-justify">Complete Purchase</span>
          </button>
        </div>
      </div>
    </div>
  </section>
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
        <p><strong>Shipping Information:</strong></p>
        <p>Receiving an invoice requires a user to fill his shipping informations. If need be, users can submit
          different addresses.</p>
        <p></p>
        <p><strong>Payment Method:</strong></p>
        <p>Users can choose between options of payment. If <strong>‘Credit Card’</strong> chosen, user must fill the
          corresponding informations.</p>
        <p>Once clicked on <strong>Paypal, user is to be redirected to PayPal authentication service</strong>.</p>
        <p></p>
        <p><strong>Order Review:</strong></p>
        <p>Warning: The stock <strong>may</strong> change during this procedure.</p>
        <p>Users can change the quantity of each product accordingly to their desire, by clicking corresponding buttons.
        </p>
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