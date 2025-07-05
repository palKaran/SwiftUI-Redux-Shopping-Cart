//
//  CartError.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

enum CartError: Error, Equatable, LocalizedError, Codable {
    case requiresLogin
    case invalidQuantity
    case cartFull
    case productNotFound
    case networkError(String)
    case persistenceError
    case checkoutFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .requiresLogin:
            return "Please log in to add items to your cart"
        case .invalidQuantity:
            return "Please select a valid quantity (1-99)"
        case .cartFull:
            return "Your cart is full. Please remove some items before adding more"
        case .productNotFound:
            return "This product is no longer available"
        case .networkError(let message):
            return "Network error: \(message)"
        case .persistenceError:
            return "Failed to save cart changes"
        case .checkoutFailed(let reason):
            return "Checkout failed: \(reason)"
        }
    }
}

enum UserError: Error, Equatable, LocalizedError, Codable {
    case authenticationFailed
    case networkError(String)
    case invalidCredentials
    case accountLocked
    case emailNotVerified
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed:
            return "Authentication failed. Please try again"
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidCredentials:
            return "Invalid email or password"
        case .accountLocked:
            return "Your account has been temporarily locked"
        case .emailNotVerified:
            return "Please verify your email address before logging in"
        }
    }
}

enum ProductError: Error, Equatable, LocalizedError {
    case networkError(Error)
    case parsingError
    case noProductsFound
    
    static func == (lhs: ProductError, rhs: ProductError) -> Bool {
        switch (lhs, rhs) {
        case (.parsingError, .parsingError),
             (.noProductsFound, .noProductsFound):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Failed to load products: \(error.localizedDescription)"
        case .parsingError:
            return "Failed to process product data"
        case .noProductsFound:
            return "No products available at the moment"
        }
    }
}
