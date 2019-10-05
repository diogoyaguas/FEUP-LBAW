<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Categories extends Model
{
    public $timestamps = false;

    protected $table = 'categories';



    protected $fillable = [
        'id', 'name', 'sex', 'season', 'dad'
    ];

    

    public function product()
    {
        return $this->belongsToMany('App\Product', 'product_categories', 'id_categories', 'id_product');
    }
}
