@extends('layouts.app', ['categories' => $categories])

@section('styles')
<link href="{{ asset('css/login.css') }}" rel="stylesheet">
    
@endsection


@section('content')


<div class="container mt-5">
        <div class="d-flex justify-content-center">
          <div class="card">
            <div class="card-header">
              <h3>Register</h3>
              <div class="d-flex justify-content-end social_icon">
              </div>
            </div>
            <div class="card-body">
              <form method="POST" action="{{ route('register') }}">
                    {{ csrf_field() }}
               
                <div class="input-group form-group{{ $errors->has('name') ? ' has-error' : '' }}">
                  <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                  </div>
                  <input type="text" class="form-control" placeholder="name" name ="name" value="{{ old('name') }}" required autofocus>

                  @if ($errors->has('name'))
                  <span class="help-block">
                      <strong>{{ $errors->first('name') }}</strong>
                  </span>
              @endif
                </div>

                <div class="input-group form-group{{ $errors->has('username') ? ' has-error' : '' }}">
                        <div class="input-group-prepend">
                          <span class="input-group-text"><i class="fas fa-user-tag"></i></i></span>
                        </div>
                        <input type="text" class="form-control" placeholder="username" name ="username" value="{{ old('username') }}" required>
      
                        @if ($errors->has('username'))
                        <span class="help-block">
                            <strong>{{ $errors->first('username') }}</strong>
                        </span>
                    @endif
                      </div>

                <div class="input-group form-group {{ $errors->has('email') ? ' has-error' : '' }}">
                  <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                  </div>
                  <input type="email" class="form-control" placeholder="email" name="email" value="{{ old('email') }}" required>
                  @if ($errors->has('email'))
                  <span class="help-block">
                      <strong>{{ $errors->first('email') }}</strong>
                  </span>
              @endif
                </div>
    
    
                <div class="input-group form-group{{ $errors->has('password') ? ' has-error' : '' }}">
                  <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fas fa-key"></i></span>
                  </div>
                  <input type="password" class="form-control" name="password" id="inputPassword" placeholder="password" required>
                 
                  @if ($errors->has('password')) 
                  <span class="help-block">
                      <strong>{{ $errors->first('password') }}</strong>
                  </span>
              @endif
                </div>
    
                <div class="input-group form-group">
                  <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fas fa-key"></i></span>
                  </div>
                  <input type="password" class="form-control" name="password_confirmation" id="inputPasswordConfirm" placeholder="confirm password">
                  <div class="help-block with-errors"></div>
                </div>
    
                <script>
                  var password = document.getElementById("inputPassword"),
                    confirm_password = document.getElementById("inputPasswordConfirm");
    
                  function validatePassword() {
                    if (inputPassword.value != inputPasswordConfirm.value) {
                      inputPasswordConfirm.setCustomValidity("Passwords Don't Match");
                    } else {
                      inputPasswordConfirm.setCustomValidity('');
                    }
                  }
    
                  inputPassword.onchange = validatePassword;
                  inputPasswordConfirm.onkeyup = validatePassword;
                  </script>
    
                <div class="row align-items-center remember">
                </div>
                <div class="form-group">
                  <input type="submit" value="Submit" class="btn float-right login_btn">
                </div>
              </form>
            </div>
            <div class="card-footer">
            </div>
          </div>
        </div>
      </div>
    

@endsection
