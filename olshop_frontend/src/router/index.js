import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import LoginView from '../views/LoginView.vue';
import RegisterView from '../views/RegisterView.vue';
import OManageView from '../views/OManageView.vue';
import UManageView from '../views/UManageView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/login'
    },
    {
      path: '/home',
      name: 'home',
      component: HomeView,
      meta: { requiresAuth: true }
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: { requiresGuest: true }
    },
    {
      path: '/register',
      name: 'register',
      component: RegisterView,
      meta: { requiresGuest: true }
    },
    {
      path: '/order-management',
      name: 'order-management',
      component: OManageView,
      meta: { requiresAuth: true }
    },
    {
      path: '/manage-user',
      name: 'manage-user',
      component: UManageView,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
  ],
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('auth_token');
  const user = JSON.parse(localStorage.getItem('user') || 'null');
  const isAdmin = user && user.userType === 'admin';

  // If user is authenticated and trying to access login/register, redirect to home
  if (to.meta.requiresGuest && isAuthenticated) {
    next('/home');
    return;
  }

  // If user is not authenticated and trying to access protected routes, redirect to login
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login');
    return;
  }

  // If user is not admin and trying to access admin routes, redirect to home
  if (to.meta.requiresAdmin && !isAdmin) {
    next('/home');
    return;
  }

  next();
});

export default router;
