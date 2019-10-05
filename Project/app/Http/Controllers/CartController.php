<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Product;
use App\Cart;
use App\Categories;
use App\Line_item_cart;
use App\User;
use App\Line_item;
use App\Order;
use App\Line_item_order;

class CartController extends Controller
{
    public function show($id)
    {
        $line_item = array();
        $cart = Cart::find($id);
        $line_item_cart = Line_item_cart::all()->where('id_cart', $id);
        $all_lines = array();
        foreach ($line_item_cart as $p) {
            $line_item = $p->line()->get()->toArray();
            $all_lines = array_merge($all_lines, $line_item);
        }

        $t = array();
        $i = 0;
        $total = 0;
        foreach ($all_lines as $l) {
            $product = Product::find($l['id_product']);
            $name = $product['name'];
            $all_lines[$i]['name'] = $name;
            $all_lines[$i]['single_price'] = $product['price'];
            $total += $l['price'];
            $i++;
        }

        return view('pages.cart', ['categories' => Categories::all(), 'lines' => $all_lines, 'product' => $t, 'total' => $total]);
    }

    public function addToCart(Request $request, $id_product)
    {
        $line_item = new Line_item();
        $line_item->id = Line_item::max('id') + 1;
        $line_item->id_product = $request->productID;
        $line_item->quantity = $request->productQuantity;
        $line_item->price = $request->productPrice;
        $line_item->save();

        $line_item_cart = new Line_item_cart();
        $line_item_cart->id_line_item = $line_item->id;
        $line_item_cart->id_cart = User::find($request->id)->carts->id;
        $line_item_cart->save();

        return $line_item_cart;
    }

    public function destroyLine(Request $request, $idLine)
    {

        $line_item_cart = Line_item_cart::find($idLine);
        $line_item_cart->delete();

        $line_item = Line_item::find($idLine);
        $line_item->delete();

        return $request;
    }

    public function order(Request $request)
    {

        $order = new Order();
        $order->id = Order::max('id') + 1;
        $order->id_user = $request->idUser;
        $order->id_address_invoce = $request->invoiceAddress;
        if (!is_null($request->addressId)) {
            $order->id_address_shipping = $request->addressId;
        }
        $order->total = $request->total;
        $order->state = 'Processing';
        $order->save();

        $lines = explode(",", $request->lines);

        foreach ($lines as $line) {

            $line_item_order = new Line_item_order();
            $line_item_order->id_line_item = $line;
            $line_item_order->id_order = $order->id;
            $line_item_order->save();

            $line_item_cart = Line_item_cart::find($line);
            $line_item_cart->delete();
        }

        return $request;
    }
}
