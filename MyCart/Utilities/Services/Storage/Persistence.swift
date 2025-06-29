//
//  Persistence.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create a sample cart
        let cart = Cart(context: viewContext)
        cart.id = UUID().uuidString
        cart.createdAt = Date()
        cart.updatedAt = Date()
        
        // Create sample cart items
        for i in 0..<5 {
            let cartItem = CartItem(context: viewContext)
            cartItem.id = UUID().uuidString
            cartItem.title = "Sample Product \(i + 1)"
            cartItem.productDescription = "This is a sample product description for item \(i + 1)"
            cartItem.price = Double.random(in: 10.0...100.0)
            cartItem.quantity = Int32.random(in: 1...5)
            cartItem.category = "Electronics"
            cartItem.rating = Double.random(in: 1.0...5.0)
            cartItem.ratingCount = Int32.random(in: 10...500)
            cartItem.image = "sample_image_\(i + 1)"
            cartItem.addedAt = Date()
            cartItem.productId = Int32(i + 1)
            cartItem.cart = cart
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyCart")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
