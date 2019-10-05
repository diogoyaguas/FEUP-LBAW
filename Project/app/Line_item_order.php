<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Line_item_order extends Model
{
    public $timestamps = false;
    protected $table = 'line_item_order';

    protected $primaryKey = 'id_line_item';

     /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id_line_item', 'id_order'
    ];



    public function order()
    {
        return $this->belongsTo('App\Order', 'id_order');
   
    }

    public function line()
    {
        return $this->belongsTo('App\Line_item', 'id_line_item');
    }
}

