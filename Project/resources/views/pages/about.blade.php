@extends('layouts.app', ['categories' => $categories])


@section('styles')

<link href="{{ asset('css/about.css') }}" rel="stylesheet">

@endsection


@section('content')

<div class="mt-1">
  <nav aria-label="breadcrumb" id="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="index.html">Homepage</a></li>
      <li class="breadcrumb-item active" aria-current="page">About Us</li>
    </ol>
  </nav>
</div>

<div class="container">
  <div class="container scroll_nav">
    <div class="row">


      <h1 class="col-lg col-md col-sm-12">
        About Us
      </h1>


      <a href="#information_title" class="col-lg-auto col-md-auto col-sm-12 text-sm-center">
        <i class="fas fa-arrow-alt-circle-right"></i>
        Information
      </a>
      <a href="#contacts_title" class="col-lg-auto col-md-auto col-sm-12 text-sm-center">
        <i class="fas fa-arrow-alt-circle-right"></i>
        Contacts
      </a>
      <a href="#team_title" class="col-lg-auto col-md-auto col-sm-12 text-sm-center">
        <i class="fas fa-arrow-alt-circle-right"></i>
        The Team
      </a>

    </div>
  </div>
</div>

<main class="py-5">
  <div class="container">
    <div class="row">
      <div class="col-lg-6 pr-5">
        <section class="mt-4" id="information-section">

          <div id="information_title" class="jumptarget">
            <h2>Information</h2>
          </div>

          <div class="section-container pt-3">
            <p class="text-justify">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et
              dolore magna aliqua. Vel risus commodo viverra maecenas accumsan lacus vel. Nibh tellus molestie nunc
              non
              blandit massa enim nec. Non nisi est sit amet facilisis magna etiam tempor. Porta nibh venenatis cras
              sed.
              Ac turpis egestas maecenas pharetra convallis posuere morbi. In aliquam sem fringilla ut morbi
              tincidunt.
              Id leo in vitae turpis. Fusce ut placerat orci nulla pellentesque dignissim enim sit amet. Cursus in
              hac
              habitasse platea dictumst quisque sagittis. Nunc non blandit massa enim nec. Amet consectetur
              adipiscing
              elit ut aliquam purus sit amet luctus.
            </p>
            <p class="text-justify">
              Egestas integer eget aliquet nibh praesent tristique. Libero justo laoreet sit amet cursus sit amet
              dictum.
              Sed ullamcorper morbi tincidunt ornare massa. Nisi vitae suscipit tellus mauris a diam maecenas. Justo
              donec enim diam vulputate ut pharetra sit amet aliquam. Nunc sed id semper risus in hendrerit gravida
              rutrum. Nibh tellus molestie nunc non blandit. Neque sodales ut etiam sit amet nisl. Nulla at volutpat
              diam
              ut venenatis tellus in metus vulputate. Et ultrices neque ornare aenean euismod elementum nisi quis.
              Convallis aenean et tortor at risus.
            </p>
          </div>
        </section>
      </div>
      <div class="col-xl pl-5">
        <section class="mt-4" id="contacts-section">

          <div id="contacts_title" class="jumptarget">
          </div>

          <div class="container contact">
            <div class="row">
              <div class="col-xl-12">
                <div class="contact-info">
                  <img src="https://image.ibb.co/kUASdV/contact-image.png" alt="image" />
                  <h2>Contact Us</h2>
                  <h4>We would love to hear from you !</h4>
                </div>
              </div>
              <div class="col-lg-12 pt-3">
                <div class="contact-form">
                  <div class="form-group">
                    <label class="control-label col-sm-4" for="fname">First Name:</label>
                    <div class="col-sm-10">
                      <input type="text" class="form-control" id="fname" placeholder="Enter First Name" name="fname">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-sm-4" for="lname">Last Name:</label>
                    <div class="col-sm-10">
                      <input type="text" class="form-control" id="lname" placeholder="Enter Last Name" name="lname">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-sm-4" for="email">Email:</label>
                    <div class="col-sm-10">
                      <input type="email" class="form-control" id="email" placeholder="Enter email" name="email">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-sm-4" for="comment">Comment:</label>
                    <div class="col-sm-10">
                      <textarea class="form-control" rows="3" id="comment"></textarea>
                    </div>
                  </div>
                  <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                      <button type="submit" class="btn btn-default">Submit</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </section>
      </div>
    </div>
  </div>


  <div class="container">

    <section class="py-5" id="team-section">

      <div id="team_title" class="jumptarget pb-3">
        <h2>The Team</h2>
      </div>

      <div class="row" id="team">
        <div class="mt-3 col-md-5 col-lg-3">
          <div class="box d-flex flex-column align-items-center">
            <img src="imgs/2.jpg" alt="product_image" class="center-block">
            <h5 id="memberName1">Daniel Gomes</h5>
          </div>
        </div>
        <div class="mt-3 col-md-5 col-lg-3">
          <div class="box d-flex flex-column align-items-center">
            <img src="{{asset('imgs/1.jpg')}}" alt="product_image" class="center-block">
            <h5 id="memberName2">Carolina Azevedo</h5>
          </div>
        </div>
        <div class="mt-3 col-md-5 col-lg-3">
          <div class="box d-flex flex-column align-items-center">
            <img src="{{asset('imgs/3.jpg')}}" alt="product_image" class="center-block">
            <h5 id="memberName3">Diogo Yaguas</h5>
          </div>
        </div>
        <div class="mt-3 col-md-5 col-lg-3">
          <div class="box d-flex flex-column align-items-center">
            <img src="{{asset('imgs/4.jpg')}}" alt="product_image" class="center-block">
            <h5 id="memberName4">Gonçalo Bernardo</h5>
          </div>
        </div>
      </div>
    </section>
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
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">What's the purpose of this page?</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      <p><strong>Any questions</strong> outside of the range bolstered by “Frequently Asked Questions” page can be submitted to our company <strong>via a dedicated area for that purpose.</strong></p>
      <p>Users should be able to communicate with us in order to <strong>increase the natural degree of interactions</strong> between buyers and our company.</p>
      </div>
      <div class="modal-footer">
        <div class="container">
      <div class="modal-body">
      <span><a href="{{route('faq')}}"> More Questions?  </a></span> </div></div>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Got it, thanks!</button>
      </div>
    </div>
  </div>
</div>


@endsection