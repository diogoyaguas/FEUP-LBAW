<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ProductSize extends Model
{
    public $timestamps = false;

    protected $table = 'product_size';
    
    public $primaryKey = 'id_product';

    
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
   protected $fillable = [
     'id_product', 'id_size'
   ];
}
