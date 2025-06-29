//
//  Destination+ViewFactory.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation
import SwiftUI

public enum Destination: String {
    // MARK: - APP STATES

    case main
    case home
    case cart
    case viewProduct

}


class ViewFactory {
    
    static let shared = ViewFactory()
    
    init(){}
    // MARK: - GET UI VIEW FOR STATE

    func setViewForDestination(_ destination: Destination,  _ data: Any? = nil) -> AnyView {
        switch destination {
            
        case .main:
            return AnyView(TabBarView(vm: TabBarVM(selectedTab: .homeView)))
        case .home:
            return AnyView(HomeView(hideTabBar: .constant(false)))
        case .viewProduct:
            return AnyView(ViewProductView(vm: data as! ViewProductVM))
        case .cart:
            return AnyView(CartView(hideTabBar: .constant(false)))

        }
        
    }
    
    func setRootView() -> AnyView {
        return self.setViewForDestination(.main)
    }
}

