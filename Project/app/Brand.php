<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Brand extends Model
{
    
    protected $table = 'brand';
    public $timestamps = false;
    protected $fillable = [
        'id', 'name'
    ];

    

}
