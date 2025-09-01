<template>
  <div class="h-screen w-screen flex items-center justify-center p-4 bg-gradient-to-br from-dark-900 via-dark-800 to-dark-700">
    <div class="max-w-md w-full space-y-6 bg-gradient-to-br from-purplebug-100 via-purplebug-50 to-white p-12 rounded-2xl shadow-2xl border border-purplebug-200">
      <div class="text-center">
        <div class="flex items-center justify-center">
          <h2 class="text-4xl font-bold text-purplebug-800 mb-2 font-inter">
            Purple
          </h2>
          <h2 class="text-4xl font-bold text-gray-400 mb-2 font-inter">
            Bug
          </h2>
        </div>
        <p class="text-dark-600 text-lg">
          Sign in to your account
        </p>
      </div>

      <form class="space-y-6" @submit.prevent="handleLogin">
        <div class="space-y-4">
          
          <div>
            <label for="email" class="block text-sm font-semibold text-dark-800 mb-2">
              Email Address
            </label>
            <input
              id="email"
              name="email"
              type="email"
              required
              class="w-full px-4 py-3 border-2 border-purplebug-200 placeholder-dark-400 text-dark-900 bg-white rounded-lg focus:outline-none focus:ring-2 focus:ring-purplebug-500 focus:border-purplebug-500 transition-all duration-200 hover:border-purplebug-300"
              v-model="email"
              placeholder="Enter your email"
            />
          </div>

          <div>
            <label for="password" class="block text-sm font-semibold text-dark-800 mb-2">
              Password
            </label>
            <input
              id="password"
              name="password"
              type="password"
              required
              class="w-full px-4 py-3 border-2 border-purplebug-200 placeholder-dark-400 text-dark-900 bg-white rounded-lg focus:outline-none focus:ring-2 focus:ring-purplebug-500 focus:border-purplebug-500 transition-all duration-200 hover:border-purplebug-300"
              v-model="password"
              placeholder="Enter your password"
            />
          </div>
        </div>

        <div v-if="errorMessage" class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
          {{ errorMessage }}
        </div>

        <div v-if="successMessage" class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg">
          {{ successMessage }}
        </div>

        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <input
              id="remember-me"
              name="remember-me"
              type="checkbox"
              class="h-4 w-4 text-purplebug-600 focus:ring-purplebug-500 border-purplebug-300 rounded"
            />
            <label for="remember-me" class="ml-2 block text-sm text-dark-700">
              Remember me
            </label>
          </div>
        </div>

        <div>
          <button
            type="submit"
            class="w-full py-3 px-4 border border-transparent text-sm font-semibold rounded-lg text-white bg-purplebug-600 hover:from-purplebug-700 hover:to-purplebug-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purplebug-500 transition-all duration-200 transform hover:scale-105 shadow-lg"
            :disabled="isLoading"
          >
            {{ isLoading ? 'Signing in...' : 'Sign in' }}
          </button>
        </div>

        <div class="text-center">
          <p class="text-sm text-dark-600">
            Don't have an account?
            <a href="/register" class="font-semibold text-purplebug-600 hover:text-purplebug-700 transition-colors duration-200">
              Sign up
            </a>
          </p>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
  import { ref, onUnmounted } from 'vue';
  import { useRouter } from 'vue-router';
  import axios from 'axios';
  import { useAuth } from '../composables/useAuth';

  const router = useRouter();
  const { login, cleanup } = useAuth();

  const email = ref('');
  const password = ref('');
  const isLoading = ref(false);
  const errorMessage = ref('');
  const successMessage = ref('');

  const handleLogin = async () => {
    errorMessage.value = '';
    successMessage.value = '';

    isLoading.value = true;

    try {
      const response = await axios.post('http://localhost:8000/api/login', {
        email: email.value,
        password: password.value,
      });

      const { token, user } = response.data;

      login(user, token);

      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;

      successMessage.value = 'Login successful';

      setTimeout(() => {
        router.push('/home');
      }, 1500);
    } catch (error) {
      if (error.response?.status === 422) {
        errorMessage.value = 'Invalid email or password';
      } else if (error.response?.status === 423) {
        errorMessage.value = error.response.data.message;
      } else if (error.response?.status === 401) {
        errorMessage.value = 'Authentication failed';
      } else {
        errorMessage.value = 'An error occurred';
      }
    } finally {
      isLoading.value = false;
    }
  };

  onUnmounted(() => {
    cleanup();
  });
</script>