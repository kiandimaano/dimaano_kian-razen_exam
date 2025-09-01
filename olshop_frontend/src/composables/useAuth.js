import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';

export function useAuth() {
    const router = useRouter();
    let inactivityTimer = null;
    const INACTIVITY_TIMEOUT = 1800000;

    const user = ref(JSON.parse(localStorage.getItem('user') || 'null'));
    const token = ref(localStorage.getItem('auth_token') || null);

    const isAuthenticated = computed(() => !!token.value);
    const isAdmin = computed(() => user.value && user.value.userType === 'admin');
    const isGuest = computed(() => user.value && user.value.userType === 'guest');
    const isAccountActive = computed(() => user.value && user.value.status === 'active');

    const resetInactivityTimer = () => {
        if (inactivityTimer) {
            clearTimeout(inactivityTimer);
        }

        if (isAuthenticated.value) {
            inactivityTimer = setTimeout(() => {
                logout();
            }, INACTIVITY_TIMEOUT);
        }
    };

    const handleUserActivity = () => {
        resetInactivityTimer();
    };

    const login = (userData, authToken) => {
        user.value = userData;
        token.value = authToken;
        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('auth_token', authToken);

        resetInactivityTimer();
        setupActivityListener();
    };

    const logout = () => {
        user.value = null;
        token.value = null;
        localStorage.removeItem('user');
        localStorage.removeItem('auth_token');

        if (inactivityTimer) {
            clearTimeout(inactivityTimer);
            inactivityTimer = null;
        }
        removeActivityListener();

        router.push('/login');
    };

    const checkAuth = () => {
        const storedToken = localStorage.getItem('auth_token');
        const storedUser = localStorage.getItem('user');

        if (storedToken && storedUser) {
            token.value = storedToken;
            user.value = JSON.parse(storedUser);
            resetInactivityTimer();
            setupActivityListener();
            return true;
        }
        return false;
    };

    const checkAccountStatus = async () => {
        if (!isAuthenticated.value) return false;

        try {
            const response = await fetch('http://localhost:8000/api/user', {
                headers: {
                    'Authorization': `Bearer ${token.value}`,
                    'Accept': 'application/json'
                }
            });

            if (response.status === 423) {
                logout();
                return false;
            }

            if (response.ok) {
                const userData = await response.json();
                user.value = userData.user;
                localStorage.setItem('user', JSON.stringify(userData.user));
                return true;
            }

            return false;
        } catch (error) {
            console.error('Error checking account status:', error);
            return false;
        }
    };

    const setupActivityListener = () => {
        document.addEventListener('mousedown', handleUserActivity);
        document.addEventListener('mousemove', handleUserActivity);
        document.addEventListener('keypress', handleUserActivity);
        document.addEventListener('touchstart', handleUserActivity);
        document.addEventListener('scroll', handleUserActivity);
    };

    const removeActivityListener = () => {
        document.removeEventListener('mousedown', handleUserActivity);
        document.removeEventListener('mousemove', handleUserActivity);
        document.removeEventListener('keypress', handleUserActivity);
        document.removeEventListener('touchstart', handleUserActivity);
        document.removeEventListener('scroll', handleUserActivity);
    };

    const cleanup = () => {
        if (inactivityTimer) {
            clearTimeout(inactivityTimer);
            inactivityTimer = null;
        }
        removeActivityListener();
    };

    return {
        user,
        token,
        isAuthenticated,
        isAdmin,
        isGuest,
        isAccountActive,
        login,
        logout,
        checkAuth,
        checkAccountStatus,
        cleanup
    };
}
