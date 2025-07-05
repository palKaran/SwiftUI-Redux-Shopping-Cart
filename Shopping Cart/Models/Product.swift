//
//  Product.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageURL: String?
    let category: String
    let inStock: Bool
    let stockQuantity: Int
    
    var isAvailable: Bool {
        return inStock && stockQuantity > 0
    }
}
