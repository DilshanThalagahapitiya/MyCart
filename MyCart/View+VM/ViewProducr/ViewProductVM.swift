//
//  ViewProductVM.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Alamofire
import Foundation
import SwiftUI

class ViewProductVM: BaseVM {
    @Published var currentPage = 0
    @Published var navigationTitle = "View Product"
    @Published var isActiveGenerateItemCardView: Bool = false
    @Published var product: ProductModel?
    @Published var addFavoriteGifts: ProductModel?

    // Core Data Cart Manager
    let cartDataManager = CartDataManager.shared

    init(homeVM: HomeVM) {
        super.init()
        product = homeVM.selectedItemCard
    }
}

// MARK: - ADD TO CART FUNCTION

extension ViewProductVM {
    func processWithAddToCartItems(itemId: String, completion: @escaping CompletionHandler) {
        guard let product = product else {
            completion(false, "Product not available")
            return
        }

        // Add to local Core Data cart
        cartDataManager.addToCart(product: product)

        // Show success message
        isAlertShown = true
        alertTitle = "Success"
        alertMessage = "Item added to cart successfully"

        completion(true, "Success Product Add to Cart")
    }

    /// Check if current product is in cart
    func isProductInCart() -> Bool {
        guard let product = product else { return false }
        return cartDataManager.isProductInCart(productId: product.id ?? 0)
    }
}
