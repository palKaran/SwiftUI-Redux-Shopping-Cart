//
//  CartItem.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

struct CartItem: Identifiable, Codable, Equatable {
    let id: UUID
    let productId: String
    var quantity: Int
    let addedAt: Date
    
    // Computed properties for convenience
    var product: Product? {
        // This would be resolved from the products state
        return nil // We'll handle this in the view store
    }
    
    var price: Double {
        // This would come from the associated product
        return 0.0 // We'll handle this in the view store
    }
    
    init(productId: String, quantity: Int, addedAt: Date = Date()) {
        self.id = UUID()
        self.productId = productId
        self.quantity = quantity
        self.addedAt = addedAt
    }
}
