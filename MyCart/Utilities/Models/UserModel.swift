//
//  UserModel.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation

struct UserModel: Codable {
    var email: String?
    var password: String?
    var name: String?
    var isProfileCompleted: Bool?
    var isActive: Bool?
}
