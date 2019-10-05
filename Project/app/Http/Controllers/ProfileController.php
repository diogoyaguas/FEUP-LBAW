<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\User;
use App\Address;
use App\City;
use App\Country;
use App\Product;
use App\Categories;
use App\Favorites;
use Illuminate\Support\Facades\Auth;
use SebastianBergmann\CodeCoverage\Report\Xml\Facade;
use Validator;
use App\Analyze;
use App\Review;
use App\Report;
use App\Reportear;

class ProfileController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function show()
    {

        $user = User::find(Auth::id());

        $address = $user->addresses()->get();

        $favs = $user->myFavs()->get();
        $prodFaves = array();

        foreach ($favs as $v) {

            $product = Product::find($v['id_product']);
            array_push($prodFaves, $product);
        }

        $orders = $user->orders()->get();

        $delivered = array();
        $hold = array();
        $addresses = $address->toArray();
        if ($user->type_user == 'user' || $user->type_user == 'premium') {

            foreach ($addresses as &$value) {
                $array = City::where('id', $value['id_city'])->get()->toArray()[0];
                $value['city'] = $array['name'];
                $value['country'] = Country::where('id', $array['id_country'])->get()->toArray()[0]['name'];
            }


            foreach ($orders as &$order) {

                $lines_order = $order->lines()->get();
                $lines = array();
                foreach ($lines_order as &$line_order) {
                    $line = $line_order->line()->first();
                    $l = array();

                    $product = Product::find($line['id_product'], ['name', 'price']);

                    array_push($l, ['productPrice' => $product['price'], 'productName' => $product['name'], 'price' => $line['price'], 'quantity' => $line['quantity']]);
                    array_push($lines, $l);
                }
                $order->address = Address::find($order->id_address_invoce);
                $order->city = City::find($order->address->id_city)['name'];
                $order['lines'] = $lines;
                if ($order['state'] == 'Delivered') array_push($delivered, $order);
                else array_push($hold, $order);
            }
        }
        $employees = array();
        $users = null;
        $allReviews = null;

        if ($user->type_user == 'admin') {

            $employees = User::all()->where('type_user', 'store_manager');
            $users = User::all()->where('type_user', 'user');
            $reviews = Analyze::all()->where('id_user_analyze', $user->id);

            $allReviews = array();
            foreach ($reviews as $r) {
                $review = Review::find($r->id_review);
                $reviewUser = User::find($review->id_user);
                $review->username = $reviewUser->name;
                array_push($allReviews, $review);
            }
        }

        return view('pages.profile', ['employees' => $employees, 'categories' => Categories::all(), 'user' => $user, 'addresses' => $addresses, 'favorites' => $prodFaves, 'delivered' => $delivered, 'hold' => $hold, 'users' => $users, 'reviews' => $allReviews]);
    }

    public function deleteFav($idProduct)
    {
        //this->authorize();
        $idUser = Auth::user()->id;
        $deleted = Favorites::remove($idUser, $idProduct);

        if ($deleted == 1) return $idProduct;
        else return $deleted;
    }

    public function addFav($idProduct){

        $idUser = Auth::user()->id;
       
        $add = new Favorites;

        $add->id_product = $idProduct;
        $add->id_user = $idUser;

        return $add->save();
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Address  $address
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {

        $user = Auth::user();

        $validator = Validator::make(
            $request->all(),
            [
                'name' => 'required|string|max:255',
                'username' => 'required|string|max:255',
                'email' => 'required|string|email|max:255',
                'password' => 'required|string',
            ]
        );



        if ($validator->fails()) {

            return response()->json(['errors' => $validator->errors()]);
        }

        if ($request->newpassword != "") {
            if (Hash::check($request->password, $user->id)) {
                $user->password = bcrypt($request->newpassword);
            }
        }

        $user->name = $request->name;
        $user->username = $request->username;
        $user->email = $request->email;

        $user->save();

        return $user;
    }

    public function deleteUser(Request $request, $id)
    {

        $user = User::find($id);
        $user->delete();

        return $id;
    }

    public function delete()
    {

        $user = Auth::user();

        Auth::logout();

        if ($user->delete()) {
            return "true";
        }
        return "false";
    }

    public function deleteReview(Request $request, $reviewID)
    {
        $reportee = Report::find($reviewID);
        $reportear = Reportear::find($reviewID);
        $analyze = Analyze::find($reviewID);

        if ($reportee !== null)
            $reportee->delete();
        if ($reportear !== null)
            $reportear->delete();
        if ($analyze !== null)
            $analyze->delete();

        return $reviewID;
    }

    public function createEmployee(Request $request)
    {

        $password = bcrypt($request->userPassword);
        $user = User::find($request->idUser);

        $newUser = new User();
        $newUser->id = User::max('id') + 1;
        $str = $newUser->id;
        $newUser->username = "storeManager" . $str;
        $newUser->name = $request->employeeName;
        $newUser->email = $newUser->username . "@aurora.pt";
        $newUser->password = bcrypt($newUser->username);
        $newUser->type_user = 'store_manager';
        $newUser->save();

        return array($newUser->id, $newUser->name);
    }
}
