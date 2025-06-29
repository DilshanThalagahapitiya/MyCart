//
//  ViewProductView.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import SDWebImageSwiftUI
import SwiftUI

struct ViewProductView: View {
    @EnvironmentObject var router: Router
    @State var isFav: Bool = false
    @StateObject var vm: ViewProductVM

    var body: some View {
        VStack {
            // MARK: - NAVIGATION BAR

            NavBarGeneric(title: vm.navigationTitle) {
                NavBarBackButton()
            } trailingContent: {}
            ScrollView(showsIndicators:false) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 10) {
                        WebImage(url: URL(string: vm.product?.image ?? ""))
                            .resizable()
                            .placeholder(when: .random()) {
                                Image("default_Placeholder")
                                    .resizable()
                                    .frame(height: 294)
                                    .cornerRadius(14)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .frame(height: 294)
                            .cornerRadius(14)
                            .foregroundColor(Color.white.opacity(0.5))
                        
                        Text(vm.product?.category?.category ?? "")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundColor(Color.primaryText)
                            .padding(.leading, 16)
                            .padding(.top, 5)
                        
                        Text(vm.product?.title ?? "")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color.secondaryText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                            .padding(.horizontal, 16)
                        
                        HStack{
                            ViewRatingView(vm.product?.rating?.rate ?? 0, starFontSize: 12, spacing: 2)
                            Text("| \(String(format: "%.1f", vm.product?.rating?.rate ?? 0)) (\(vm.product?.rating?.count ?? 0))")
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .foregroundColor(Color.secondaryText)
                        }//HStack
                        .padding(.leading,16)
                        
                        Text("LKR \(formatNumber(number: Double(vm.product?.price ?? 0)))")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundColor(Color.errorRed)
                            .padding(.leading, 16)
                            .padding(.bottom, 13)
                        
                        
                        HStack {
                            Spacer()
                            CommonButton(
                                title: vm.isProductInCart() ? "Added to Cart" : "Add to cart",
                                isFilled: vm.isProductInCart(),
                                isFullWidth: false,
                                buttonWidth: 271
                            ) {
                                if !vm.isProductInCart() {
                                    AddToCart(itemId: String(vm.product?.id ?? 0))
                                }
                            }
                            .disabled(vm.isProductInCart())
                            Spacer()
                        } // : HStack
                        .padding([.top,.bottom], 16)
                    } // : VStack Item detail card
                    .background(.white.opacity(0.2))
                    .cornerRadius(14)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .padding(.bottom, 18)
                                .foregroundColor(Color.primaryText)
                            
                            Text(vm.product?.description ?? "")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .padding(.bottom, 10)
                                .foregroundColor(Color.secondaryTextColor)
                                .padding(16)
                                .background(.white.opacity(0.2))
                                .cornerRadius(14)
                        } // : VStack
                        .padding(.top, 16)
                    } // : Scroll view
                } // : VStack
            }//ScrollView
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .onAppear {
                // Refresh cart status when view appears
                vm.isProductInCart()
            }
        } // : ZStack
        .baseViewStyles()
    }

    // MARK: - ADD TO CART API CALL.

    func AddToCart(itemId: String) {
        vm.startLoading()
        vm.processWithAddToCartItems(itemId: itemId) { success, _ in
            vm.stopLoading()
            if success {
                vm.showSuccessLogger(message: "add to cart success !")
                // Force refresh cart items to ensure UI updates
                vm.cartDataManager.refreshCartItems()
                // Post notification to refresh cart view
                NotificationCenter.default.post(name: NSNotification.Name("RefreshCart"), object: nil)
            } else {
                vm.showErrorLogger(message: "add to cart function Error !")
            }
        }
    }
}

#Preview {
    ViewProductView(vm: ViewProductVM(homeVM: HomeVM()))
}
