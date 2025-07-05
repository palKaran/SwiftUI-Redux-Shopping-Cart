//
//  CartState.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//
import Foundation

struct CartState: Equatable, Codable {
    var items: [CartItem]
    var isLoading: Bool
    var error: CartError?
    var lastUpdated: Date?
    var isCheckingOut: Bool
    var checkoutOrderId: String?
    
    static let initial = CartState(
        items: [],
        isLoading: false,
        error: nil,
        lastUpdated: nil,
        isCheckingOut: false,
        checkoutOrderId: nil
    )
    
    // Computed properties for convenience
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var hasItems: Bool {
        !items.isEmpty
    }
}
