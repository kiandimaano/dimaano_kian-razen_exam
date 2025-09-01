<template>
    <div class="h-screen w-screen flex items-center justify-center p-4 bg-gradient-to-br from-dark-900 via-dark-800 to-dark-700">
      <div class="max-w-md w-full space-y-2 bg-gradient-to-br from-purplebug-100 via-purplebug-50 to-white p-8 rounded-2xl shadow-2xl border border-purplebug-200">
        <!-- Header -->
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
            Create an account
          </p>
        </div>
  
        <!-- Login Form -->
        <form class="space-y-6" @submit.prevent="handleRegister">
          <div class="space-y-4">
            <!-- Name Input -->
            <div class="flex flex-row gap-2">
              <div class="flex-1">
                <label for="firstName" class="text-sm font-semibold text-dark-800 mb-2">
                    First Name
                </label>
                <input
                    id="firstName"
                    name="firstName"
                    type="text"
                    required
                    class="w-full mb-2 px-4 py-3 border-2 border-purplebug-200 placeholder-dark-400 text-dark-900 bg-white rounded-lg focus:outline-none focus:ring-2 focus:ring-purplebug-500 focus:border-purplebug-500 transition-all duration-200 hover:border-purplebug-300"
                    v-model="firstName"
                    placeholder="Enter your first name"
                />
                <p class="text-sm text-red-500" v-if="firstNameError">{{ firstNameError }}</p>
              </div>
              <div class="flex-1">
                <label for="lastName" class="text-sm font-semibold text-dark-800 mb-2">
                    Last Name
                </label>
                <input
                    id="lastName"
                    name="lastName"
                    type="text"
                    required
                    class="w-full px-4 py-3 border-2 border-purplebug-200 placeholder-dark-400 text-dark-900 bg-white rounded-lg focus:outline-none focus:ring-2 focus:ring-purplebug-500 focus:border-purplebug-500 transition-all duration-200 hover:border-purplebug-300"
                    v-model="lastName"
                    placeholder="Enter your last name"
                />
                <p class="text-sm text-red-500" v-if="lastNameError">{{ lastNameError }}</p>
              </div>
            </div>
            <!-- Email Input -->
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
              <p class="text-sm text-red-500" v-if="emailError">{{ emailError }}</p>
            </div>
  
            <!-- Password Input -->
            <div>
              <label for="password" class="block text-sm font-semibold text-dark-800 mb-2">
                Password
              </label>
              <input
                id="password"
                name="password"
                type="password"
                required
                class="w-full mb-2 px-4 py-3 border-2 border-purplebug-200 placeholder-dark-400 text-dark-900 bg-white rounded-lg focus:outline-none focus:ring-2 focus:ring-purplebug-500 focus:border-purplebug-500 transition-all duration-200 hover:border-purplebug-300"
                v-model="password"
                placeholder="Enter your password"
              />
              <p class="text-sm text-red-500" v-if="passwordError">{{ passwordError }}</p>
              <label for="confirmPassword" class="block text-sm font-semibold text-dark-800 mb-2">
                Confirm Password
              </label>
              <input
                id="confirmPassword"
                name="confirmPassword"
                type="password"
                required
                class="w-full px-4 py-3 border-2 border-purplebug-200 placeholder-dark-400 text-dark-900 bg-white rounded-lg focus:outline-none focus:ring-2 focus:ring-purplebug-500 focus:border-purplebug-500 transition-all duration-200 hover:border-purplebug-300"
                v-model="confirmPassword"
                placeholder="Confirm your password"
              />
              <p class="text-sm text-red-500" v-if="confirmPasswordError">{{ confirmPasswordError }}</p>
            </div>
          </div>
  
          <!-- Login Button -->
          <div>
            <button
                type="submit"
                class="w-full py-3 px-4 border border-transparent text-sm font-semibold rounded-lg text-white bg-purplebug-600 hover:from-purplebug-700 hover:to-purplebug-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purplebug-500 transition-all duration-200 transform hover:scale-105 shadow-lg"
                :disabled="isLoading"
              >
                {{ isLoading ? 'Registering...' : 'Register Account' }}
            </button>
          </div>
  
          <!-- Sign Up Link -->
          <div class="text-center">
            <p class="text-sm text-dark-600">
              Already have an account?
              <a href="/login" class="font-semibold text-purplebug-600 hover:text-purplebug-700 transition-colors duration-200">
                Sign in
              </a>
            </p>
          </div>
        </form>
      </div>
    </div>
  </template>

