<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ProductColor extends Model
{
    public $timestamps = false;

    protected $table = 'product_color';
    
    public $primaryKey = 'id_product';

    
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
   protected $fillable = [
     'id_product', 'id_color'
   ];
}
