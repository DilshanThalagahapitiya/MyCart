//
//  HomeView.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router

    @StateObject var vm = HomeVM()
    @Binding var hideTabBar: Bool
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0

    var body: some View {
        VStack {
            // MARK: - NAVIGATION BAR

            NavBarGeneric(title: vm.navigationTitle) {} trailingContent: {}

            GeometryReader { _ in
                VStack {
                    HStack(spacing: 16) {
                        // MARK: - SEARCH BAR

                        SearchBar(searchText: $vm.searchText, placeholder: "Start typing here", clearAction: {
                            vm.triggerSearch()
                        })
                        .onSubmit {
                            vm.triggerSearch()
                            print("search categoryId: \(vm.selectedCategoryId)")
                            print("search q: \(vm.searchText)")
                        }
                        .submitLabel(.search)
                    } // : HStack

                    VStack(alignment: .leading) {
                        Text("Discover Items")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .padding(.top, 16)
                            .padding(.leading, 9)
                            .foregroundColor(.primary)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                CategoryButton(categoryName: "All", categoryId: "", selectedCategoryId: $vm.selectedCategoryId, action: {
                                    vm.selectedCategoryId = ""
                                    vm.selectCategory(nil)
                                    print(vm.selectedCategoryId)
                                    
                                })
                                .onChange(of: vm.selectedCategoryId) { oldValue, newValue in
                                    Task{ await getItemCards(categoryId: newValue, q: "")}
                                }

                                ForEach(Array($vm.ItemCategories.enumerated()), id: \.offset) { _, $item in
                                    CategoryButton(categoryName: item.category ?? "", categoryId: item.id ?? "", selectedCategoryId: $vm.selectedCategoryId, action: {
                                        vm.selectedCategoryId = item.id ?? ""
                                        vm.selectCategory(item)
                                        print(vm.selectedCategoryId)
                                    })
                                    .onChange(of: vm.selectedCategoryId) { oldValue, newValue in
                                        Task{ await getItemCards(categoryId: newValue, q: "")}
                                    }
                                }
                            } // : HStack
                        } // : ScrollView
                    } //: VStack

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            if !vm.ItemCards.isEmpty {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 2), spacing: 4) {
                                    ForEach(Array(vm.ItemCards.enumerated()), id: \.offset) { _, card in
                                        HomeItemCardView(itemCard: card, isFav: card.isFavourite ?? false, viewAction: {
                                            vm.selectedItemCard = card
                                            let viewProductVM = ViewProductVM(homeVM: vm)
                                            router.navigate(to: .viewProduct, viewProductVM)
                                        }, addToFavAction: {
                                            Task {
                                                await AddOrRemoveFavorites(itemId: card.id ?? 0, favStatus: 1)
                                            }
                                        }, removeFromFavAction: {
                                            Task {
                                                await AddOrRemoveFavorites(itemId: card.id ?? 0, favStatus: 0)
                                            }
                                        })
                                        .padding(.horizontal, 4)
                                    }
                                }
                                .padding(.horizontal, 8)
                            } else {
                                // MARK: placeholder

                                VStack {
                                    Spacer()
                                    Text("No data found")
                                        .padding(.top, UIScreen.screenHeight * 0.3)
                                    Spacer()
                                } //: VStack
                            }
                        } // : VStack
                        .overlay(
                            //: Need for auto hiding TabBar
                            GeometryReader { proxy in
                                let minY = proxy.frame(in: .global).minY

                                Color.clear
                                    .onAppear {
                                        offset = minY
                                    }
                                    .onChange(of: minY) { newMinY in
                                        let durationOffset: CGFloat = 30

                                        if newMinY < offset {
                                            if offset < 0 && -newMinY > (lastOffset + durationOffset) {
                                                withAnimation(.easeOut(duration: 1.5)) {
                                                    hideTabBar = true
                                                }
                                                lastOffset = -offset
                                            }
                                        } else if newMinY > offset && -newMinY < (lastOffset - durationOffset) {
                                            withAnimation(.easeIn(duration: 1)) {
                                                hideTabBar = false
                                            }
                                            lastOffset = -offset
                                        }
                                        offset = newMinY
                                    }
                            }
                        )
                    } //: Scroll view
                    .refreshable {
                        vm.refreshData()
                    }
                } //: VStack
                .padding(.horizontal, 16)
                .foregroundColor(Color.secondaryText)
                .task {
                    vm.fetchCategoriesWithCombine()
                    await getItemCards(categoryId: vm.selectedCategoryId, q: "")
//                    vm.fetchProductsWithCombine(categoryId: selectedCategoryId == "" ? "" : String(selectedCategoryId))
//                    print(" count \(vm.ItemCards.count)")
                }
                .onChange(of: vm.searchText) { value in
                    vm.debouncedSearchValue = value
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if vm.debouncedSearchValue == value {
                            Task {
                                await getItemCards(categoryId: vm.selectedCategoryId, q: vm.searchText)
                            }
                        }
                    }
                }
            } //: Geometry
        } //: ZStack
        .navigationBarHidden(true)
        .baseViewStyles()
    }

    // MARK: - GET CATEGORIES API CALL (Legacy - kept for backward compatibility)

    func getCategories() async {
        await vm.fetchCategories()
    }

    func getItemCards(categoryId: String = "", q: String = "") async {
        // MARK: - GET ITEM CARDS API CALL (Legacy - kept for backward compatibility)
        vm.ItemCards.removeAll()
        await vm.fetchProducts(categoryId: categoryId, query: q)
    }

    // MARK: - ADD OR REMOVE FAVORITE API CALL.

    func AddOrRemoveFavorites(itemId: Int, favStatus: Int) async {
        // TODO: Implement favorite functionality with new NetworkService
        // For now, just refresh the items using Combine
        vm.refreshData()
    }
}

#Preview {
    HomeView(hideTabBar: .constant(true))
}
