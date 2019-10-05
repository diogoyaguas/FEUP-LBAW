<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

  <!-- jQuery first, then Popper.js, then Bootstrap JS -->
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
  </script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous">
  </script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
  </script>
  <link href="https://fonts.googleapis.com/css?family=Quicksand" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">

  <!-- CSRF Token -->
  <meta name="csrf-token" content="{{ csrf_token() }}">

  <title>{{ config('app.name', 'aurora') }}</title>

  <!-- Styles -->
  <link href="{{ asset('css/style.css') }}" rel="stylesheet">
  <link href="{{ asset('css/header.css') }}" rel="stylesheet">

  <script src="{{ asset('js/app.js') }}" defer></script>

  @yield('styles')

  <!-- Scripts -->

  {{ csrf_field() }}

</head>

<body>

  <header class="header_area">
    <div class="main_menu">
      <nav class="navbar navbar-expand-md navbar-light">
        <div class="container pl-0">
          <a class="navbar-brand logo_h d-flex align-items-center" href="{{ route('homepage') }}">
            <img class="float-left mr-3" src="{{asset('imgs/logo.png')}}" alt="img">
            <h1> {{ config('app.name', 'aurora') }}</h1>
          </a>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <i class="fas fa-bars"></i>
          </button>
          <div class="collapse navbar-collapse offset" id="navbarSupportedContent">
            <ul class="nav navbar-nav menu_nav">
              <li class="nav-item submenu dropdown">
                <a href={{url('/products/clothing/all')}} class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Clothing</a>
                <ul class="dropdown-menu float-left">
                  <li>
                    <h3 class="dropdown-header">Men</h3>
                  </li>
                  @foreach ($categories as $item)
                  @if ($item['dad'] == 'Clothing' && $item['sex'] == 'm')
                  <li class="nav-item"><a class="nav-link" href={{url('/products/Man/' . $item['name'])}}>{{$item['name']}}</a></li>

                  @endif
                  @endforeach
                  <li class="nav-item"><a class="nav-link" href={{url('/products/Man/all')}}>Shop All</a></li>
                  <li>
                    <h3 class="dropdown-header">Women</h3>
                  </li>
                  @foreach ($categories as $item)
                  @if ($item['dad'] == 'Clothing' && $item['sex'] == 'w')
                  <li class="nav-item"><a class="nav-link" href={{url('/products/Woman/' . $item['name'])}}>{{$item['name']}}</a></li>

                  @endif
                  @endforeach
                  <li class="nav-item"><a class="nav-link" href={{url('/products/Woman/all')}}>Shop All</a></li>
                </ul>
              </li>
              <li class="nav-item submenu dropdown">
                <a href={{url('/products/House-Decor/all')}} class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">House-Decor</a>
                <ul class="dropdown-menu">
                  @foreach ($categories as $item)
                  @if ($item['dad'] == 'House-Decor' && $item['sex'] == '?')
                  <li class="nav-item"><a class="nav-link" href={{url('/products/House-Decor/' . urlencode($item['name']))}}>{{$item['name']}}</a></li>

                  @endif
                  @endforeach
                  <li class="nav-item"><a class="nav-link" href={{url('/products/House-Decor/all')}}>Shop All</a></li>
                </ul>
              </li>
              <li class="nav-item submenu dropdown">
                <a href={{url('/products/Activities/all')}} class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Activities</a>
                <ul class="dropdown-menu">

                  @foreach ($categories as $item)
                  @if ($item['dad'] == 'Activities' && $item['sex'] == '?')
                  <li class="nav-item"><a class="nav-link" href={{url('/products/Activities/' . $item['name'])}}>{{$item['name']}}</a></li>

                  @endif
                  @endforeach
                  <li class="nav-item"><a class="nav-link" href={{url('/products/Activities/all')}}>Shop All</a></li>
                </ul>
              </li>
            </ul>

            <ul class="nav-shop navbar-nav menu_nav pl-2">
              <li class="nav-item">
                <form class="form-inline md-form form-lg" action="{{url('/search')}}" method="GET">
                  <input class="form-control form-control-md mr-3 w-75" type="text" name="search_key" aria-label="Search" placeholder="Search" required>
                  <i class="fas fa-search" aria-hidden="true"></i>
                </form>
              </li>
              <li class="nav-item">
                @if(Auth::user() != null)
                <a class="nav-link" href="{{ route('cart', ['id' => Auth::user()->carts->id ])}}">
                  <i class="fas fa-shopping-cart"></i>
                </a>
                @endif
              </li>
              @guest
              <li class="nav-item"><a class="nav-link" href="{{ route('login') }}">Login</a></li>
              <li class="nav-item"><a class="nav-link" href="{{ route('register') }}">Register</a></li>
              @else
              <li class="nav-item">
                <a href="{{route('profile')}}" class="nav-link" role="button">


                  <i class="fas fa-user pt-1"></i>
                </a>
              </li>

              <li class="nav-item pt-2 pl-2">

                <a href="{{ route('logout') }}" onclick="event.preventDefault();
                                                   document.getElementById('logout-form').submit();">
                  Logout
                </a>

                <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                  {{ csrf_field() }}
                </form>

              </li>
              @endguest
            </ul>
          </div>
        </div>
      </nav>
    </div>
  </header>

  @yield('content')

  <footer class="footer pt-3">
    <div class="container">
      <div class="row text-center">
        <div class="col">
          <h5 class="header">Information</h5>
          <ul class="list-group links">
            <li class="list-group-item"> <span><a href="{{route('about')}}">About Us</a> </span></li>
          </ul>
        </div>
        <div class="col">
          <h5 class="header">Services</h5>
          <ul class="list-group links">
            <li class="list-group-item"> <span><a href="{{route('faq')}}"> FAQ </a></span></li>
          </ul>
        </div>
      </div>
      <div class="row ">
        <div class="col">
        </div>
        <div class="col">
          <i class="far fa-copyright"></i> <span>copyrigth 2019 aurora. All rigths reserved </span> <br>
        </div>
        <div class="col text-center">
        </div>
      </div>
    </div>
  </footer>
</body>

</html>