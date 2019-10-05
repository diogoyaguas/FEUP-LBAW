<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Reportear extends Model
{
    public $timestamps = false;

    protected $table = 'reportear';
    
    public $primaryKey = 'id_review';

    
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
   protected $fillable = [
     'id_review', 'id_user_reportear'
   ];
}
