<?php

namespace App\Http\Controllers;
use App\Categories;

use Illuminate\Http\Request;

class AboutController extends Controller
{
    public function about()
    {
        return view('pages.about',['categories' => Categories::all()]);
    }
}

