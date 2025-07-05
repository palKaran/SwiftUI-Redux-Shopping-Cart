//
//  MockData.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

struct MockData {
    static let products: [Product] = [
        Product(
            id: "1",
            name: "iPhone 15 Pro",
            description: "The latest iPhone with titanium design and advanced camera system",
            price: 999.99,
            imageURL: "https://via.placeholder.com/300x300/007AFF/FFFFFF?text=iPhone",
            category: "Electronics",
            inStock: true,
            stockQuantity: 15
        ),
        Product(
            id: "2",
            name: "MacBook Air M2",
            description: "Supercharged by M2 chip. Incredibly capable. Impossibly thin.",
            price: 1199.99,
            imageURL: "https://via.placeholder.com/300x300/007AFF/FFFFFF?text=MacBook",
            category: "Electronics",
            inStock: true,
            stockQuantity: 8
        ),
        Product(
            id: "3",
            name: "Nike Air Max 270",
            description: "Comfortable running shoes with maximum air cushioning",
            price: 150.00,
            imageURL: "https://via.placeholder.com/300x300/FF6B35/FFFFFF?text=Nike",
            category: "Footwear",
            inStock: true,
            stockQuantity: 25
        ),
        Product(
            id: "4",
            name: "Levi's 501 Jeans",
            description: "Classic straight fit jeans. The original blue jean since 1873.",
            price: 89.99,
            imageURL: "https://via.placeholder.com/300x300/4A90E2/FFFFFF?text=Levis",
            category: "Clothing",
            inStock: true,
            stockQuantity: 30
        ),
        Product(
            id: "5",
            name: "Sony WH-1000XM4",
            description: "Industry-leading noise canceling wireless headphones",
            price: 349.99,
            imageURL: "https://via.placeholder.com/300x300/000000/FFFFFF?text=Sony",
            category: "Electronics",
            inStock: false,
            stockQuantity: 0
        ),
        Product(
            id: "6",
            name: "The North Face Jacket",
            description: "Waterproof and breathable outdoor jacket for all seasons",
            price: 199.99,
            imageURL: "https://via.placeholder.com/300x300/2ECC71/FFFFFF?text=TNF",
            category: "Clothing",
            inStock: true,
            stockQuantity: 12
        ),
        Product(
            id: "7",
            name: "Adidas Ultraboost 22",
            description: "Energy-returning running shoes with responsive BOOST midsole",
            price: 180.00,
            imageURL: "https://via.placeholder.com/300x300/E74C3C/FFFFFF?text=Adidas",
            category: "Footwear",
            inStock: true,
            stockQuantity: 18
        ),
        Product(
            id: "8",
            name: "Patagonia Backpack",
            description: "Durable 25L backpack perfect for daily commutes and weekend adventures",
            price: 129.99,
            imageURL: "https://via.placeholder.com/300x300/9B59B6/FFFFFF?text=Patagonia",
            category: "Accessories",
            inStock: true,
            stockQuantity: 22
        )
    ]
    
    static let cartItems: [CartItem] = [
        CartItem(productId: "1", quantity: 1, addedAt: Date().addingTimeInterval(-3600)),
        CartItem(productId: "3", quantity: 2, addedAt: Date().addingTimeInterval(-1800))
    ]
    
    static func createUser(email: String, name: String = "John Doe") -> User {
        User(
            id: UUID().uuidString,
            email: email,
            name: name,
            isEmailVerified: email != "unverified@example.com",
            createdAt: Date()
        )
    }
}
