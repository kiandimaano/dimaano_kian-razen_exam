<template>
  <div class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-lg p-6 max-w-4xl w-full mx-4 max-h-[90vh] overflow-y-auto relative">
      <div v-if="loading" class="absolute inset-0 bg-white bg-opacity-75 flex items-center justify-center z-10 rounded-lg">
        <div class="text-center">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-purple-600 mx-auto mb-4"></div>
          <p class="text-gray-600">Processing...</p>
        </div>
      </div>
     
      <div class="flex justify-between items-center mb-6">
        <div>
          <h2 class="text-2xl font-bold text-gray-800">Product Management</h2>
          <p class="text-sm text-green-600 font-medium mt-1">Admin Access Required</p>
        </div>
        <div class="flex items-center space-x-3">
          <button 
            @click="fetchProducts" 
            :disabled="loading"
            class="inline-flex items-center gap-2 px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors duration-200"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
            </svg>
            Refresh
          </button>
          <button @click="$emit('close')" class="text-gray-500 hover:text-gray-700">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>
        </div>
      </div>

      <div v-if="successMessage" class="mb-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded-lg">
        {{ successMessage }}
      </div>
      <div v-if="errorMessage" class="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded-lg">
        {{ errorMessage }}
      </div>

      <div class="mb-6">
        <button 
          @click="showAddForm = true; editingProduct = null"
          class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors duration-200"
        >
          + Add New Product
        </button>
      </div>

      <div v-if="showAddForm || editingProduct" class="mb-6 p-4 border rounded-lg bg-gray-50">
        <h3 class="text-lg font-semibold mb-4">
          {{ editingProduct ? 'Edit Product' : 'Add New Product' }}
        </h3>
        
        <form @submit.prevent="validateAndSubmit" class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Product Name</label>
              <input 
                v-model="productForm.product_name" 
                type="text" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
              >
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
              <select 
                v-model="productForm.category" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
              >
                <option value="">Select Category</option>
                <option value="Smartphones">Smartphones</option>
                <option value="Laptops">Laptops</option>
                <option value="Audio">Audio</option>
                <option value="Headsets">Headsets</option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Price</label>
              <input 
                v-model="productForm.price" 
                type="number" 
                step="0.01" 
                min="0" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
              >
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Stock</label>
              <input 
                v-model="productForm.stock" 
                type="number" 
                min="0" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
              >
            </div>
            
            <div class="md:col-span-2">
              <label class="block text-sm font-medium text-gray-700 mb-1">Image Filename</label>
              <input 
                v-model="productForm.image" 
                type="text" 
                required
                placeholder="e.g., product1.jpg"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
              >
            </div>
            
            <div class="md:col-span-2">
              <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
              <textarea 
                v-model="productForm.description" 
                rows="3"
                placeholder="Enter product description..."
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
              ></textarea>
            </div>
          </div>
          
          <div class="flex space-x-3">
            <button 
              type="submit" 
              :disabled="loading"
              class="bg-purple-600 text-white px-6 py-2 rounded-lg hover:bg-purple-700 disabled:bg-gray-400 transition-colors duration-200"
            >
              {{ loading ? 'Saving...' : (editingProduct ? 'Update Product' : 'Add Product') }}
            </button>
            <button 
              type="button" 
              @click="cancelForm"
              class="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 transition-colors duration-200"
            >
              Cancel
            </button>
          </div>
        </form>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full bg-white border border-gray-200 rounded-lg">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Image</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stock</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr v-for="product in products" :key="product.id" class="hover:bg-gray-50">
              <td class="px-4 py-3">
                <img 
                  :src="`/images/${product.image}`" 
                  :alt="product.product_name" 
                  class="w-16 h-16 object-cover rounded"
                >
              </td>
              <td class="px-4 py-3 text-sm font-medium text-gray-900">{{ product.product_name }}</td>
              <td class="px-4 py-3 text-sm text-gray-500">{{ product.category }}</td>
              <td class="px-4 py-3 text-sm text-gray-500">${{ product.price }}</td>
              <td class="px-4 py-3 text-sm text-gray-500">{{ product.stock }}</td>
              <td class="px-4 py-3 text-sm text-gray-500 max-w-xs truncate" :title="product.description">
                {{ product.description || 'No description' }}
              </td>
              <td class="px-4 py-3 text-sm text-gray-500">
                <div class="flex space-x-2">
                  <button 
                    @click="editProduct(product)"
                    class="text-blue-600 hover:text-blue-800 transition-colors duration-200"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H5a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                    </svg>
                  </button>
                  <button 
                    @click="confirmDelete(product)"
                    class="text-red-600 hover:text-red-800 transition-colors duration-200"
                  >
                    <svg class="w-5 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="products.length === 0 && !loading" class="text-center py-8">
        <p class="text-gray-500">No products found. Add your first product to get started!</p>
      </div>

      <div v-if="loading" class="text-center py-8">
        <p class="text-gray-500">Loading products...</p>
      </div>
    </div>
    
    <div v-if="showDeleteConfirm" class="fixed inset-0 bg-black bg-opacity-50 z-60 flex items-center justify-center p-4">
      <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        <div class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
            <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
            </svg>
          </div>
          <h3 class="text-lg font-medium text-gray-900 mb-2">Delete Product</h3>
          <p class="text-sm text-gray-500 mb-6">
            Are you sure you want to delete "<strong>{{ productToDelete?.product_name }}</strong>"? 
            This action cannot be undone.
          </p>
          <div class="flex space-x-3 justify-center">
            <button 
              @click="cancelDelete"
              class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition-colors duration-200"
            >
              Cancel
            </button>
            <button 
              @click="deleteProduct"
              class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors duration-200"
            >
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useAuth } from '../composables/useAuth'
import axios from 'axios'

