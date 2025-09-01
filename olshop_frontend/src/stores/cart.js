import { defineStore } from 'pinia'

export const useCartStore = defineStore('cart', {
    state: () => ({
        items: []
    }),

    getters: {
        totalItems: (state) => state.items.reduce((total, item) => total + item.quantity, 0),
        totalPrice: (state) => state.items.reduce((total, item) => total + (item.price * item.quantity), 0)
    },

    actions: {
        addToCart(product) {
            // Check if product is out of stock
            if (product.stock <= 0) {
                alert('This product is out of stock!')
                return false
            }

            // Check if product already exists in cart
            const existingItem = this.items.find(item => item.id === product.id)

            if (existingItem) {
                // Check if adding more would exceed stock
                if (existingItem.quantity + 1 > product.stock) {
                    alert('Cannot add more items. Stock limit reached!')
                    return false
                }
                // Increase quantity if product already in cart
                existingItem.quantity += 1
            } else {
                // Add new product to cart
                this.items.push({
                    id: product.id,
                    name: product.product_name,
                    price: product.price,
                    image: product.image,
                    stock: product.stock,
                    quantity: 1
                })
            }

            return true
        },

        removeFromCart(productId) {
            const index = this.items.findIndex(item => item.id === productId)
            if (index > -1) {
                this.items.splice(index, 1)
            }
        },

        updateQuantity(productId, newQuantity) {
            const item = this.items.find(item => item.id === productId)
            if (item) {
                if (newQuantity <= 0) {
                    this.removeFromCart(productId)
                } else if (newQuantity > item.stock) {
                    alert('Cannot add more items. Stock limit reached!')
                } else {
                    item.quantity = newQuantity
                }
            }
        },

        clearCart() {
            this.items = []
        }
    }
})