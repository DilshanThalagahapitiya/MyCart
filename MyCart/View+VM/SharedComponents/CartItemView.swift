//
//  CartItemView.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartItemView: View {
    let cartItemWrapper: CartItemWrapper
    let onRemove: (String) -> Void
    let onUpdateQuantity: (String, Int) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Product Image
                WebImage(url: URL(string: cartItemWrapper.checkoutProduct.productDetails?.image ?? ""))
                    .resizable()
                    .placeholder(when: false) {
                        Image("GiftPlaceHolder")
                            .resizable()
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Product Title
                    Text(cartItemWrapper.checkoutProduct.productDetails?.title ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    // Product Category
                    Text(cartItemWrapper.checkoutProduct.productDetails?.category?.category ?? "")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    // Price
                    Text("LKR \(formatNumber(number: cartItemWrapper.checkoutProduct.productDetails?.price ?? 0))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Remove Button
                Button(action: {
                    onRemove(String(cartItemWrapper.checkoutProduct.productDetails?.id ?? 0))
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(Color.errorRed)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            
            // Quantity Controls
            HStack {
                Text("Quantity:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        if cartItemWrapper.quantity > 1 {
                            onUpdateQuantity(String(cartItemWrapper.checkoutProduct.productDetails?.id ?? 0), cartItemWrapper.quantity - 1)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(Color.primaryButton)
                            .font(.system(size: 20))
                    }
                    .disabled(cartItemWrapper.quantity <= 1)
                    
                    Text("\(cartItemWrapper.quantity)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        onUpdateQuantity(String(cartItemWrapper.checkoutProduct.productDetails?.id ?? 0), cartItemWrapper.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color.primaryButton)
                            .font(.system(size: 20))
                    }
                }
            }
            
            // Total for this item
            HStack {
                Spacer()
                Text("Total: LKR \(formatNumber(number: cartItemWrapper.totalPrice))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    CartItemView(
        cartItemWrapper: CartItemWrapper(
            checkoutProduct: CheckoutProduct(
                id: "1",
                productDetails: ProductModel(
                    id: 1,
                    title: "Sample Product",
                    price: 99.99,
                    description: "Sample description",
                    category: Category(id: "1", category: "Electronics"),
                    image: "",
                    rating: Rating(rate: 4.5, count: 100),
                    isFavourite: false
                ),
                status: 1,
                createdAt: "2025-06-28",
                updatedAt: "2025-06-28"
            ),
            quantity: 2
        ),
        onRemove: { _ in },
        onUpdateQuantity: { _, _ in }
    )
    .background(Color.black)
}
