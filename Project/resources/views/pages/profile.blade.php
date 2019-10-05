@extends('layouts.app', ['categories' => $categories])

@section('styles')
<link href="{{ asset('css/profile.css') }}" rel="stylesheet">

@if($user['type_user'] == 'user')
<script src="{{url('js/profile.js')}}" defer></script>

@elseif($user['type_user'] == 'store_manager')
<script src="{{url('js/manager.js')}}" defer></script>

@else <script src="{{url('js/profile.js')}}" defer></script>
@endif
@endsection

@section('content')

@if($user['type_user'] == 'user' ||$user['type_user'] == 'premium'  )
<input type="hidden" id="userId" value={{Auth::user()->id}}>

<div class="mt-1">
    <nav aria-label="breadcrumb" id="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/homepage">Homepage</a></li>
            <li class="breadcrumb-item active" aria-current="page">My Profile</li>
        </ol>
    </nav>
</div>

<div class="container">
    <div class="container scroll_nav">
        <div class="row">
            @if($user['type_user'] == 'user')
            <h1 class="col-lg col-md col-sm-6">
                My Area
            </h1>
            @elseif($user['type_user'] == 'premium')
            <h1 class="col-lg col-md col-sm-6">
                My Area <span class="badge badge-secondary">Premium</span>
            </h1>
            @endif
            <a href="#profile_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Profile
            </a>
            <a href="#addresses_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Addresses
            </a>
            <a href="#favorite_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Favorites
            </a>
            <a href="#onhold_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                On Hold
            </a>
            <a href="#history_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                History
            </a>
        </div>
    </div>
</div>


