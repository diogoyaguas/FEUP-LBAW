<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    protected $table = 'review';
    
     /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

     /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id', 'id_user', 'id_product', 'title', 'description', 'score'
    ];

    /**
     * The users that belong to the role.
     */
    public function users()
    {
        return $this->hasOne('App\User', 'id_user');
    }


    public function product(){
        return $this->hasOne('App\Product', 'id_product');
    }
}
