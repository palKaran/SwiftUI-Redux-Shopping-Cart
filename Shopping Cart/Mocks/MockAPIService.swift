//
//  MockAPIService.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
// 


import Foundation

final class MockAPIService: APIServiceProtocol {
    private let delay: TimeInterval
    private let shouldSimulateErrors: Bool
    
    init(delay: TimeInterval = 1.0, shouldSimulateErrors: Bool = false) {
        self.delay = delay
        self.shouldSimulateErrors = shouldSimulateErrors
    }
    
    func fetchProducts() async throws -> [Product] {
        try await simulateNetworkDelay()
        
        if shouldSimulateErrors && Bool.random() {
            throw APIError.serverError
        }
        
        return MockData.products
    }
    
    func fetchProducts(category: String) async throws -> [Product] {
        try await simulateNetworkDelay()
        
        return MockData.products.filter { $0.category == category }
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        try await simulateNetworkDelay()
        
        return MockData.products.filter { product in
            product.name.localizedCaseInsensitiveContains(query) ||
            product.description.localizedCaseInsensitiveContains(query) ||
            product.category.localizedCaseInsensitiveContains(query)
        }
    }
    
    func login(email: String, password: String) async throws -> User {
        try await simulateNetworkDelay()
        
        // Simulate login validation
        guard email.contains("@") && password.count >= 6 else {
            throw APIError.badRequest
        }
        
        // Simulate different user scenarios
        if email == "locked@example.com" {
            throw APIError.unauthorized
        }
        
        if email == "error@example.com" {
            throw APIError.serverError
        }
        
        return MockData.createUser(email: email)
    }
    
    func register(email: String, password: String, name: String) async throws -> User {
        try await simulateNetworkDelay()
        
        // Simulate validation
        guard email.contains("@") && password.count >= 6 && !name.isEmpty else {
            throw APIError.badRequest
        }
        
        // Simulate existing user
        if email == "existing@example.com" {
            throw APIError.badRequest
        }
        
        return MockData.createUser(email: email, name: name)
    }
    
    func logout() async throws {
        try await simulateNetworkDelay()
        // Logout always succeeds in mock
    }
    
    func fetchCart() async throws -> [CartItem] {
        try await simulateNetworkDelay()
        
        // Return some mock cart items
        return MockData.cartItems
    }
    
    func addToCart(productId: String, quantity: Int) async throws {
        try await simulateNetworkDelay()
        
        // Simulate out of stock error
        if productId == "out-of-stock-product" {
            throw APIError.badRequest
        }
        
        // Success - no return needed
    }
    
    func removeFromCart(productId: String) async throws {
        try await simulateNetworkDelay()
        // Success - no return needed
    }
    
    func checkout() async throws -> String {
        try await simulateNetworkDelay()
        
        // Simulate checkout failure sometimes
        if shouldSimulateErrors && Bool.random() {
            throw APIError.serverError
        }
        
        return "ORDER-\(UUID().uuidString.prefix(8))"
    }
    
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
}
