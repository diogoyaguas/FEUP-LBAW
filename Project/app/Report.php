<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Report extends Model
{
    public $timestamps = false;

    protected $table = 'report';
    
    public $primaryKey = 'id_review';

    
    /**
    * The attributes that are mass assignable.
    *
    * @var array
    */
   protected $fillable = [
     'id_review', 'id_user_reportee'
   ];

}
