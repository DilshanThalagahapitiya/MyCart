//
//  userDefaults.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import Foundation

struct userDefaults {
    @CodableUserDefault(key: UserDefaultsKeys.user, defaultValue: nil)
    static var localUser: UserModel?
    @UserDefault(UserDefaultsKeys.isOnboard, defaultValue: false)
    static var isOnBoard: Bool
    @UserDefault(UserDefaultsKeys.authToken, defaultValue: "")
    static var authToken: String
    @UserDefault(UserDefaultsKeys.guest, defaultValue: false)
    static var guest: Bool
}

struct UserDefaultsKeys {
    static let user = "USER"
    static let isOnboard = "IS_ONBOARD"
    static let authToken = "AUTH_TOKEN"
    static let guest = "GUEST"
}

@propertyWrapper
struct CodableUserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.userDefaults.data(forKey: key),
                  let value = try? JSONDecoder().decode(T.self, from: data) else {
                return defaultValue
            }
            return value
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            UserDefaults.userDefaults.set(data, forKey: key)
        }
    }
}


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.userDefaults.set(newValue, forKey: key)
        }
    }
}


extension UserDefaults {
    static let userDefaults = UserDefaults.standard
}
