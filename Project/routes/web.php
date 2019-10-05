<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return redirect('/homepage');
});
Route::get('homepage', 'HomepageController@show')->name('homepage');

Route::get('/about', 'AboutController@about')->name('about');
Route::get('/faq', 'FaqController@show')->name('faq');

Route::get('/profile', 'ProfileController@show')->name('profile');

Route::get('/product/{id}', 'ProductController@show')->name('product');
Route::get('/cart/{id}', 'CartController@show')->name('cart');
Route::post('api/product/{id}/review', 'ProductController@submitReview');
Route::post('api/product/{id}/addToCart', 'CartController@addToCart');
Route::delete('api/line/{idLine}', 'CartController@destroyLine');
Route::post('api/order', 'CartController@order');


Route::get('/products/{category}/{subcategoty}', 'CategoriesController@show');
Route::get('/categories', 'CategoriesController@show')->name('categories');
Route::get('/search', 'CategoriesController@search_products')->name('search');
Route::post('api/products/{category}/{subcategoty}', 'CategoriesController@show');
Route::post('api/search/{id}/review', 'CategoriesController@search_products');
Route::post('api/filter', 'CategoriesController@filterProducts');

Route::group(['prefix' => 'admin', 'namespace' => 'Auth'], function () {
    // Password Reset Routes...
    Route::get('password/reset', 'Auth\ForgotPasswordController@showLinkRequestForm')->name('password.reset');
    Route::post('password/email', 'Auth\ForgotPasswordController@sendResetLinkEmail')->name('password.email');
    Route::get('password/reset/{token}', 'Auth\ResetPasswordController@showResetForm')->name('password.reset.token');
    Route::post('password/reset', 'Auth\ResetPasswordController@reset');
});

Auth::routes();

Route::delete('api/address/{idAddr}', 'AddressController@destroy');
Route::post('api/profile/address', 'AddressController@create');

Route::delete('api/admin/{id}', 'ProfileController@deleteUser');
Route::delete('api/profile/products/{idProduct}', 'ProfileController@deleteFav');
Route::post('api/profile/products/{idProduct}', 'ProfileController@addFav');

Route::post('product/add', 'ProductController@store');
Route::post('/api/report/{reviewID}', 'ProductController@report');
Route::put('api/profile', 'ProfileController@update');
Route::delete('profile/delete', 'ProfileController@delete');
Route::delete('api/review/{reviewID}', 'ProfileController@deleteReview');
Route::post('api/storeManager', 'ProfileController@createEmployee');