<script setup>
    import { ref } from 'vue';
    import { useRouter } from 'vue-router';
    import axios from 'axios';

    const router = useRouter();

    const firstName = ref('');
    const lastName = ref('');
    const email = ref('');
    const password = ref('');
    const confirmPassword = ref('');
    const isLoading = ref(false);
    const errorMessage = ref('');
    const successMessage = ref('');
    const firstNameError = ref('');
    const lastNameError = ref('');
    const emailError = ref('');
    const passwordError = ref('');
    const confirmPasswordError = ref('');

    const validateFirstName = () => {
        if (!firstName.value) {
            firstNameError.value = 'First name is required';
            return false;
        } else {
            firstNameError.value = '';
            return true;
        }
    };

    const validateLastName = () => {
        if (!lastName.value) {
            lastNameError.value = 'Last name is required';
            return false;
        } else {
            lastNameError.value = '';
            return true;
        }
    };

    const validateEmail = () => {
        if (!email.value) {
            emailError.value = 'Email is required';
            return false;
        } else if ((!/\S+@\S+\.\S+/.test(email.value))) {
            emailError.value = 'Please enter a valid email address.';
            return false;
        } else {
            emailError.value = '';
            return true;
        }
    };

    const validatePassword = () => {
        if (!password.value) {
            passwordError.value = 'Password is required';
            return false;
        } else if (password.value.length < 8) {
            passwordError.value = 'Password must be at least 8 characters long';
            return false;
        } else {
            passwordError.value = '';
            return true;
        }
    };

    const validateConfirmPassword = () => {
        if (!confirmPassword.value) {
            confirmPasswordError.value = 'Please confirm your password';
            return false;
        } else if (password.value !== confirmPassword.value) {
            confirmPasswordError.value = 'Passwords do not match';
            return false;
        } else {
            confirmPasswordError.value = '';
            return true;
        }
    };

    const handleRegister = async () => {
        errorMessage.value = '';
        successMessage.value = '';
        firstNameError.value = '';
        lastNameError.value = '';
        emailError.value = '';
        passwordError.value = '';
        confirmPasswordError.value = '';

        isLoading.value = true;

        const isFirstNameValid = validateFirstName();
        const isLastNameValid = validateLastName();
        const isEmailValid = validateEmail();
        const isPasswordValid = validatePassword();
        const isConfirmPasswordValid = validateConfirmPassword();

        if (!isFirstNameValid || !isLastNameValid || !isEmailValid || !isPasswordValid || !isConfirmPasswordValid) {
            isLoading.value = false;
            return;
        }

        try {
            const response = await axios.post('http://127.0.0.1:8000/api/register', {
                firstName: firstName.value,
                lastName: lastName.value,
                email: email.value,
                password: password.value,
                passwordConfirmation: confirmPassword.value,
            });

            const { token, user } = response.data;

            localStorage.setItem('auth_token', token);
            localStorage.setItem('user', JSON.stringify(user));
            
            axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;

            successMessage.value = 'Registration successful';

            setTimeout(() => {
                alert(successMessage.value);
                router.push('/login');
            }, 1500);
        } catch (error) {
            if (error.response?.status === 422) {
                errorMessage.value = 'Invalid email or password';
            } else if (error.response?.status === 401) {
                errorMessage.value = 'Authentication failed';
            } else {
                errorMessage.value = 'An error occurred';
            }
        } finally {
            isLoading.value = false;
        }
    }
</script>
