<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Cart;

class User extends Authenticatable
{
    use Notifiable;

    
    // Don't add create and update timestamps in database.
    public $timestamps  = false;


    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id', 'name', 'username' ,'email', 'password', 'type_user', 'deleted', 'remember_token'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

     /**
     * Get the phone record associated with the user.
     */
    public function carts()
    {
        return $this->hasOne('App\Cart','id_user');
    }

    public function addresses(){

        return $this->hasMany('App\Address', 'id_user');
    }

    public function myFavs()
    {
        return $this->hasMany('App\Favorites', 'id_user');
    }

    public function isFav($id){
        
        return empty($this->myFavs()->where('id_product', $id)->first()); 
    }

    public function orders()
    {
        return $this->hasMany('App\Order', 'id_user');
    }
}