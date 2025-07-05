//
//  CartReducer.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//
import Foundation

func cartReducer(state: CartState, action: any Action, userState: UserState, products: [Product]) -> CartState {
    var newState = state
    
    switch action {
    case let cartAction as CartActions:
        switch cartAction {
        case .addItem(let productId, let quantity):
            // Business rule: can't add to cart if not logged in
            guard userState.isLoggedIn else {
                newState.error = .requiresLogin
                return newState
            }
            
            // Validate quantity
            guard quantity > 0 && quantity <= 99 else {
                newState.error = .invalidQuantity
                return newState
            }
            
            // Check cart size limit
            guard newState.items.count < 50 else {
                newState.error = .cartFull
                return newState
            }
            
            // Verify product exists
            guard products.contains(where: { $0.id == productId }) else {
                newState.error = .productNotFound
                return newState
            }
            
            // Prevent rapid duplicate additions
            let now = Date()
            if let lastUpdate = newState.lastUpdated,
               now.timeIntervalSince(lastUpdate) < 0.5,
               newState.items.contains(where: { $0.productId == productId }) {
                return newState
            }
            
            // Add or update item
            if let existingIndex = newState.items.firstIndex(where: { $0.productId == productId }) {
                let newQuantity = newState.items[existingIndex].quantity + quantity
                newState.items[existingIndex].quantity = min(newQuantity, 99)
            } else {
                let newItem = CartItem(productId: productId, quantity: quantity, addedAt: now)
                newState.items.append(newItem)
            }
            
            newState.error = nil
            newState.lastUpdated = now
            
        case .removeItem(let productId):
            newState.items.removeAll { $0.productId == productId }
            newState.lastUpdated = Date()
            newState.error = nil
            
        case .updateQuantity(let productId, let quantity):
            if quantity <= 0 {
                newState.items.removeAll { $0.productId == productId }
            } else if let index = newState.items.firstIndex(where: { $0.productId == productId }) {
                newState.items[index].quantity = min(quantity, 99)
            }
            newState.lastUpdated = Date()
            
        case .clearCart:
            newState.items = []
            newState.error = nil
            newState.lastUpdated = Date()
            
        case .loadCart:
            guard !newState.isLoading else { return newState }
            newState.isLoading = true
            newState.error = nil
            
        case .cartLoaded(let items):
            newState.items = items
            newState.isLoading = false
            newState.error = nil
            newState.lastUpdated = Date()
            
        case .cartError(let error):
            newState.isLoading = false
            newState.error = error
            
        case .clearError:
            newState.error = nil
            
        case .initiateCheckout:
            guard !newState.items.isEmpty else {
                newState.error = .cartFull // Reuse error for empty cart
                return newState
            }
            guard userState.isLoggedIn else {
                newState.error = .requiresLogin
                return newState
            }
            newState.isCheckingOut = true
            newState.error = nil
            
        case .checkoutStarted:
            newState.isCheckingOut = true
            
        case .checkoutSuccess(let orderId):
            newState.items = []
            newState.isCheckingOut = false
            newState.checkoutOrderId = orderId
            newState.lastUpdated = Date()
            
        case .checkoutFailed(let error):
            newState.isCheckingOut = false
            newState.error = error
        }
        
    // Handle user logout - clear cart
    case let userAction as UserActions:
        switch userAction {
        case .logoutSuccess:
            newState.items = []
            newState.error = nil
            newState.isCheckingOut = false
            newState.checkoutOrderId = nil
        default:
            break
        }
        
    default:
        break
    }
    
    return newState
}