const emit = defineEmits(['close', 'refresh'])

const { token, isAdmin } = useAuth()

if (!isAdmin.value) {
  emit('close')
}

watch(isAdmin, (newValue) => {
  if (!newValue) {
    emit('close')
  }
})

const products = ref([])
const loading = ref(false)
const showAddForm = ref(false)
const editingProduct = ref(null)
const successMessage = ref('')
const errorMessage = ref('')
const showDeleteConfirm = ref(false)
const productToDelete = ref(null)
const productForm = ref({
  product_name: '',
  category: '',
  price: '',
  stock: '',
  image: '',
  description: ''
})

const fetchProducts = async () => {
  if (!isAdmin.value || !token.value) {
    showError('Access denied. Admin privileges required.')
    emit('close')
    return
  }
  
  loading.value = true
  try {
    const response = await axios.get('http://localhost:8000/api/products')
    products.value = response.data
  } catch (error) {
    console.error('Error fetching products:', error)
    showError('Failed to fetch products')
  } finally {
    loading.value = false
  }
}

const addProduct = async () => {
  if (!isAdmin.value || !token.value) {
    showError('Access denied. Admin privileges required.')
    emit('close')
    return
  }
  
  loading.value = true
  try {
    const response = await axios.post('http://localhost:8000/api/products', productForm.value, {
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Accept': 'application/json'
      }
    })
    
    products.value.push(response.data)
    resetForm()
    showSuccess('Product added successfully!')
    emit('refresh')
  } catch (error) {
    console.error('Error adding product:', error)
    if (error.response?.status === 403) {
      showError('Access denied. Admin privileges required.')
    } else {
      showError(error.response?.data?.message || 'Failed to add product')
    }
  } finally {
    loading.value = false
  }
}

const updateProduct = async () => {
  if (!isAdmin.value || !token.value) {
    showError('Access denied. Admin privileges required.')
    emit('close')
    return
  }
  
  loading.value = true
  try {
    const response = await axios.put(`http://localhost:8000/api/products/${editingProduct.value.id}`, productForm.value, {
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Accept': 'application/json'
      }
    })
    
    const index = products.value.findIndex(p => p.id === editingProduct.value.id)
    if (index !== -1) {
      products.value[index] = response.data
    }
    
    resetForm()
    showSuccess('Product updated successfully!')
    emit('refresh')
  } catch (error) {
    console.error('Error updating product:', error)
    if (error.response?.status === 403) {
      showError('Access denied. Admin privileges required.')
    } else {
      showError(error.response?.data?.message || 'Failed to update product')
    }
  } finally {
    loading.value = false
  }
}

const editProduct = (product) => {
  editingProduct.value = product
  showAddForm.value = false
  productForm.value = {
    product_name: product.product_name,
    category: product.category,
    price: product.price,
    stock: product.stock,
    image: product.image,
    description: product.description || ''
  }
}

const confirmDelete = (product) => {
  productToDelete.value = product
  showDeleteConfirm.value = true
}

const deleteProduct = async () => {
  if (!isAdmin.value || !token.value) {
    showError('Access denied. Admin privileges required.')
    emit('close')
    return
  }
  
  if (!productToDelete.value) return
  
  loading.value = true
  try {
    await axios.delete(`http://localhost:8000/api/products/${productToDelete.value.id}`, {
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Accept': 'application/json'
      }
    })
    
    products.value = products.value.filter(p => p.id !== productToDelete.value.id)
    showSuccess('Product deleted successfully!')
    emit('refresh')
  } catch (error) {
    console.error('Error deleting product:', error)
    if (error.response?.status === 403) {
      showError('Access denied. Admin privileges required.')
    } else {
      showError(error.response?.data?.message || 'Failed to delete product')
    }
  } finally {
    loading.value = false
    showDeleteConfirm.value = false
    productToDelete.value = null
  }
}

const cancelDelete = () => {
  showDeleteConfirm.value = false
  productToDelete.value = null
}

const showSuccess = (message) => {
  successMessage.value = message
  setTimeout(() => {
    successMessage.value = ''
  }, 3000)
}

const showError = (message) => {
  errorMessage.value = message
  setTimeout(() => {
    errorMessage.value = ''
  }, 5000)
}

const validateAndSubmit = () => {
  successMessage.value = ''
  errorMessage.value = ''
  
  if (productForm.value.price <= 0) {
    showError('Price must be greater than 0')
    return
  }
  
  if (productForm.value.stock < 0) {
    showError('Stock cannot be negative')
    return
  }
  
  if (!productForm.value.image.trim()) {
    showError('Image filename is required')
    return
  }
  
  if (editingProduct.value) {
    updateProduct()
  } else {
    addProduct()
  }
}

const cancelForm = () => {
  resetForm()
}

const resetForm = () => {
  productForm.value = {
    product_name: '',
    category: '',
    price: '',
    stock: '',
    image: '',
    description: ''
  }
  showAddForm.value = false
  editingProduct.value = null
}

onMounted(() => {
  if (!isAdmin.value || !token.value) {
    showError('Access denied. Admin privileges required.')
    emit('close')
    return
  }
  
  fetchProducts()
})
</script>

