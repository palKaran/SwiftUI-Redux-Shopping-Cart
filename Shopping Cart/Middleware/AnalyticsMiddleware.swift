//
//  AnalyticsMiddleware.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

struct AnalyticsMiddleware<State>: Middleware {
    func process(
        action: any Action,
        state: State,
        dispatch: @escaping (any Action) -> Void
    ) -> any Action {
        
        // Track user actions for product insights
        switch action {
        case let CartActions.addItem(productId, quantity):
            trackEvent("cart_item_added", parameters: [
                "product_id": productId,
                "quantity": quantity
            ])
            
        case CartActions.removeItem(let productId):
            trackEvent("cart_item_removed", parameters: [
                "product_id": productId
            ])
            
        case CartActions.initiateCheckout:
            if let appState = state as? AppState {
                trackEvent("checkout_initiated", parameters: [
                    "cart_value": appState.cart.items.reduce(0.0) { total, item in
                        // This would need product prices from state
                        return total + Double(item.quantity) * 10.0 // Placeholder
                    },
                    "item_count": appState.cart.totalItems
                ])
            }
            
        case CartActions.checkoutSuccess(let orderId):
            trackEvent("checkout_completed", parameters: [
                "order_id": orderId
            ])
            
        case UserActions.loginSuccess:
            trackEvent("user_login")
            
        case UserActions.registerSuccess:
            trackEvent("user_registration")
            
        case ProductActions.searchProducts(let query):
            trackEvent("product_search", parameters: [
                "query": query
            ])
            
        default:
            break
        }
        
        return action
    }
    
    private func trackEvent(_ eventName: String, parameters: [String: Any] = [:]) {
        // In a real app, this would send to your analytics service
        print("📊 Analytics: \(eventName) - \(parameters)")
        
        // Example: Firebase Analytics
        // Analytics.logEvent(eventName, parameters: parameters)
        
        // Example: Custom analytics service
        // AnalyticsService.shared.track(event: eventName, properties: parameters)
    }
}
