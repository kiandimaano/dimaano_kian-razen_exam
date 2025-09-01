<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\Product;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'customer_name' => 'required|string|max:255',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        try {
            DB::beginTransaction();

            $orders = [];

            foreach ($request->items as $item) {
                $product = Product::find($item['product_id']);

                if ($product->stock < $item['quantity']) {
                    throw new \Exception("Insufficient stock for {$product->product_name}");
                }

                $order = Order::create([
                    'customer_name' => $request->customer_name,
                    'image' => $product->image,
                    'product_name' => $product->product_name,
                    'price' => $product->price,
                    'stock' => $product->stock,
                    'quantity' => $item['quantity'],
                    'status' => 'Pending',
                    'user_id' => $request->user()->id
                ]);

                $product->decrement('stock', $item['quantity']);

                $orders[] = $order;
            }

            DB::commit();

            return response()->json([
                'message' => 'Orders created successfully',
                'orders' => $orders
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Failed to create orders',
                'error' => $e->getMessage()
            ], 400);
        }
    }

    public function fetchOrders(Request $request)
    {
        $user = $request->user();

        if ($user->userType === 'admin') {
            $orders = Order::orderBy('order_id', 'desc')->get();
        } else {
            $orders = Order::where('user_id', $user->id)
                ->orderBy('order_id', 'desc')
                ->get();
        }

        return response()->json($orders);
    }

    public function updateStatus(Request $request, $orderId)
    {
        $user = $request->user();

        if ($user->userType !== 'admin') {
            return response()->json([
                'message' => 'Access denied. Only administrators can update order status.'
            ], 403);
        }

        $request->validate([
            'status' => 'required|in:Pending,For Delivery,Delivered,Canceled'
        ]);

        $order = Order::findOrFail($orderId);
        $order->update(['status' => $request->status]);

        return response()->json([
            'message' => 'Order status updated successfully',
            'order' => $order
        ]);
    }
}
