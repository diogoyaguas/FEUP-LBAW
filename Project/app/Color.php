<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Color extends Model
{
    protected $table = 'color';
    public $timestamps = false;
    protected $fillable = [
        'id', 'name'
    ];


    public function product()
    {
        return $this->belongsToMany('App\Product', 'product_color', 'id_color', 'id_product');
    }

}
