//
//  CartDataManager.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import Foundation
import CoreData
import SwiftUI

class CartDataManager: ObservableObject {
    static let shared = CartDataManager()
    
    private let persistenceController = PersistenceController.shared
    
    @Published var cartItems: [CartItem] = []
    @Published var cart: Cart?
    
    private init() {
        loadCart()
    }
    
    // MARK: - Cart Management
    
    /// Load or create the main cart
    func loadCart() {
        let context = persistenceController.container.viewContext
        
        // Try to fetch existing cart
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingCart = results.first {
                self.cart = existingCart
                // Convert NSSet to Array of CartItem objects
                if let itemsSet = existingCart.items as? Set<CartItem> {
                    self.cartItems = Array(itemsSet)
                } else {
                    self.cartItems = []
                }
            } else {
                // Create new cart if none exists
                createNewCart()
            }
        } catch {
            print("Error loading cart: \(error)")
        }
    }
    
    /// Refresh cart items from Core Data
    func refreshCartItems() {
        print("CartDataManager: refreshCartItems called")
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addedAt", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            print("CartDataManager: Fetched \(results.count) items from Core Data")
            // Ensure UI updates happen on main thread
            DispatchQueue.main.async {
                self.cartItems = results
                print("CartDataManager: Updated cartItems to \(self.cartItems.count) items")
            }
        } catch {
            print("Error refreshing cart items: \(error)")
            DispatchQueue.main.async {
                self.cartItems = []
            }
        }
    }
    
    /// Create a new cart
    private func createNewCart() {
        let context = persistenceController.container.viewContext
        let newCart = Cart(context: context)
        newCart.id = UUID().uuidString
        newCart.createdAt = Date()
        newCart.updatedAt = Date()
        
        do {
            try context.save()
            self.cart = newCart
            self.cartItems = []
        } catch {
            print("Error creating cart: \(error)")
        }
    }
    
    // MARK: - Cart Item Operations
    
    /// Add a product to cart
    func addToCart(product: ProductModel) {
        print("CartDataManager: Adding product to cart - ID: \(product.id ?? 0), Title: \(product.title ?? "nil")")
        let context = persistenceController.container.viewContext
        
        // Check if product already exists in cart
        if let existingItem = findCartItem(for: product) {
            // Update quantity
            existingItem.quantity += 1
            existingItem.addedAt = Date()
            print("CartDataManager: Updated existing item quantity to \(existingItem.quantity)")
        } else {
            // Create new cart item
            let newItem = CartItem(context: context)
            newItem.id = UUID().uuidString
            newItem.productId = Int32(product.id ?? 0)
            newItem.title = product.title
            newItem.price = product.price ?? 0.0
            newItem.productDescription = product.description
            newItem.category = product.category?.category
            newItem.image = product.image
            newItem.rating = product.rating?.rate ?? 0.0
            newItem.ratingCount = Int32(product.rating?.count ?? 0)
            newItem.quantity = 1
            newItem.addedAt = Date()
            newItem.cart = cart
            print("CartDataManager: Created new cart item for product ID: \(newItem.productId)")
        }
        
        // Update cart timestamp
        cart?.updatedAt = Date()
        
        saveContext()
        refreshCartItems()
        print("CartDataManager: After addToCart, cartItems count: \(cartItems.count)")
    }
    
    /// Remove a product from cart
    func removeFromCart(productId: Int) {
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            print("CartDataManager: Found \(results.count) items to remove for productId: \(productId)")
            
            for item in results {
                print("CartDataManager: Removing item with productId: \(item.productId), title: \(item.title ?? "nil")")
                context.delete(item)
            }
            
            cart?.updatedAt = Date()
            saveContext()
            refreshCartItems()
            print("CartDataManager: Remove operation completed")
        } catch {
            print("Error removing item from cart: \(error)")
        }
    }
    
    /// Update quantity of a cart item
    func updateQuantity(for productId: Int, quantity: Int) {
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let item = results.first {
                if quantity <= 0 {
                    context.delete(item)
                } else {
                    item.quantity = Int32(quantity)
                }
                
                cart?.updatedAt = Date()
                saveContext()
                refreshCartItems()
            }
        } catch {
            print("Error updating quantity: \(error)")
        }
    }
    
    /// Clear all items from cart
    func clearCart() {
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
            
            cart?.updatedAt = Date()
            saveContext()
            refreshCartItems()
        } catch {
            print("Error clearing cart: \(error)")
        }
    }
    
    /// Get total number of items in cart
    func getCartItemCount() -> Int {
        return cartItems.reduce(0) { $0 + Int($1.quantity) }
    }
    
    /// Get total price of cart
    func getCartTotal() -> Double {
        return cartItems.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    /// Check if product is in cart
    func isProductInCart(productId: Int) -> Bool {
        return findCartItem(for: ProductModel(id: productId, title: nil, price: nil, description: nil, category: nil, image: nil, rating: nil, isFavourite: nil)) != nil
    }
    
    // MARK: - Helper Methods
    
    /// Find existing cart item for a product
    private func findCartItem(for product: ProductModel) -> CartItem? {
        guard let productId = product.id else { return nil }
        
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error finding cart item: \(error)")
            return nil
        }
    }
    
    /// Save Core Data context
    private func saveContext() {
        let context = persistenceController.container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

// MARK: - Extensions for Core Data Models

extension CartItem {
    /// Convert CartItem to ProductModel for compatibility
    func toProductModel() -> ProductModel {
        let category = Category(id: self.category, category: self.category)
        let rating = Rating(rate: self.rating, count: Int(self.ratingCount))
        
        return ProductModel(
            id: Int(self.productId),
            title: self.title,
            price: self.price,
            description: self.productDescription,
            category: category,
            image: self.image,
            rating: rating,
            isFavourite: false
        )
    }
    
    /// Convert CartItem to CheckoutProduct for compatibility
    func toCheckoutProduct() -> CheckoutProduct {
        return CheckoutProduct(
            id: self.id,
            productDetails: self.toProductModel(),
            status: 1, // Active status
            createdAt: self.addedAt?.ISO8601String(),
            updatedAt: self.addedAt?.ISO8601String()
        )
    }
    
    /// Get quantity for this cart item
    var itemQuantity: Int {
        return Int(self.quantity)
    }
}

extension Date {
    func ISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
} 
