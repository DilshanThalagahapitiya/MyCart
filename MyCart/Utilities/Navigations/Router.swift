//
//  Router.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
    private var data: Any?

    func navigate(to destination: Destination, _ data: Any? = nil) {
        self.data = data
        navigationPath.append(destination)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func navigetBackToCustomView(_ last: Int = 1){
        navigationPath.removeLast(last)
    }
    
    func getData() -> Any?{
        return data
    }
}
