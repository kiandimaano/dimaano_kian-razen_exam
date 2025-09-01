<template>
    <nav class="bg-purplebug-800 border-purplebug-700 dark:bg-purplebug-900 w-full fixed top-0 left-0 right-0 z-10">
        <div class="w-full flex flex-wrap items-center justify-between px-4 py-4">
            <span class="self-center text-2xl font-semibold whitespace-nowrap text-white">PurpleBug</span>
            
            <button @click="toggleMobileMenu" class="md:hidden inline-flex items-center p-2 w-10 h-10 text-sm text-white rounded-lg hover:bg-purplebug-700 focus:outline-none focus:ring-2 focus:ring-purplebug-300">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                </svg>
            </button>

            <div class="hidden md:flex md:order-2">
                <button @click="handleLogout" type="button" class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-purplebug-600 rounded-lg hover:bg-purplebug-700 focus:outline-none focus:ring-2 focus:ring-purplebug-300">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                    </svg>
                    Logout
                </button>
            </div>

            <div :class="['items-center justify-between w-full md:flex md:w-auto md:order-1', mobileMenuOpen ? 'flex' : 'hidden']" id="navbar-search">
                <ul class="flex flex-col p-4 md:p-0 mt-4 font-medium border border-purplebug-200 rounded-lg bg-purplebug-50 md:space-x-8 rtl:space-x-reverse md:flex-row md:mt-0 md:border-0 md:bg-transparent dark:bg-purplebug-800 md:dark:bg-transparent dark:border-purplebug-700">
                    <li>
                        <RouterLink to="/home" class="block py-2 px-3 text-purplebug-200 rounded-sm hover:bg-purplebug-700 md:hover:bg-transparent md:hover:text-purplebug-300 md:p-0 md:dark:hover:text-purplebug-300 dark:text-purplebug-200 dark:hover:bg-purplebug-700 dark:hover:text-white md:dark:hover:bg-transparent dark:border-purplebug-700">Products</RouterLink>
                    </li>
                    <li>
                        <RouterLink to="/order-management" class="block py-2 px-3 text-purplebug-200 rounded-sm hover:bg-purplebug-700 md:hover:bg-transparent md:hover:text-purplebug-300 md:p-0 md:dark:hover:text-purplebug-300 dark:text-purplebug-200 dark:hover:bg-purplebug-700 dark:hover:text-white md:dark:hover:bg-transparent dark:border-purplebug-700">
                            {{ isAdmin ? 'Order Management' : 'My Orders' }}
                        </RouterLink>
                    </li>
                    <li v-if="isAdmin">
                        <RouterLink to="/manage-user" class="block py-2 px-3 text-purplebug-200 rounded-sm hover:bg-purplebug-700 md:hover:bg-transparent md:hover:text-purplebug-300 md:p-0 dark:text-purplebug-200 md:dark:hover:text-purplebug-300 dark:hover:bg-purplebug-700 dark:hover:text-white md:dark:hover:bg-transparent dark:border-purplebug-700">User Management</RouterLink>
                    </li>
                </ul>
                
                <!-- mobile layout -->
                <div class="md:hidden mt-4">
                    <button @click="handleLogout" type="button" class="w-full inline-flex items-center justify-center px-4 py-2 text-sm font-medium text-white bg-purplebug-600 rounded-lg hover:bg-purplebug-700 focus:outline-none focus:ring-2 focus:ring-purplebug-300">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                        </svg>
                        Logout
                    </button>
                </div>
            </div>
        </div>
    </nav>
</template>

<script setup>
import { ref } from 'vue';
import { RouterLink } from 'vue-router';
import axiosInstance from '../lib/http.js';
import { useAuth } from '../composables/useAuth';

const { logout, isAdmin } = useAuth();
const mobileMenuOpen = ref(false);

const toggleMobileMenu = () => {
    mobileMenuOpen.value = !mobileMenuOpen.value;
};

const handleLogout = async () => {
    try {
        const token = localStorage.getItem('auth_token');
        
        if (token) {
            await axiosInstance.post('/logout', {});
        }
        
        logout();
        
    } catch (error) {
        console.error('Logout error:', error);
        
        logout();
    }
};
</script>
