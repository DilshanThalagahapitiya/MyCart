//
//  HomeVM.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation
import Combine

class HomeVM: BaseVM {
    @Published var searchText: String = ""
    @Published var debouncedSearchValue: String = ""

    @Published var navigationTitle: String = "Welcome to store!"
    @Published var selectedCategoryId: String = ""

    @Published var ItemCategories: [Category] = []
    @Published var selectedItemCategory: Category? = nil
    
    @Published var ItemCards: [ProductModel] = []
    @Published var selectedItemCard: ProductModel? = nil
    
    @Published var addFavoriteItems: ProductModel?
    
    // MARK: - Combine Properties
    private var cancellables = Set<AnyCancellable>()
    private let searchSubject = PassthroughSubject<String, Never>()
    private let categorySubject = PassthroughSubject<String, Never>()
    
    // MARK: - Loading States
    @Published var isLoadingCategories: Bool = false
    @Published var isLoadingProducts: Bool = false
    
    override init() {
        super.init()
        setupCombineSubscriptions()
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// MARK: - Combine Setup
extension HomeVM {
    
    private func setupCombineSubscriptions() {
        // Search debouncing - wait 0.5 seconds after user stops typing
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchQuery in
                self?.fetchProductsWithCombine(categoryId: self?.selectedItemCategory?.id ?? "", query: self?.searchText ?? "")
            }
            .store(in: &cancellables)
        
        // Category selection
        categorySubject
            .removeDuplicates()
            .sink { [weak self] categoryId in
                self?.fetchProductsWithCombine(categoryId: categoryId, query: self?.searchText ?? "")
            }
            .store(in: &cancellables)
    }
}

// MARK: - Combine Network Operations
extension HomeVM {
    
    /// Fetch categories using Combine
    func fetchCategoriesWithCombine() {
        isLoadingCategories = true
        startLoading()
        
        NetworkService.shared.fetchCategoriesPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingCategories = false
                    self?.stopLoading()
                    
                    if case .failure(let error) = completion {
                        self?.showErrorLogger(message: "Failed to fetch categories: \(error.localizedDescription)")
                        self?.handleErrorAndShowAlert(error: error)
                    }
                },
                receiveValue: { [weak self] categories in
                    self?.ItemCategories = categories
                    print("Categorys \(categories)")
                    self?.showSuccessLogger(message: "Categories fetched successfully!")
                }
            )
            .store(in: &cancellables)
    }
    
    /// Fetch products using Combine
    func fetchProductsWithCombine(categoryId: String = "", query: String = "") {
        isLoadingProducts = true
        startLoading()
        
        NetworkService.shared.fetchProductsPublisher(categoryId: categoryId, query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingProducts = false
                    self?.stopLoading()
                    
                    if case .failure(let error) = completion {
                        self?.showErrorLogger(message: "Failed to fetch products: \(error.localizedDescription)")
                        self?.handleErrorAndShowAlert(error: error)
                    }
                },
                receiveValue: { [weak self] products in
                    self?.ItemCards = products
                    dump("Products \(products)")

                    self?.showSuccessLogger(message: "Products fetched successfully!")
                }
            )
            .store(in: &cancellables)
    }
    
    /// Trigger search with Combine
    func triggerSearch() {
        searchSubject.send(searchText)
    }
    
    /// Trigger category selection with Combine
    func selectCategory(_ category: Category?) {
        selectedItemCategory = category
        categorySubject.send(category?.id ?? "")
    }
    
    /// Refresh all data using Combine
    func refreshData() {
        fetchCategoriesWithCombine()
        fetchProductsWithCombine(categoryId: selectedItemCategory?.id ?? "", query: searchText)
    }
    
    /// Test method to verify Combine implementation
    func testCombineImplementation() {
        print("Testing Combine implementation...")
        fetchCategoriesWithCombine()
        fetchProductsWithCombine()
    }
    
    /// Cancel all ongoing network requests
    func cancelAllRequests() {
        cancellables.removeAll()
        setupCombineSubscriptions()
    }
}

// MARK: - Legacy Async/Await Network Operations (Backward Compatibility)
extension HomeVM {
    
    /// Fetch categories using async/await
    @MainActor
    func fetchCategories() async {
        startLoading()
        
        do {
            let categories = try await NetworkService.shared.fetchCategories()
            self.ItemCategories = categories
            self.showSuccessLogger(message: "Categories fetched successfully!")
        } catch {
            self.showErrorLogger(message: "Failed to fetch categories: \(error.localizedDescription)")
            self.handleErrorAndShowAlert(error: error)
        }
        
        stopLoading()
    }
    
    /// Fetch products using async/await
    @MainActor
    func fetchProducts(categoryId: String = "", query: String = "") async {
        startLoading()
        
        do {
            let products = try await NetworkService.shared.fetchProducts(categoryId: categoryId, query: query)
            self.ItemCards = products
            self.showSuccessLogger(message: "Products fetched successfully!")
        } catch {
            self.showErrorLogger(message: "Failed to fetch products: \(error.localizedDescription)")
            self.handleErrorAndShowAlert(error: error)
        }
        
        stopLoading()
    }
    
    /// Legacy method for backward compatibility - converts to async/await
    func processWithCategories(completion: @escaping CompletionHandler) {
        Task {
            await fetchCategories()
            completion(true, "Categories fetched successfully!")
        }
    }
    
    /// Legacy method for backward compatibility - converts to async/await
    func processWithItemCards(categoryId: String = "", q: String = "", completion: @escaping CompletionHandler) {
        Task {
            await fetchProducts(categoryId: categoryId, query: q)
            completion(true, "Products fetched successfully!")
        }
    }
}
