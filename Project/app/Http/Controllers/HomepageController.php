<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Categories;
use App\Product;

class HomepageController extends Controller
{


    public function show()
    {

        // Get featured prodcuts
        $products = Product::all()->where('score', 5)->toArray();

        shuffle($products);
        $randomProducts = array_rand($products, 3);

        $featuredProducts = array();

        foreach ($randomProducts as $product) {
            array_push($featuredProducts, $products[$product]);
        }

        // Get on sale prodcuts
        $products = Product::all()->sortBy('price')->slice(0,25)->toArray();

        shuffle($products);
        $randomProducts = array_rand($products, 3);

        $saleProducts = array();

        foreach ($randomProducts as $product) {
            array_push($saleProducts, $products[$product]);
        }

        return view('pages.homepage', ['categories' => Categories::all(), 'featuredProducts' => $featuredProducts, 'saleProducts' => $saleProducts]);
    }
}
