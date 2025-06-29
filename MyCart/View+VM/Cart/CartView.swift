//
//  CartView.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var router: Router
    @StateObject var vm = CartVM()
    @Binding var hideTabBar: Bool
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var defaultCardIndex: Int = 100

    var body: some View {
        VStack {
            // MARK: - NAVIGATION BAR
            NavBarGeneric(title: vm.navigationTitle) {} trailingContent: {}

            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if !vm.cartItems.isEmpty {
                            // Cart Items
                            ForEach(vm.cartItems, id: \.checkoutProduct.id) { itemWrapper in
                                CartItemView(
                                    cartItemWrapper: itemWrapper,
                                    onRemove: { productId in
                                        removeItems(productId: productId)
                                    },
                                    onUpdateQuantity: { productId, quantity in
                                        updateItemQuantity(productId: productId, quantity: quantity)
                                    }
                                )
                            }

                            // Cart Summary
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Items in Cart:")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(vm.cartItemCount)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                }

                                HStack {
                                    Text("Total:")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("LKR \(formatNumber(number: vm.getCartTotal()))")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)

                            // Action Buttons
                            HStack(spacing: 12) {
                                Spacer()

                                CommonButton(
                                    title: "Clear Cart",
                                    isFilled: true,
                                    isFullWidth: true,
                                    buttonWidth: 120
                                ) {
                                    clearCart()
                                }

                                Spacer()
                            }
                            .padding(.bottom, 64)
                        } else {
                            // Empty Cart State
                            VStack(spacing: 20) {
                                Image(systemName: "cart")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)

                                Text("Your cart is empty")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            .padding(.top, UIScreen.screenHeight * 0.3)
                        }
                    } // : VStack
//                    .padding(.top, 16)
                    .overlay(
                        //: Need for auto hiding TabBar
                        GeometryReader { proxy -> Color in

                            let minY = proxy.frame(in: .global).minY
                            let durationOffset: CGFloat = 30

                            DispatchQueue.main.async {
                                if minY < offset {
                                    if offset < 0 && -minY > (lastOffset + durationOffset) {
                                        withAnimation(.easeOut(duration: 1.5)) {
                                            hideTabBar = true
                                        }
                                        lastOffset = -offset
                                    }
                                } else if minY > offset && -minY < (lastOffset - durationOffset) {
                                    withAnimation(.easeIn(duration: 1)) {
                                        hideTabBar = false
                                    }
                                    lastOffset = -offset
                                }
                                self.offset = minY
                            }
                            return Color.clear
                        }
                    )
                } //: Scroll View
            } //: VStack
            .padding(.horizontal, 16)
            .foregroundColor(Color.white)

            .onAppear {
                getAllCartItems()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshCart"))) { _ in
                getAllCartItems()
            }

        } // : VStack
        .baseViewStyles()
    }

    func getAllCartItems() {
        // MARK: - GET ITEM CARDS API CALL

        vm.startLoading()
        vm.processWithCart { success, _ in
            vm.stopLoading()
            if success {
                vm.showSuccessLogger(message: "cart data get success !")
            } else {
                vm.showErrorLogger(message: "cart data get Error !")
            }
        }
    }

    func removeItems(productId: String) {
        // MARK: - Remove CARDS API CALL

        vm.startLoading()
        vm.processWithRemoveItem(productId: productId) { success, _ in
            vm.stopLoading()
            if success {
                vm.showSuccessLogger(message: "cart Item remove success !")
            } else {
                vm.showErrorLogger(message: "cart Item remove Error !")
            }
        }
    }

    func updateItemQuantity(productId: String, quantity: Int) {
        // MARK: - UPDATE QUANTITY API CALL

        vm.startLoading()
        vm.updateItemQuantity(productId: productId, quantity: quantity) { success, _ in
            vm.stopLoading()
            if success {
                vm.showSuccessLogger(message: "Quantity updated successfully!")
            } else {
                vm.showErrorLogger(message: "Failed to update quantity!")
            }
        }
    }
    // MARK: - CLEAR CART API CALL

    func clearCart() {
        vm.startLoading()
        vm.clearCart { success, _ in
            vm.stopLoading()
            if success {
                vm.showSuccessLogger(message: "Cart cleared successfully!")
            } else {
                vm.showErrorLogger(message: "Failed to clear cart!")
            }
        }
    }
}

#Preview {
    CartView(hideTabBar: .constant(true))
}
