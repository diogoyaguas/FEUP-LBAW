<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    public $timestamps = false;


    protected $table = 'order';

    protected $primaryKey = 'id';

     /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id', 'id_user', 'date', 'total', 'state'
    ];


    public function user()
    {
        return $this->belongsTo('App\User', 'id_user');
    }


    public function lines()
    {
        return $this->hasMany('App\Line_item_order', 'id_order');
    }
}
