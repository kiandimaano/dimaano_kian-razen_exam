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
import { ref, onMounted, onUnmounted } from 'vue'
import axios from 'axios'
import { useAuth } from '../composables/useAuth'

const { isAdmin, cleanup } = useAuth()
const orders = ref([])
const loading = ref(false)

const fetchOrders = async () => {
  loading.value = true
  try {
    const response = await axios.get('http://localhost:8000/api/orders')
    orders.value = response.data
  } catch (error) {
    console.error('Error fetching orders:', error)
  } finally {
    loading.value = false
  }
}

const updateOrderStatus = async (orderId, newStatus) => {
  try {
    await axios.put(`http://localhost:8000/api/orders/${orderId}/status`, {
      status: newStatus
    })
    
    // Update local state
    const order = orders.value.find(o => o.order_id === orderId)
    if (order) {
      order.status = newStatus
    }
    
    alert('Order status updated successfully!')
  } catch (error) {
    console.error('Error updating order status:', error)
    alert('Failed to update order status')
  }
}

onMounted(() => {
  fetchOrders()
})

onUnmounted(() => {
  cleanup()
})
</script>

<template>
    <div class="min-h-screen bg-gray-50 p-8">
        <TopNav class="py-2"/>

        <!-- Page Title -->
        <div class="mt-20 mb-6">
            <h1 class="text-3xl font-bold text-gray-900">
                {{ isAdmin ? 'Order Management' : 'My Orders' }}
            </h1>
            <p class="text-gray-600 mt-2">
                {{ isAdmin ? 'Manage all customer orders' : 'View your order history and status' }}
            </p>
        </div>

        <Table>
            <TableCaption>
                {{ isAdmin ? 'List of All Orders' : 'Your Order History' }}
            </TableCaption>
            <TableHeader>
                <TableRow>
                    <TableHead class="w-[100px]">
                        Order ID
                    </TableHead>
                    <TableHead class="text-center">Customer Name</TableHead>
                    <TableHead>Image</TableHead>
                    <TableHead class="text-center">Product Name</TableHead>
                    <TableHead class="text-center">Price</TableHead>
                    <TableHead class="text-center">Stock</TableHead>
                    <TableHead class="text-center">Quantity</TableHead>
                    <TableHead class="text-center">
                        Status
                    </TableHead>
                    <TableHead v-if="isAdmin" class="text-center">
                        Actions
                    </TableHead>
                </TableRow>
            </TableHeader>
            <TableBody>
                <TableRow v-for="order in orders" :key="order.order_id">
                    <TableCell class="font-medium text-center">
                        {{ order.order_id }}
                    </TableCell>
                    <TableCell class="text-center">{{ order.customer_name }}</TableCell>
                    <TableCell>
                        <img :src="`/images/${order.image}`" :alt="order.product_name" class="h-32 w-auto">
                    </TableCell>
                    <TableCell class="text-center">{{ order.product_name }}</TableCell>
                    <TableCell class="text-center">${{ order.price }}</TableCell>
                    <TableCell class="text-center">{{ order.stock }}</TableCell>
                    <TableCell class="text-center">{{ order.quantity }}</TableCell>
                    <TableCell class="text-center">
                        <span class="px-3 py-1 rounded-full text-sm font-medium"
                              :class="{
                                  'bg-yellow-100 text-yellow-800': order.status === 'Pending',
                                  'bg-blue-100 text-blue-800': order.status === 'For Delivery',
                                  'bg-green-100 text-green-800': order.status === 'Delivered',
                                  'bg-red-100 text-red-800': order.status === 'Canceled'
                              }">
                            {{ order.status }}
                        </span>
                    </TableCell>
                    <TableCell v-if="isAdmin" class="text-center">
                        <DropdownMenu>
                            <DropdownMenuTrigger as-child>
                                <Button variant="outline" size="sm" class="text-center">
                                    Change Status
                                </Button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent class="w-48">
                                <DropdownMenuLabel>Choose Status</DropdownMenuLabel>
                                <DropdownMenuSeparator />
                                <DropdownMenuGroup>
                                    <DropdownMenuItem @click="updateOrderStatus(order.order_id, 'Canceled')">
                                        <span>Canceled</span>
                                    </DropdownMenuItem>
                                    <DropdownMenuItem @click="updateOrderStatus(order.order_id, 'Pending')">
                                        <span>Pending</span>
                                    </DropdownMenuItem>
                                    <DropdownMenuItem @click="updateOrderStatus(order.order_id, 'For Delivery')">
                                        <span>For Delivery</span>
                                    </DropdownMenuItem>
                                    <DropdownMenuItem @click="updateOrderStatus(order.order_id, 'Delivered')">
                                        <span>Delivered</span>
                                    </DropdownMenuItem>
                                </DropdownMenuGroup>
                            </DropdownMenuContent>
                        </DropdownMenu>
                    </TableCell>
                </TableRow>
            </TableBody>
        </Table>
    </div>
</template>