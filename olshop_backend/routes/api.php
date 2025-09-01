<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserManagementController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\OrderController;

Route::middleware(['auth:sanctum', 'check.account.status'])->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

//routes for admin
Route::middleware(['auth:sanctum', 'check.account.status', 'admin'])->group(function () {
    Route::get('/users', [UserManagementController::class, 'index']);
    Route::post('/users', [UserManagementController::class, 'store']);
    Route::put('/users/{id}', [UserManagementController::class, 'update']);
    Route::delete('/users/{id}', [UserManagementController::class, 'destroy']);
    Route::put('/users/{id}/deactivate', [UserManagementController::class, 'deactivateGuest']);
    Route::put('/users/{id}/reactivate', [UserManagementController::class, 'reactivateGuest']);
    Route::put('/orders/{orderId}/status', [OrderController::class, 'updateStatus']);
    Route::post('/products', [ProductController::class, 'addProduct']);
    Route::put('/products/{id}', [ProductController::class, 'updateProduct']);
    Route::delete('/products/{id}', [ProductController::class, 'deleteProduct']);
    Route::get('/products/{id}', [ProductController::class, 'getProduct']);
});

//routes for non-admin
Route::middleware(['auth:sanctum', 'check.account.status'])->group(function () {
    Route::get('/products', [ProductController::class, 'fetchProducts']);
    Route::post('/orders', [OrderController::class, 'store']);
    Route::get('/orders', [OrderController::class, 'fetchOrders']);
});
