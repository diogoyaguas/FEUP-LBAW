<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Categories;

class FaqController extends Controller
{
    public function show()
    {
        return view('pages.faq', ['categories' => Categories::all()]);
    }
}
