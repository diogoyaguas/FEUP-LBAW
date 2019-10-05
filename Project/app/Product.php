<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    
    public $timestamps = false;

    protected $table = 'product';
    
    public $primaryKey = 'id';

    
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
   protected $fillable = [
     'name', 'price', 'description', 'stock', 'score'
   ];

   


   public function size()
   {
       return $this->belongsToMany('App\Size', 'product_size', 'id_product', 'id_size');
   }


   public function color()
   {
       return $this->belongsToMany('App\Color', 'product_color', 'id_product', 'id_color');
   }

   public function brand()
   {
       return $this->belongsToMany('App\Brand', 'product_brand', 'id_product', 'id_brand');
   }


   public function category()
   {
       return $this->belongsToMany('App\Categories', 'product_categories', 'id_product', 'id_categories');
   }

}
