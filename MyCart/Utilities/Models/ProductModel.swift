//
//  ProductModel.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation

// MARK: - WelcomeElement
public struct ProductModel: Codable {
    public let id: Int?
    public let title: String?
    public let price: Double?
    public let description: String?
    public let category: Category?
    public let image: String?
    public let rating: Rating?
    public let isFavourite: Bool?
}

public struct Category: Codable, Hashable {
    public let id: String?
    public let category: String?
    
    // For backward compatibility with the enum values
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self.id = stringValue
            self.category = stringValue
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.category = try container.decodeIfPresent(String.self, forKey: .category)
        }
    }
    
    init(id: String?, category: String?) {
        self.id = id
        self.category = category
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, category
    }
}

// MARK: - Rating
public struct Rating: Codable {
    public let rate: Double?
    public let count: Int?
}
