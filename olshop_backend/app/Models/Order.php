<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $primaryKey = 'order_id';
    public $incrementing = true;
    public $timestamps = false;

    protected $fillable = [
        'customer_name',
        'image',
        'product_name',
        'price',
        'stock',
        'quantity',
        'status',
        'user_id'
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'quantity' => 'integer',
        'stock' => 'integer',
        'user_id' => 'integer',
    ];

    /**
     * Get the user that placed the order.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
