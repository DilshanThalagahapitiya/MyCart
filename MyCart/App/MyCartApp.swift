//
//  MyCartApp.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import SwiftUI

@main
struct MyCartApp: App {
    let persistenceController = PersistenceController.shared
    @ObservedObject var router = Router()



    var body: some Scene {
        WindowGroup {
            Group {
                NavigationStack(path: $router.navigationPath) {
                    ViewFactory.shared.setRootView()
                        .navigationDestination(for: Destination.self) { destination in
                            ViewFactory.shared.setViewForDestination(destination, router.getData())
                        }
                }
                .environmentObject(router)
            }
        }
    }
}
