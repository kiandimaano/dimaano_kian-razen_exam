<script setup>
import TopNav from '../components/topNav.vue';
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useAuth } from '../composables/useAuth';

const { user, isAdmin, isAccountActive } = useAuth();
const users = ref([]);
const loading = ref(false);

const newUser = ref({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  userType: 'guest'
});

const isDialogOpen = ref(false);

const isEditDialogOpen = ref(false);
const editingUser = ref({
  id: null,
  firstName: '',
  lastName: '',
  email: '',
  userType: 'guest'
});

const fetchUsers = async () => {
  loading.value = true;
  try {
    const response = await axios.get('http://localhost:8000/api/users', {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
      }
    })
    users.value = response.data;
  } catch (error) {
    console.error('Error fetching users:', error);
  } finally {
    loading.value = false;
  }
}

const deleteUser = async (id) => {
  if (confirm('Are you sure you want to delete this user?')) {
      try {
        await axios.delete(`http://127.0.0.1:8000/api/users/${id}`, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
        }
      })
      await fetchUsers();
    } catch (error) {
      console.error('Error deleting user:', error);
    }
  }
}

const deactivateGuest = async (id) => {
  try {
    const response = await axios.put(`http://localhost:8000/api/users/${id}/deactivate`, {}, {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
    }
  })
    
    if (response.data.message) {
      alert(response.data.message);
    }
    
    await fetchUsers();
  } catch (error) {
    console.error('Error deactivating guest:', error);
    alert('Error deactivating guest. Please try again.');
  }
}

const reactivateGuest = async (id) => {
  try {
    const response = await axios.put(`http://localhost:8000/api/users/${id}/reactivate`, {}, {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
    }
  })
    
    if (response.data.message) {
      alert(response.data.message);
    }
    
    await fetchUsers();
  } catch (error) {
    console.error('Error reactivating guest:', error);
    alert('Error reactivating guest. Please try again.');
  }
}

const handleAction = async (action, id) => {
  if (action === 'delete') {
    deleteUser(id);
  } else if (action === 'deactivate' && users.value.find(user => user.id === id).userType === 'guest') {
    deactivateGuest(id);
  } else if (action === 'reactivate' && users.value.find(user => user.id === id).userType === 'guest') {
    reactivateGuest(id);
  } else if (action === 'update') {
    openEditDialog(id);
  }
};

const createUser = async () => {
  try {
    await axios.post('http://localhost:8000/api/users', newUser.value, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
      }
    });
    
    newUser.value = {
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      userType: 'user'
    };
    isDialogOpen.value = false;
    
    await fetchUsers();
    
    alert('User created successfully!');
  } catch (error) {
    console.error('Error creating user:', error);
    alert('Error creating user. Please try again.');
  }
};

const openEditDialog = (userId) => {
  const user = users.value.find(u => u.id === userId);
  if (user) {
    editingUser.value = {
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      userType: user.userType
    };
    isEditDialogOpen.value = true;
  }
};

const updateUser = async () => {
  try {
    await axios.put(`http://localhost:8000/api/users/${editingUser.value.id}`, {
      firstName: editingUser.value.firstName,
      lastName: editingUser.value.lastName,
      email: editingUser.value.email,
      userType: editingUser.value.userType
    }, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
      }
    });
    
    isEditDialogOpen.value = false;
    await fetchUsers();
    
    alert('User updated successfully!');
  } catch (error) {
    console.error('Error updating user:', error);
    alert('Error updating user. Please try again.');
  }
};

const closeEditDialog = () => {
  isEditDialogOpen.value = false;
  editingUser.value = {
    id: null,
    firstName: '',
    lastName: '',
    email: '',
    userType: 'guest'
  };
};

const resetForm = () => {
  newUser.value = {
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    userType: 'guest'
  };
};

onMounted(() => {
  if (!isAdmin.value) {
    console.error('Access denied: Admin privileges required');
    return;
  }
  if (!isAccountActive.value) {
    console.error('Access denied: Account is deactivated');
    return;
  }
  fetchUsers();
})

</script>

