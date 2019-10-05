<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Size extends Model
{
    protected $table = 'size';
    public $timestamps = false;
    protected $fillable = [
        'id', 'name'
    ];

    public function product()
    {
        return $this->belongsToMany('App\Product', 'product_size', 'id_size', 'id_product');
    }
}
