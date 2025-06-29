//
//  CartItemWrapper.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation

struct CartItemWrapper {
    let checkoutProduct: CheckoutProduct
    let quantity: Int
    
    init(checkoutProduct: CheckoutProduct, quantity: Int) {
        self.checkoutProduct = checkoutProduct
        self.quantity = quantity
    }
    
    var totalPrice: Double {
        return (checkoutProduct.productDetails?.price ?? 0) * Double(quantity)
    }
} 