<main>
    <div class="container">

        <section class="py-5" id="profile-section">

            <div id="profile_title" class="jumptarget">
                <div class="cards row">
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-end justify-content-left">
                        <div class="box d-flex flex-column last-card">
                            <h2>Profile</h2>
                        </div>
                    </div>
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-center justify-content-end">
                        <div id="addAlterButton" class="box d-flex flex-column last-card" data-toggle="modal"
                            data-target="#alterInformationModal">
                            &#9998; Change information
                        </div>
                    </div>
                </div>
            </div>

            <div class="section-container">
                <div class="information pt-3 form-inline">
                    <label for="profile_name">Name</label>
                    <h5 id="profile_name" class="pt-2"> {{$user['name']}}</h5>
                </div>
                <div class="information pt-2 form-inline">
                    <label for="profile_username">Username</label>
                    <h5 id="profile_username" class="pt-2">{{$user['username']}}</h5>
                </div>
                <div class="information pt-2 form-inline">
                    <label for="profile_email">Email</label>
                    <h5 id="profile_email" class="pt-2">{{$user['email']}}</h5>
                </div>
            </div>
        </section>
    </div>

    <div class="modal fade" id="alterInformationModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered" role="dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Alter Information</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="alterInfoUser">
                    <div class="modal-body section-container mt-0">
                        <div class="form-group">
                            <label for="review_title">Name</label>
                            <input type="text" id="edit-name" class="form-control" placeholder="Your Name"
                                value="{{$user['name']}}">
                        </div>
                        <div class="form-group">
                            <label for="review_title">Username</label>
                            <input type="text" id="edit-username" class="form-control" placeholder="Your Username"
                                value="{{$user['username']}}">
                        </div>
                        <div class="form-group">
                            <label for="review_title">Email</label>
                            <input type="email" id="edit-email" class="form-control" placeholder="Your Email"
                                value="{{$user['email']}}">
                        </div>
                        <div class="form-group">
                            <label for="review_title">Password</label>
                            <input id="edit-password" type="password" class="form-control" placeholder="Your password">
                        </div>
                        <div class="form-group">
                            <label for="review_title">New Password</label>
                            <input type="password" id="edit-newpassword" class="form-control"
                                placeholder="Your new password">
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


    <div class="container">
        <section class="py-5">

            <div id="addresses_title" class="jumptarget">
                <div class="cards row">
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-end justify-content-left">
                        <div class="box d-flex flex-column last-card">
                            <h2>Addresses</h2>
                        </div>
                    </div>
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-center justify-content-end">
                        <div id="addAlterButton" class="box d-flex flex-column last-card" data-toggle="modal"
                            data-target="#addAddressModal">
                            &#10010; Add Address
                        </div>
                    </div>
                </div>
            </div>

            <div class="cards row mt-2">

                @foreach ($addresses as $item)
                <div class="mt-2 col-md-6 col-lg-3" id="address-{{$item['id']}}">
                    <div class="box d-flex flex-column">
                        <i class="fas fa-trash-alt ml-auto addr" value={{$item['id']}}></i>

                        <div class="d-flex flex-row address-header">


                            @switch($item['type_address'])
                            @case('home')
                            <i class="fas fa-home pr-1"></i>
                            <h6>Home</h6>

                            @break
                            @case('other')
                            <i class="fab fa-bandcamp pr-1"></i>
                            <h6>Other</h6>

                            @break
                            @default
                            <i class="fas fa-briefcase pr-1"></i>
                            <h6>Work</h6>

                            @endswitch

                        </div>

                        <h6> {{ $item['door_number']. ' ' . $item['street'] . ', ' . $item['zipcode'] . ' ' . $item['city'] . ' - ' . $item['country']}}
                        </h6>

                    </div>
                </div>
                @endforeach


            </div>

        </section>
    </div>

    <div class="modal fade" id="addAddressModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Add Address</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="newAddress">
                    <div class="modal-body section-container mt-0">
                        <div class="form-group">
                            <label for="review_title">Type</label>
                            <select class="form-control">
                                <option selected="selected"><i class="fas fa-home pr-1"></i>Home</option>
                                <option><i class="fas fa-briefcase pr-1"></i>Work</option>
                                <option><i class="fab fa-bandcamp pr-1"></i> Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="review_title">Door Number</label>
                            <input type="number" class="form-control" placeholder="Door Number" required>
                        </div>
                        <div class="form-group">
                            <label for="review_title">Street</label>
                            <input type="text" class="form-control" placeholder="Your street" required>
                        </div>
                        <div class="form-group">
                            <label for="review_title">ZIP Code</label>
                            <input type="text" class="form-control" placeholder="Your ZIP code" required>
                        </div>
                        <div class="form-group">
                            <label for="review_title">City</label>
                            <input type="text" class="form-control" placeholder="Your city" required>
                        </div>
                        <div class="form-group">
                            <label for="review_title">Country</label>
                            <input type="text" class="form-control" placeholder="Your country" required>
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
  
    <div class="container">
        <section class="py-5">

            <div id="favorite_title" class="jumptarget pb-3">
                <h2>Favorites</h2>
            </div>

            <div class="cards row" id="favorites">

                @if (empty($favorites))
                <div class="mt-3 col-md-4">

                </div>
                <div class="mt-3 col-md-4">
                    <div class="box d-flex flex-column align-items-center">
                        <h5>No favorites to show</h5>
                    </div>
                </div>
                <div class="mt-3 col-md-4">

                </div>
                @else
                @foreach ($favorites as $item)
                <div id={{"favorite-" . $item['id']}} class="mt-3 col-md-5 col-lg-4">
                    <div class="box d-flex flex-column align-items-center">
                        <i class="fas fa-heart ml-auto"></i>
                        <img src="{{asset('imgs/product'.$item['id'].'1.png')}}"  alt="{{$item['name']}}" class="center-block"
                            onclick="window.location='' " style="cursor:pointer;">

                        <h5 id="{{"fav-" . $item['id']}}" class="productName" onclick="window.location='{{url('/product/' . $item['id'])}}'"
                            style="cursor:pointer;">
                            {{$item['name']}}
                        </h5>

                        <span>Price: {{$item['price']}} €</span>
                    </div>
                </div>

                @endforeach
                @endif

            </div>
        </section>
    </div>

    <div class="container">
        <section class="py-5">


            <div id="onhold_title" class="jumptarget">
                <h2>On Hold</h2>
            </div>

            @if (empty($hold))
            <div class="row">
                <div class="col-4"></div>
                <div class="col-4">
                    <h5>No orders on Hold</h5>
                </div>
                <div class="col-4"></div>

            </div>
            @else


            <div class="section-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Status</th>
                            <th scope="col">Total</th>
                        </tr>
                    </thead>
                    <tbody>


                        @foreach ($hold as $item)


                        <tr data-toggle="collapse" data-target={{"#purchase-" . $item['id']}} class="clickable unbold"
                            onclick="boldUnboldLine(this)">
                            <td>
                                <i class="fas fa-circle"></i>
                                {{$item['date']}}</td>
                            <td>{{$item['state']}}</td>
                            <td>{{$item['total']}}</td>
                        </tr>


                        <tr>
                            <td colspan="3" class="collapse-line">
                                <div id={{"purchase-" . $item['id']}} class="collapse-div collapse">
                                    <p class="accordion_list_title">Products</p>
                                    <div class="product_list container">

                                        @foreach ($item['lines'] as $line)

                                        <div class="row">
                                            <p class="col-lg-auto col-md-auto col-sm-auto">{{$line[0]['productName']}}</p>
                                            <hr class="col">
                                            <p class="col-lg-auto col-md-auto col-sm-auto">{{$line[0]['productPrice']}}</p>
                                        </div>
                                        @endforeach


                                    </div>
                                    <p class="accordion_list_title mt-3">Address</p>
                                    <p>{{$item['address']->street}}, {{$item['address']->door_number}}, {{$item['address']->zipcode}} {{$item['city']}}</p>
                                </div>
                            </td>
                        </tr>

                        @endforeach
                    </tbody>

                </table>

            </div>



            @endif
        </section>
    </div>

    <div class="container">
        <section class="py-5">


            <div id="history_title" class="jumptarget">
                <h2>History</h2>
            </div>


            @if (empty($delivered))
            <div class="row">
                <div class="col-4"></div>
                <div class="col-4">
                    <h5> No deliveries</h5>
                </div>
                <div class="col-4"></div>

            </div>
            @else
            <div class="section-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Status</th>
                            <th scope="col">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($delivered as $item)

                        <tr data-toggle="collapse" data-target={{"#purchase-" . $item['id']}} class="clickable unbold"
                            onclick="boldUnboldLine(this)">
                            <td>
                                <i class="fas fa-circle"></i>
                                {{$item['date']}}</td>
                            <td>{{$item['state']}}</td>
                            <td>{{$item['total']}}</td>
                        </tr>

                        <tr>
                            <td colspan="3" class="collapse-line">
                                <div id={{"purchase-" . $item['id']}} class="collapse-div collapse">
                                    <p class="accordion_list_title">Products</p>
                                    <div class="product_list container">

                                        @foreach ($item['lines'] as $lines)
                                        <div class="row">
                                            <p class="col-lg-auto col-md-auto col-sm-auto">{{$lines[0]['productName']}}</p>
                                            <hr class="col">
                                            <p class="col-lg-auto col-md-auto col-sm-auto">{{$lines[0]['productPrice']}}
                                            </p>
                                        </div>
                                    </div>
                                    @endforeach


                                    <p class="accordion_list_title mt-3">Address</p>
                                    <p>{{$item['address']->street}}, {{$item['address']->door_number}}, {{$item['address']->zipcode}} {{$item['city']}}</p>
                                </div>
                            </td>
                        </tr>


                        @endforeach


                    </tbody>
                </table>
            </div>

            @endif


        </section>
    </div>

    <div class="container p-2">
        <div class="container scroll_nav">
            <div class="row float-right">
                <a class="col-lg-auto col-md-auto col-sm-12 text-sm-right">
                    <i class="fas fa-user-times"></i> Delete Account
                </a>
            </div>
        </div>
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
                <p>As a user, on this page, you can <strong>edit your personal details</strong> and <strong>manage your
                        addresses</strong>.</p>
                <p>You can view all your purchases, those bellow <strong>On Hold</strong> are being processed or have
                    just been shipped, once a package is delivered, you can find it under <strong>History</strong>.</p>
                <p>If you click on a particular purchase, you can see all its details.</p>

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

@elseif($user['type_user'] == 'store_manager')

@include('pages.stmanager', $categories)

@else

@include('pages.admin', $categories)

@endif

@endsection