<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ProductBrand extends Model
{
    public $timestamps = false;

    protected $table = 'product_brand';
    
    public $primaryKey = 'id_product';

    
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
   protected $fillable = [
     'id_product', 'id_brand'
   ];

}
