<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Line_item extends Model
{
    public $timestamps = false;

    protected $primaryKey = 'id';
    protected $table = 'line_item';

     /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id', 'id_product', 'quantity', 'price'
    ];


    public function product()
    {
        return $this->belongsTo('App\Product', 'id_product');
    }

    public function lineOrders()
    {
        return $this->hasMany('App\Line_item_order', 'id_line_item');
    }

    public function lineCart()
    {
        return $this->hasMany('App\Line_item_cart','id_line_item');
    }


}
