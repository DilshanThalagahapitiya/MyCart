//
//  CartModel.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation

// MARK: - CheckoutProduct
public struct CheckoutProduct: Codable {
    public let id: String?
    public let productDetails: ProductModel?
    public let status: Int?
    public let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case productDetails, status, createdAt, updatedAt
    }

    public init(id: String?, productDetails: ProductModel?, status: Int?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.productDetails = productDetails
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