<template>
  <div class="min-h-screen bg-gray-50 p-8">
    <TopNav class="py-2"/>
    
    <!-- Admin Access Check -->
    <div v-if="!isAdmin" class="mt-20 mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
      <h2 class="text-lg font-semibold">Access Denied</h2>
      <p>You need admin privileges to access this page.</p>
    </div>
    
    <div v-else class="flex justify-between items-center mt-20 mb-6">
      <h1 class="text-2xl font-bold text-gray-900">User Management</h1>
      <Button @click="isDialogOpen = true" class="bg-blue-600 hover:bg-blue-700">
        Add New User
      </Button>
    </div>

    <div v-if="isAdmin">
      <Table class="mt-10">
    <TableCaption>List of Accounts Registered</TableCaption>
    <TableHeader>
      <TableRow>
        <TableHead class="w-[100px]">
          ID
        </TableHead>
        <TableHead>First Name</TableHead>
        <TableHead>Last Name</TableHead>
        <TableHead>Email</TableHead>
        <TableHead>Type of User</TableHead>
        <TableHead>Status</TableHead>
        <TableHead>Account Created</TableHead>
        <TableHead class="text-right">
          Actions
        </TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      <TableRow v-for="user in users" :key="user.id">
        <TableCell class="font-medium">
          {{ user.id }}
        </TableCell>
        <TableCell>{{ user.firstName || 'N/A' }}</TableCell>
        <TableCell>{{ user.lastName || 'N/A' }}</TableCell>
        <TableCell>{{ user.email || 'N/A' }}</TableCell>
        <TableCell>{{ user.userType || 'N/A' }}</TableCell>
        <TableCell>
          <span :class="user.status === 'active' ? 'text-green-600 font-medium' : 'text-red-600 font-medium'">
            {{ user.status || 'active' }}
          </span>
        </TableCell>
        <TableCell>{{ user.created_at || 'N/A' }}</TableCell>
        <TableCell class="text-right">
          <div class="flex justify-end gap-2">
            <DropdownMenu>
              <DropdownMenuTrigger as-child>
                <Button variant="outline" size="sm">
                  Actions
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent class="w-48">
                <DropdownMenuLabel>Choose Action</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuGroup>
                  <DropdownMenuItem @click="openEditDialog(user.id)">
                    <span>Update</span>
                  </DropdownMenuItem>
                  <DropdownMenuItem @click="deleteUser(user.id)" class="text-red-600">
                    <span>Delete</span>
                  </DropdownMenuItem>
                  <DropdownMenuItem 
                    v-if="user.userType === 'guest' && user.status === 'active'" 
                    @click="deactivateGuest(user.id)"
                    class="text-orange-600"
                  >
                    <span>Deactivate Guest</span>
                  </DropdownMenuItem>
                  <DropdownMenuItem 
                    v-if="user.userType === 'guest' && user.status === 'inactive'" 
                    @click="reactivateGuest(user.id)"
                    class="text-green-600"
                  >
                    <span>Reactivate Guest</span>
                  </DropdownMenuItem>
                </DropdownMenuGroup>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </TableCell>
      </TableRow>
    </TableBody>
      </Table>
    </div>

  <!-- Edit User Modal -->
  <div v-if="isEditDialogOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg p-6 w-full max-w-md mx-4">
      <h2 class="text-xl font-semibold mb-4">Edit User</h2>
      <form @submit.prevent="updateUser" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
          <input
            v-model="editingUser.firstName"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
          <input
            v-model="editingUser.lastName"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
          <input
            v-model="editingUser.email"
            type="email"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">User Type</label>
          <Select v-model="editingUser.userType">
            <SelectTrigger class="w-full">
              <SelectValue placeholder="Select user type" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="admin">Admin</SelectItem>
              <SelectItem value="guest">Guest</SelectItem>
            </SelectContent>
          </Select>
        </div>
        <div class="flex justify-end gap-3 pt-4">
          <Button type="button" variant="outline" @click="closeEditDialog">
            Cancel
          </Button>
          <Button type="submit" class="bg-blue-600 hover:bg-blue-700">
            Update User
          </Button>
        </div>
      </form>
    </div>
  </div>

  <!-- Add New User Modal -->
  <div v-if="isDialogOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg p-6 w-full max-w-md mx-4">
      <h2 class="text-xl font-semibold mb-4">Add New User</h2>
      <form @submit.prevent="createUser" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
          <input
            v-model="newUser.firstName"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
          <input
            v-model="newUser.lastName"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
          <input
            v-model="newUser.email"
            type="email"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
          <input
            v-model="newUser.password"
            type="password"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">User Type</label>
          <Select v-model="newUser.userType">
            <SelectTrigger class="w-full">
              <SelectValue placeholder="Select user type" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="admin">Admin</SelectItem>
              <SelectItem value="guest">Guest</SelectItem>
            </SelectContent>
          </Select>
        </div>
        <div class="flex justify-end gap-3 pt-4">
          <Button type="button" variant="outline" @click="isDialogOpen = false">
            Cancel
          </Button>
          <Button type="submit" class="bg-blue-600 hover:bg-blue-700">
            Create User
          </Button>
        </div>
      </form>
    </div>
  </div>
  </div>
</template>

