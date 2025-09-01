<script setup>
import TopNav from '../components/topNav.vue';
import Pagination from '../components/pagination.vue';
import Cart from '../components/Cart.vue';
import { useCartStore } from '../stores/cart';
import { useAuth } from '../composables/useAuth';
import { ref, onMounted, onUnmounted, computed } from 'vue';
import ProductManagementModal from '../components/ProductManagementModal.vue';
import axios from 'axios';

const products = ref([]);
const loading = ref(false);
const error = ref(null);

const selectedCategory = ref('All Categories');
const selectedPriceRange = ref('From $0 - $1000');

const categories = ['All Categories', 'Phones', 'Laptops', 'Headsets', 'Speakers'];
const priceRanges = [
  'From $0 - $1000',
  'From $0 - $500',
  'From $500 - $1000'
];

const fetchProducts = async () => {
  loading.value = true;
  error.value = null;

  try {
    const response = await axios.get('http://localhost:8000/api/products');
    products.value = response.data;
  } catch (error) {
    error.value = 'Failed to fetch products';
    console.error('Error fetching products:', error);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchProducts();
});

onUnmounted(() => {
  cleanup();
});

const cartStore = useCartStore();
const showCart = ref(false);
const showProductManagement = ref(false);

const { isAuthenticated, cleanup, isAdmin } = useAuth();

const addToCart = (product) => {
  if (!isAuthenticated.value) {
    alert('Please login to add items to cart!');
    return;
  }
  
  const success = cartStore.addToCart(product);
  if (success) {
    alert(`${product.product_name} added to cart!`);
  }
};

const filteredProducts = computed(() => {
  let filtered = [...products.value];

  if (selectedCategory.value !== 'All Categories') {
    filtered = filtered.filter(product => 
      product.category && product.category.toLowerCase() === selectedCategory.value.toLowerCase()
    );
  }

  if (selectedPriceRange.value !== 'From $0 - $1000') {
    const priceRange = selectedPriceRange.value;
    
    if (priceRange === 'From $0 - $500') {
      filtered = filtered.filter(product => product.price <= 500);
    } else if (priceRange === 'From $500 - $1000') {
      filtered = filtered.filter(product => product.price > 500 && product.price <= 1000);
    } else if (priceRange === 'From $1000 - $2000') {
      filtered = filtered.filter(product => product.price > 1000 && product.price <= 2000);
    } else if (priceRange === 'From $2000+') {
      filtered = filtered.filter(product => product.price > 2000);
    }
  }

  return filtered;
});

const handleCategoryChange = (event) => {
  selectedCategory.value = event.target.value;
};

const handlePriceChange = (event) => {
  selectedPriceRange.value = event.target.value;
};
</script>

<template>
  <div class="min-h-screen bg-gray-50">
    <TopNav class="py-2"/>
    <div class="px-6 pb-16 mt-96 pt-80 justify-between">
      <!-- header -->
      <div class="max-w-7xl mx-auto mb-12">
        <h1 class="text-4xl font-bold text-gray-800 mb-4">Discover Amazing Gadgets</h1>
        <p class="text-lg text-gray-700 max-w-3xl">
          Looking for the latest tech innovations, trending electronics, or must-have gadgets? 
          From customer favorites to limited-time deals, explore our curated collection of cutting-edge technology.
        </p>
      </div>

      <!-- filter & sort -->
      <div class="max-w-7xl mx-auto mb-8">
        <div class="flex flex-wrap gap-4 items-center">
          <!-- category -->
          <div class="relative">
            <select 
              v-model="selectedCategory"
              @change="handleCategoryChange"
              class="appearance-none bg-white border border-gray-300 rounded-lg px-4 py-3 pr-10 text-gray-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent"
            >
              <option v-for="category in categories" :key="category" :value="category">
                {{ category }}
              </option>
            </select>
            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
              <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
              </svg>
            </div>
          </div>

          <!-- price filter -->
          <div class="relative">
            <select 
              v-model="selectedPriceRange"
              @change="handlePriceChange"
              class="appearance-none bg-white border border-gray-300 rounded-lg px-4 py-3 pr-10 text-gray-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent"
            >
              <option v-for="range in priceRanges" :key="range" :value="range">
                {{ range }}
              </option>
            </select>
            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
              <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
              </svg>
            </div>
          </div>

          <div class="text-sm text-gray-600">
            Showing {{ filteredProducts.length }} of {{ products.length }} products
          </div>

            <div class="relative ml-auto flex gap-3">
              <!-- Admin Product Management Button -->
              <button 
                v-if="isAdmin" 
                @click="showProductManagement = true" 
                class="inline-flex items-center gap-2 appearance-none bg-purple-600 text-white border border-purple-600 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent hover:bg-purple-700 transition-colors duration-200"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4"></path>
                </svg>
                Manage Products
              </button>
              
              <button @click="showCart = true" class="inline-flex items-center gap-2 appearance-none bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent">
                <svg class="w-5 h-5 text-gray-700" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 4h1.5L9 16m0 0h8m-8 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm8 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm-8.5-3h9.25L19 7H7.312"/>
                </svg>
                Cart
                <span v-if="cartStore.totalItems > 0" class="bg-purple-600 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                  {{ cartStore.totalItems }}
                </span>
              </button>
            </div>
        </div>
      </div>

      <!-- product grid -->
      <div class="max-w-7xl mx-auto">
        <div v-if="filteredProducts.length === 0 && !loading" class="text-center py-12">
          <div class="text-gray-500 text-lg mb-4">No products found matching your filters</div>
          <button 
            @click="selectedCategory = 'All Categories'; selectedPriceRange = 'From $0 - $1000'"
            class="px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors duration-200"
          >
            Clear Filters
          </button>
        </div>

        <!-- loading state -->
        <div v-else-if="loading" class="text-center py-12">
          <div class="text-gray-500 text-lg">Loading products...</div>
        </div>

        <!-- products grid -->
        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div v-for="product in filteredProducts" :key="product.id" class="bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow duration-200">
            <div class="relative">
              <div class="bg-gray-200 h-64 rounded-t-lg flex items-center justify-center">
                <img
                  :src="`/images/${product.image}`" 
                  :alt="product.product_name" 
                  class="w-full h-full object-cover rounded-t-lg"
                />
              </div>
            </div>
            <div class="p-4">
              <h3 class="font-semibold text-gray-800 mb-1">{{ product.product_name }}</h3>
              <p class="text-sm text-gray-600 mb-2">Stock: {{ product.stock }}</p>
              <p class="text-lg font-bold text-gray-800">${{ product.price }}</p>
              
              <button 
                @click="addToCart(product)"
                :disabled="product.stock <= 0 || !isAuthenticated"
                class="w-full mt-3 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors duration-200"
              >
                {{ !isAuthenticated ? 'Login to Add' : (product.stock > 0 ? 'Add to Cart' : 'Out of Stock') }}
              </button>
            </div>
          </div>
        </div>
      </div>

      <Pagination class="mt-6"/>
    </div>

    <!-- cart modal-->
    <Cart v-if="showCart" @close="showCart = false" />
    
    <!-- Product Management Modal -->
    <ProductManagementModal 
      v-if="showProductManagement" 
      @close="showProductManagement = false"
      @refresh="fetchProducts"
    />
  </div>
</template>
