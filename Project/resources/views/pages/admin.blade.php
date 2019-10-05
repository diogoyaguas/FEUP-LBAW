<script src="{{url('js/admin.js')}}" defer></script>

<input type="hidden" id="userId" value={{Auth::user()->id}}>

<div class="mt-1">
    <nav aria-label="breadcrumb" id="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/homepage">Homepage</a></li>
            <li class="breadcrumb-item active" aria-current="page">Administrator</li>

        </ol>
    </nav>
</div>

<div class="container">
    <div class="container scroll_nav">
        <div class="row">
            <h1 class="col-lg col-md col-sm-12">
                Administrator Area
            </h1>
            <a href="#employees_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Manage Employees
            </a>
            <a href="#employees_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Manage Users
            </a>
            <a href="#reports_title" class="col-lg-auto col-md-auto col-sm-6 text-sm-center">
                <i class="fas fa-arrow-alt-circle-right"></i>
                Reports
            </a>
        </div>
    </div>
</div>

<main>
    <div class="container">

        <section class="py-5" id="employees-section">

            <div id="employees_title" class="jumptarget">
                <div class="cards row">
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-left justify-content-left">
                        <div class="box d-flex flex-column last-card">
                            <h2>Manage Employees</h2>
                        </div>
                    </div>
                    <div class="col-md-6 col-xl-6 ml-auto d-flex align-items-center justify-content-end">
                        <div id="addAlterButton" class="box d-flex flex-column last-card" data-toggle="modal"
                            data-target="#addManagerModal">
                            &#10010; Add Employees
                        </div>
                    </div>
                </div>
            </div>

            <div class="cards row" id="listEmployees">
                @foreach ($employees as $employee)
                <div class="mt-4 col-md-6 col-lg-3" id="user{{$employee['id']}}">
                    <div class="box d-flex flex-column">
                        <i class="fas fa-trash-alt ml-auto employees" onclick="sendDeleteUser({{$employee['id']}})"></i>
                        <div class="d-flex flex-row address-header">
                            <i class="fas fa-user-tie pr-1"></i>
                            <h6>{{$employee['name']}}</h6>
                        </div>
                        <h6>Store Manager</h6>
                    </div>
                </div>

                @endforeach
            </div>

        </section>
    </div>

    <div class="modal fade" id="addManagerModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Add Manager</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="addStoreManager">
                    <div class="modal-body section-container mt-0">
                        <div class="form-group">
                            <label for="review_title">Name</label>
                            <input type="text" class="form-control" placeholder="Employee Name">
                        </div>
                        <div class="form-group">
                            <label for="review_title">Password</label>
                            <input type="password" class="form-control" placeholder="Your password" required>
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

        <section class="py-5" id="profile-section">

            <div id="employees_title" class="jumptarget">
                <h2>Manage Users</h2>
            </div>

            <div class="cards row">
                @foreach ($users as $user)
                <div class="mt-4 col-md-6 col-lg-3" id="user{{$user['id']}}">
                    <div class="box d-flex flex-column">
                        <i class="fas fa-trash-alt ml-auto" onclick="sendDeleteUser({{$user['id']}})"></i>
                        <div class="d-flex flex-row address-header">
                            <i class="fas fa-user pr-1"></i>
                            <h6>{{$user['name']}}</h6>
                        </div>
                        <h6>Regular User</h6>
                    </div>
                </div>
                @endforeach
            </div>

        </section>
    </div>

    <div class="container">
        <section class="py-5">

            <div id="reports_title" class="jumptarget pb-3">
                <h2>Reports</h2>
            </div>

            <div class="section-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Type</th>
                            <th scope="col">Username</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($reviews as $review)
                        <tr data-toggle="collapse" data-target="#report{{$review['id']}}" class="clickable unbold"
                            onclick="boldUnboldLine(this)" name="report-{{$review['id']}}">
                            <td><i class="fas fa-circle mr-2"></i>Review</td>
                            <td>{{$review['username']}}</td>
                            <td>
                                <i class="fas fa-check-circle p-1" onclick="sendReviewDelete({{$review['id']}})"></i>
                                <i class="fas fa-user-lock p-1"
                                    onclick="sendDeleteUserReview({{$review['id_user']}}, {{$review['id']}})"></i>
                            </td>
                        </tr>
                        <tr name="report-{{$review['id']}}">
                            <td colspan="4" class="collapse-line">
                                <div id="report{{$review['id']}}" class="collapse-div collapse">
                                    <div class="information_list container">
                                        <div class="row"
                                            onclick="window.location='/product/{{$review['id_product']}}/#review-{{$review['id']}}'"
                                            style="cursor:pointer;">
                                            <h6>
                                                {{$review['description']}}
                                            </h6>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>

<script>
    $(document).ready(function () {
            $('.fa-exclamation-triangle').popover({
                content: "Warning User",
                trigger: "hover",
                placement: "top"
            });
            $('.fa-check-circle').popover({
                content: "Marks as resolved",
                trigger: "hover",
                placement: "top"
            });
            $('.fa-user-lock').popover({
                content: "Block User",
                trigger: "hover",
                placement: "top"
            });
        });
</script>