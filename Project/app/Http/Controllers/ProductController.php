<?php

namespace App\Http\Controllers;

use App\Product;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

use Illuminate\Http\Request;
use App\Categories;
use App\User;
use App\Review;
use App\Report;
use App\Reportear;
use App\Analyze;
use App\Color;
use App\Size;
use Illuminate\Support\Facades\Input;
use Symfony\Component\HttpFoundation\File\File;

class ProductController extends Controller
{
    public function show($id)
    {

        $product = Product::find($id);

        $reviews = Review::all()->where('id_product', $id);
        $idColors = DB::table('product_color')->where('id_product', $id)->get();
        $idSizes = DB::table('product_size')->where('id_product', $id)->get();


        // Get colors of product
        $colors = array();
        foreach ($idColors as $idColor) {

            $color = Color::find($idColor->id_color);
            array_push($colors, $color);
        }
        $product->colors = $colors;

        // Get sizes of product
        $sizes = array();
        foreach ($idSizes as $idSize) {

            $size = Size::find($idSize->id_size);
            array_push($sizes, $size);
        }
        $product->sizes = $sizes;


        // Get related prodcuts
        $category = DB::table('product_categories')->where('id_product', $id)->get()->toArray();
        $relatedProducts = DB::table('product_categories')->where('id_categories', $category[0]->id_categories)->get()->toArray();

        shuffle($relatedProducts);

        foreach ($relatedProducts as $rp) {

            if ($rp->id_product == $id) {
                $key = array_search($rp, $relatedProducts);
                unset($relatedProducts[$key]);
            }
        }

        $size = sizeof($relatedProducts);
        if ($size < 3) {
            $bestThree = array_rand($relatedProducts, $size);
        } else $bestThree = array_rand($relatedProducts, 3);
        $threeProducts = array();

        foreach ($bestThree as $relatedID) {
            $pid = $relatedProducts[$relatedID]->id_product;
            array_push($threeProducts, Product::find($pid));
        }

        $product->relatedProducts = $threeProducts;

        foreach ($reviews as $review) {
            $userID = $review->id_user;
            $user = User::find($userID);
            $review->name = $user['name'];
        }

        return view('pages.product', ['categories' => Categories::all(), 'product' => $product, 'reviews' => $reviews]);
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(Request $request)
    {
        $customMessages = [
            'required' => 'The :attribute field is required.'
        ];

        return Validator::make($request, [
            'title' => 'bail|required|string|max:255',
            'score' => 'required',
            'description' => 'nullable|string|max:255',
        ], $customMessages);
    }

    /**
     * Create a new review instance after a validation.
     *
     * @param  array  $data
     * @return \App\User
     */
    public function submitReview(Request $request, $id_product)
    {

        $review = new Review();
        $review->id = Review::max('id') + 1;
        $review->id_user = $request->id;
        $review->id_product = $id_product;
        $review->title = $request->title;
        $review->description = $request->description;
        $review->score = $request->score;


        try {
            $review->save();
        } catch (\Illuminate\Database\QueryException $e) {
            $orderLog = new Logger('db');
            $orderLog->pushHandler(new StreamHandler(storage_path('logs/db.log')), Logger::ERROR);
            $orderLog->info('db', ['error' => $e->getMessage()]);
        }

        $review->name = User::find($request->id)['name'];

        return array($review);
    }



    public function store(Request $request)
    {

        $product = new Product;

        $product->id = Product::max('id') + 1;
        $product->name = $request->name;
        $product->price = $request->price;
        $product->description = $request->description;
        $product->stock = $request->stock;

        $product->save();
        $counter = 1;

        foreach (request()->file('image') as $lma) {
            $lma->move(public_path('imgs'), 'product' . $counter . $product->id . "." . $lma->getClientOriginalExtension());
            $counter++;
        }

        return redirect('/profile');
    }

    public function report(Request $request, $reviewId)
    {

        $report = new Report();
        $report->id_review = $reviewId;
        $report->id_user_reportee = $request->reportedID;
        $report->save();

        $reportear =  new Reportear();
        $reportear->id_review = $reviewId;
        $reportear->id_user_reportear = $request->reportID;
        $reportear->save();

        $admins = User::all()->where('type_user', 'admin')->toArray();
        $admin = array_rand($admins, 1);
        $analyze = new Analyze();
        $analyze->id_review = $reviewId;
        $analyze->id_user_analyze = $admins[$admin]['id'];
        $analyze->save();

        return $request;
    }
}
