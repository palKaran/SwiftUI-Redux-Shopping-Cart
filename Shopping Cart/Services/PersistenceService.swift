//
//  PersistenceService.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

final class PersistenceService {
    private let userDefaults = UserDefaults.standard
    
    func saveCart(_ items: [CartItem]) async throws {
        let data = try JSONEncoder().encode(items)
        userDefaults.set(data, forKey: "cart_items")
    }
    
    func loadCart() async throws -> [CartItem] {
        guard let data = userDefaults.data(forKey: "cart_items") else {
            return []
        }
        return try JSONDecoder().decode([CartItem].self, from: data)
    }
}
