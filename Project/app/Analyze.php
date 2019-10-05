<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Analyze extends Model
{
    public $timestamps = false;

    protected $table = 'analyze';
    
    public $primaryKey = 'id_review';

    
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
   protected $fillable = [
     'id_review', 'id_user_analyze'
   ];
}
