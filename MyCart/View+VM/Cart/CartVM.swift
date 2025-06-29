//
//  CartVM.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Alamofire
import Combine
import Foundation
import SwiftUI

class CartVM: BaseVM {
    @State var navigationTitle: String = "Cart"

    @Published var showCreditCardSheet: Bool = false
    @Published var isPaymentViewActive: Bool = false

    @Published var cartItems: [CartItemWrapper] = []
    @Published var selectedCartItem: CartItemWrapper?

    @Published var cartItemCount = 0

    // Core Data Cart Manager
    let cartDataManager = CartDataManager.shared

    override init() {
        super.init()
        // Load cart data immediately
        cartDataManager.loadCart()
        // Observe cart changes
        cartDataManager.$cartItems
            .sink { [weak self] items in
                self?.updateCartItems(from: items)
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    /// Update cart items from Core Data
    private func updateCartItems(from coreDataItems: [CartItem]) {
        print("CartVM: updateCartItems called with \(coreDataItems.count) items")
        cartItems = coreDataItems.map { cartItem in
            CartItemWrapper(
                checkoutProduct: cartItem.toCheckoutProduct(),
                quantity: cartItem.itemQuantity
            )
        }
        cartItemCount = cartDataManager.getCartItemCount()
        print("CartVM: Updated cartItems count: \(cartItems.count), cartItemCount: \(cartItemCount)")
    }
}

// MARK: - GET CART ITEMS FUNCTION

extension CartVM {
    func processWithCart(completion: @escaping CompletionHandler) {
        print("CartVM: processWithCart called")
        // Load cart items from Core Data
        cartDataManager.loadCart()
        cartDataManager.refreshCartItems()

        print("CartVM: After refresh, cartDataManager has \(cartDataManager.cartItems.count) items")

        // Update published properties
        cartItems = cartDataManager.cartItems.map { cartItem in
            CartItemWrapper(
                checkoutProduct: cartItem.toCheckoutProduct(),
                quantity: cartItem.itemQuantity
            )
        }
        cartItemCount = cartDataManager.getCartItemCount()

        print("CartVM: Final cartItems count: \(cartItems.count), cartItemCount: \(cartItemCount)")

        completion(true, "Success Items Getting..")
    }
}

// MARK: - REMOVE ITEM FUNCTION

extension CartVM {
    func processWithRemoveItem(productId: String, completion: @escaping CompletionHandler) {
        print("CartVM: Attempting to remove item with productId: \(productId)")

        guard let productIdInt = Int(productId) else {
            print("CartVM: Invalid product ID: \(productId)")
            completion(false, "Invalid product ID")
            return
        }

        print("CartVM: Converting to Int: \(productIdInt)")

        // Remove from Core Data
        cartDataManager.removeFromCart(productId: productIdInt)

        // Ensure UI updates on main thread
        DispatchQueue.main.async {
            completion(true, "Success Remove Item..")
        }
    }
}

// MARK: - PAY FOR ITEM FUNCTION

extension CartVM {
    func processWithPayForItem(productId: String, completion: @escaping CompletionHandler) {
        guard let productIdInt = Int(productId) else {
            completion(false, "Invalid product ID")
            return
        }

        // For now, just remove the item from cart after payment
        // In a real app, you would process payment and then remove items
        cartDataManager.removeFromCart(productId: productIdInt)

        completion(true, "Success Paid for Item..")
    }
}

// MARK: - ADDITIONAL CART OPERATIONS

extension CartVM {
    /// Update quantity of a cart item
    func updateItemQuantity(productId: String, quantity: Int, completion: @escaping CompletionHandler) {
        guard let productIdInt = Int(productId) else {
            completion(false, "Invalid product ID")
            return
        }

        cartDataManager.updateQuantity(for: productIdInt, quantity: quantity)

        // Ensure UI updates on main thread
        DispatchQueue.main.async {
            completion(true, "Quantity updated successfully")
        }
    }

    /// Clear all items from cart
    func clearCart(completion: @escaping CompletionHandler) {
        cartDataManager.clearCart()
        completion(true, "Cart cleared successfully")
    }

    /// Get cart total
    func getCartTotal() -> Double {
        return cartDataManager.getCartTotal()
    }
}
