<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    public function fetchProducts()
    {
        $products = Product::all();
        return response()->json($products);
    }

    public function addProduct(Request $request)
    {
        $data = $request->validate([
            'product_name' => ['required', 'string', 'max:255'],
            'stock' => ['required', 'integer', 'min:0'],
            'price' => ['required', 'numeric', 'min:0'],
            'image' => ['required', 'string', 'max:255'],
            'category' => ['required', 'string', 'in:Smartphones,Laptops,Audio,Headsets'],
        ]);

        $product = Product::create($data);
        return response()->json($product, 201);
    }

    public function updateProduct(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $data = $request->validate([
            'product_name' => ['sometimes', 'string', 'max:255'],
            'stock' => ['sometimes', 'integer', 'min:0'],
            'price' => ['sometimes', 'numeric', 'min:0'],
            'image' => ['sometimes', 'string', 'max:255'],
            'category' => ['sometimes', 'string', 'in:Smartphones,Laptops,Audio,Headsets'],
        ]);

        $product->update($data);
        return response()->json($product);
    }

    public function deleteProduct($id)
    {
        $product = Product::findOrFail($id);
        $product->delete();

        return response()->json([
            'message' => 'Product deleted successfully'
        ]);
    }

    public function getProduct($id)
    {
        $product = Product::findOrFail($id);
        return response()->json($product);
    }
}
