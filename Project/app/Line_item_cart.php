<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Line_item_cart extends Model
{
    public $timestamps = false;
    protected $table = 'line_item_cart';

    protected $primaryKey = 'id_line_item';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id_line_item', 'id_cart'
    ];

    public function cart()
    {
        return $this->belongsTo('App\Cart', 'id_cart');
   
    }

    public function line()
    {
        return $this->belongsTo('App\Line_item', 'id_line_item');
    }



}
