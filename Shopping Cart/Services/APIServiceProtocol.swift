//
//  APIServiceProtocol.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

protocol APIServiceProtocol {
    func fetchProducts() async throws -> [Product]
    func fetchProducts(category: String) async throws -> [Product]
    func searchProducts(query: String) async throws -> [Product]
    func login(email: String, password: String) async throws -> User
    func register(email: String, password: String, name: String) async throws -> User
    func logout() async throws
    func fetchCart() async throws -> [CartItem]
    func addToCart(productId: String, quantity: Int) async throws
    func removeFromCart(productId: String) async throws
    func checkout() async throws -> String
}

final class APIService: APIServiceProtocol {
    private let baseURL = "https://api.yourstore.com/v1"
    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        // Configure date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
    }
    
    // MARK: - Product Methods
    
    func fetchProducts() async throws -> [Product] {
        let url = URL(string: "\(baseURL)/products")!
        let (data, response) = try await session.data(from: url)
        
        try validateResponse(response)
        
        let productsResponse = try decoder.decode(ProductsResponse.self, from: data)
        return productsResponse.products
    }
    
    func fetchProducts(category: String) async throws -> [Product] {
        var components = URLComponents(string: "\(baseURL)/products")!
        components.queryItems = [URLQueryItem(name: "category", value: category)]
        
        let (data, response) = try await session.data(from: components.url!)
        try validateResponse(response)
        
        let productsResponse = try decoder.decode(ProductsResponse.self, from: data)
        return productsResponse.products
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        var components = URLComponents(string: "\(baseURL)/products/search")!
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        
        let (data, response) = try await session.data(from: components.url!)
        try validateResponse(response)
        
        let productsResponse = try decoder.decode(ProductsResponse.self, from: data)
        return productsResponse.products
    }
    
    // MARK: - Authentication Methods
    
    func login(email: String, password: String) async throws -> User {
        let url = URL(string: "\(baseURL)/auth/login")!
        
        let loginRequest = LoginRequest(email: email, password: password)
        let requestData = try encoder.encode(loginRequest)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        
        let loginResponse = try decoder.decode(LoginResponse.self, from: data)
        
        // Store auth token for subsequent requests
        await storeAuthToken(loginResponse.token)
        
        return loginResponse.user
    }
    
    func register(email: String, password: String, name: String) async throws -> User {
        let url = URL(string: "\(baseURL)/auth/register")!
        
        let registerRequest = RegisterRequest(email: email, password: password, name: name)
        let requestData = try encoder.encode(registerRequest)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        
        let registerResponse = try decoder.decode(RegisterResponse.self, from: data)
        
        await storeAuthToken(registerResponse.token)
        
        return registerResponse.user
    }
    
    func logout() async throws {
        let url = URL(string: "\(baseURL)/auth/logout")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        try await addAuthHeader(to: &request)
        
        let (_, response) = try await session.data(for: request)
        try validateResponse(response)
        
        await clearAuthToken()
    }
    
    // MARK: - Cart Methods
    
    func fetchCart() async throws -> [CartItem] {
        let url = URL(string: "\(baseURL)/cart")!
        
        var request = URLRequest(url: url)
        try await addAuthHeader(to: &request)
        
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        
        let cartResponse = try decoder.decode(CartResponse.self, from: data)
        return cartResponse.items
    }
    
    func addToCart(productId: String, quantity: Int) async throws {
        let url = URL(string: "\(baseURL)/cart/items")!
        
        let addItemRequest = AddToCartRequest(productId: productId, quantity: quantity)
        let requestData = try encoder.encode(addItemRequest)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        try await addAuthHeader(to: &request)
        
        let (_, response) = try await session.data(for: request)
        try validateResponse(response)
    }
    
    func removeFromCart(productId: String) async throws {
        let url = URL(string: "\(baseURL)/cart/items/\(productId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        try await addAuthHeader(to: &request)
        
        let (_, response) = try await session.data(for: request)
        try validateResponse(response)
    }
    
    func checkout() async throws -> String {
        let url = URL(string: "\(baseURL)/checkout")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        try await addAuthHeader(to: &request)
        
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        
        let checkoutResponse = try decoder.decode(CheckoutResponse.self, from: data)
        return checkoutResponse.orderId
    }
    
    // MARK: - Helper Methods
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw APIError.unauthorized
        case 400:
            throw APIError.badRequest
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.unknown(httpResponse.statusCode)
        }
    }
    
    private func addAuthHeader(to request: inout URLRequest) async throws {
        guard let token = await getAuthToken() else {
            throw APIError.unauthorized
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    @MainActor
    private func storeAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "auth_token")
    }
    
    @MainActor
    private func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "auth_token")
    }
    
    @MainActor
    private func clearAuthToken() {
        UserDefaults.standard.removeObject(forKey: "auth_token")
    }
}

// MARK: - API Error Types

enum APIError: Error, LocalizedError {
    case invalidResponse
    case unauthorized
    case badRequest
    case notFound
    case serverError
    case unknown(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response received"
        case .unauthorized:
            return "Authentication required"
        case .badRequest:
            return "Invalid request"
        case .notFound:
            return "Resource not found"
        case .serverError:
            return "Server error occurred"
        case .unknown(let code):
            return "Unknown error (HTTP \(code))"
        }
    }
}

// MARK: - Request/Response Models

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let user: User
    let token: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
}

struct RegisterResponse: Codable {
    let user: User
    let token: String
}

struct ProductsResponse: Codable {
    let products: [Product]
    let totalCount: Int
    let page: Int
    let pageSize: Int
}

struct CartResponse: Codable {
    let items: [CartItem]
    let totalAmount: Double
    let itemCount: Int
}

struct AddToCartRequest: Codable {
    let productId: String
    let quantity: Int
}

struct CheckoutResponse: Codable {
    let orderId: String
    let totalAmount: Double
    let status: String
}
