//
//  NetworkService.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation
import Combine

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError(String)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingFailed:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        case .noData:
            return "No data received"
        }
    }
}

// MARK: - API Response Models
struct APIErrorResponse: Codable {
    let status: String?
    let code: String?
    let message: String?
}

// MARK: - Network Service
class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "https://fakestoreapi.com"
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Generic Request Method
    private func request<T: Codable>(_ endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authorization header if needed
        if !userDefaults.authToken.isEmpty {
            request.setValue("Bearer \(userDefaults.authToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Add parameters for POST/PUT requests
        if let parameters = parameters, method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        // Add query parameters for GET requests
        if let parameters = parameters, method == .get {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            if let finalURL = components?.url {
                request.url = finalURL
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // Check for HTTP errors
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to decode error response
                if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    throw NetworkError.serverError(errorResponse.message ?? "Server error")
                }
                throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
            }
            
            // Decode response
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - API Endpoints
extension NetworkService {
    
    /// Fetch all categories
    func fetchCategories() async throws -> [Category] {
        // Since the API returns products with categories, we'll extract unique categories
        let products: [ProductModel] = try await request("/products")
        let categories = products.compactMap { $0.category }
        
        // Create unique categories with proper structure
        var uniqueCategories: [Category] = []
        var seenCategories: Set<String> = []
        
        for category in categories {
            if let categoryName = category.category, !seenCategories.contains(categoryName) {
                seenCategories.insert(categoryName)
                uniqueCategories.append(Category(id: categoryName, category: categoryName))
            }
        }
        
        return uniqueCategories
    }
    
    /// Fetch products with optional category filter and search query
    func fetchProducts(categoryId: String = "", query: String = "") async throws -> [ProductModel] {
        var endpoint = "/products"
        
        // Add category filter if provided
        if !categoryId.isEmpty {
            endpoint = "/products/category/\(categoryId)"
        }
        
        var products: [ProductModel] = try await request(endpoint)
        
        // Apply search filter if query is provided
        if !query.isEmpty {
            products = products.filter { product in
                product.title?.localizedCaseInsensitiveContains(query) == true ||
                product.description?.localizedCaseInsensitiveContains(query) == true
            }
        }
        
        return products
    }
    
    /// Fetch single product by ID
    func fetchProduct(id: Int) async throws -> ProductModel {
        return try await request("/products/\(id)")
    }
}

// MARK: - Combine Publishers
extension NetworkService {
    
    /// Fetch categories using Combine
    func fetchCategoriesPublisher() -> AnyPublisher<[Category], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            
            Task {
                do {
                    let categories = try await self.fetchCategories()
                    promise(.success(categories))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Fetch products using Combine
    func fetchProductsPublisher(categoryId: String = "", query: String = "") -> AnyPublisher<[ProductModel], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            
            Task {
                do {
                    let products = try await self.fetchProducts(categoryId: categoryId, query: query)
                    promise(.success(products))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Fetch single product by ID using Combine
    func fetchProductPublisher(id: Int) -> AnyPublisher<ProductModel, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            
            Task {
                do {
                    let product = try await self.fetchProduct(id: id)
                    promise(.success(product))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
