<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Country extends Model
{
   
    protected $table = 'country';
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
       'id', 'name'
   ];


   /**
    * The users that belong to the role.
    */
   public function users()
   {
       return $this->belongsToMany('App\User', 'id_user');
   }

   public function cities(){
       return $this->hasOne('App\Country', 'id_city');
   }
    
}
