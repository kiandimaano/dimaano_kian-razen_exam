<template>
  <div class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4 max-h-[80vh] overflow-y-auto">
      
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-bold text-gray-800">Shopping Cart</h2>
        <button @click="$emit('close')" class="text-gray-500 hover:text-gray-700">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- cart -->
      <div v-if="cartStore.items.length === 0" class="text-center py-8">
        <p class="text-gray-500">Your cart is empty</p>
      </div>

      <div v-else class="space-y-4">
        <div v-for="item in cartStore.items" :key="item.id" class="flex items-center space-x-3 p-3 border rounded-lg">
          <img :src="`/images/${item.image}`" :alt="item.name" class="w-16 h-16 object-cover rounded">
          
          <div class="flex-1">
            <h3 class="font-semibold text-gray-800">{{ item.name }}</h3>
            <p class="text-gray-600">${{ item.price }}</p>
          </div>

          <div class="flex items-center space-x-2">
            <button @click="cartStore.updateQuantity(item.id, item.quantity - 1)" 
                    class="w-8 h-8 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"></path>
              </svg>
            </button>
            
            <span class="w-8 text-center font-semibold">{{ item.quantity }}</span>
            
            <button @click="cartStore.updateQuantity(item.id, item.quantity + 1)" 
                    class="w-8 h-8 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
              </svg>
            </button>
          </div>

          <button @click="cartStore.removeFromCart(item.id)" class="text-red-500 hover:text-red-700">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
            </svg>
          </button>
        </div>
      </div>

      <div v-if="isAuthenticated && cartStore.items.length > 0" class="border-t pt-4 mt-4">
        <div class="text-sm text-gray-600 mb-2">
          <span class="font-semibold">Customer:</span> {{ user.firstName }} {{ user.lastName }}
        </div>
      </div>

      <div v-if="cartStore.items.length > 0" class="border-t pt-4 mt-4">
        <div class="flex justify-between items-center mb-4">
          <span class="font-semibold">Total:</span>
          <span class="font-bold text-xl">${{ cartStore.totalPrice.toFixed(2) }}</span>
        </div>
        
        <div class="flex space-x-3">
          <button @click="cartStore.clearCart()" 
                  class="flex-1 bg-gray-500 text-white py-2 px-4 rounded-lg hover:bg-gray-600">
            Clear Cart
          </button>
          <button @click="checkout" 
                  :disabled="loading || !isAuthenticated"
                  class="flex-1 bg-purple-600 text-white py-2 px-4 rounded-lg hover:bg-purple-700 disabled:bg-gray-400 disabled:cursor-not-allowed">
            {{ loading ? 'Processing...' : (isAuthenticated ? 'Checkout' : 'Login to Checkout') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useCartStore } from '../stores/cart'
import { useAuth } from '../composables/useAuth'
import axios from 'axios'
import { ref } from 'vue'

const cartStore = useCartStore()
const { user, isAuthenticated } = useAuth()
const loading = ref(false)

const emit = defineEmits(['close'])

const checkout = async () => {
  if (cartStore.items.length === 0) {
    alert('Cart is empty!')
    return
  }

  if (!isAuthenticated.value) {
    alert('Please login to checkout!')
    return
  }

  loading.value = true

  try {
    const customerName = `${user.value.firstName} ${user.value.lastName}`.trim()
    
    if (!customerName) {
      alert('User name not found. Please try logging in again.')
      return
    }

    const orderData = {
      customer_name: customerName,
      user_id: user.value.id,
      items: cartStore.items.map(item => ({
        product_id: item.id,
        quantity: item.quantity
      }))
    }

    const response = await axios.post('http://localhost:8000/api/orders', orderData)
    
    alert('Order placed successfully!')
    cartStore.clearCart()
    emit('close')
    
  } catch (error) {
    console.error('Checkout error:', error)
    alert(error.response?.data?.message || 'Failed to place order')
  } finally {
    loading.value = false
  }
}
</script>
