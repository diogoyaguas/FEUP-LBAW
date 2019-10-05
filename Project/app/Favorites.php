<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class Favorites extends Model
{
    public $timestamps = false;
    protected $autoincrement = false;
    protected $primaryKey = 'id_user';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id_user', 'id_product'
    ];


    public function users()
    {

        return $this->belongsTo('App\User', 'id_user');
    }


    public static function remove($id, $idp)
    {

       return DB::table('favorites')->where('id_user',$id)->where('id_product', $idp)->delete();

    }
}
