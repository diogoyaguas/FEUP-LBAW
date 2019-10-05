<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Categories;
use App\Brand;
use App\Size;
use App\Color;
use App\Product;
use Illuminate\Support\Facades\Input;
use App\ProductBrand;
use App\ProductColor;
use App\ProductSize;

class CategoriesController extends Controller
{
    public function show($category, $subcategory)
    {

        $category = urldecode($category);
        $subcategory = urldecode($subcategory);

        
        if ($subcategory == 'all') {

            if ($category == 'Man' || $category == 'Woman')
                $categories = Categories::all()->where('sex', lcfirst($category)[0]);
            else
                $categories = Categories::all()->where('dad', $category);
        } else {

            if ($category == 'Man' || $category == 'Woman')
                $categories = Categories::all()->where('sex', lcfirst($category[0]))->where('name', $subcategory);
            else
                $categories = Categories::all()->where('dad', $category)->where('name', $subcategory);
        }
        $temp = array();

        foreach ($categories as $cat) {

            $products = $cat->product()->get()->toArray();

            $temp = array_merge($temp, $products);
        }


        
        $counter = 1;
        $pall = array();
        $on3 = array();
        foreach ($temp as $elem) {

            $brand = ProductBrand::all()->where('id_product', $elem['id']);
            $color = ProductColor::all()->where('id_product', $elem['id']);
            $size = ProductSize::all()->where('id_product', $elem['id']);

            $elem['brand'] = $brand;
            $elem['color'] = $color;
            $elem['size'] = $size;

            if ($counter % 4 == 0) {
                array_push($pall, $on3);
                $on3 = array();
                $counter = 1;
            } else {
                $counter++;
                array_push($on3, $elem);
            }
        }

        array_push($pall, $on3);

        $category[0] = strtoupper($category[0]);

        return view('pages.categories', ['categories' => Categories::all(), 'brands' => Brand::all(), 'colors' => Color::all(), 'sizes' => Size::all(), 'products' => $pall, 'name' => $category, 'subname' => $subcategory]);
    }



    public function search_products()
    {
        try{
            $search_key = Input::get('search_key');

            $search_products = Product::whereRaw("name @@ plainto_tsquery('" . $search_key . "')")->get()->toArray();

        }catch(\Illuminate\Database\QueryException $e){
            $orderLog = new Logger('db');
            $orderLog->pushHandler(new StreamHandler(storage_path('logs/db.log')), Logger::ERROR);
            $orderLog->info('db', ['error'=>$e->getMessage()]);
        }

        $counter = 1;
        $pall = array();
        $on3 = array();
        foreach ($search_products as $elem) {

            if ($counter % 4 == 0) {
                array_push($pall, $on3);
                $on3 = array();
                $counter = 1;
            } else {
                $counter++;
                array_push($on3, $elem);
            }
        }

        array_push($pall, $on3);

        return view('pages.categories', ['categories' => Categories::all(), 'brands' => Brand::all(), 'colors' => Color::all(), 'sizes' => Size::all(),'subname' => $search_key,'search_key' => $search_key, 'products' => $pall]);
    }
}
