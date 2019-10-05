<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class City extends Model
{
    protected $table = 'city';
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
        'id', 'id_country', 'name'
    ];


    /**
     * The users that belong to the role.
     */
    public function users()
    {
        return $this->belongsToMany('App\User', 'id_user');
    }

    public function countries(){
        return $this->hasOne('App\Country', 'id_country');
    }

    public function cities()
    {
        return $this->belongsTo('App\Address', 'id_city');
    }
}
