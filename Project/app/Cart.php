<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{

 protected $table = "cart";
  
 protected $updated_at = false;
 protected $created_at = "date";

     /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id', 
    ];




    public function user(){
        return $this->belongsTo('App\User', 'id_user');
    }
    
}
