//
//  CartActions.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


enum CartActions: CartAction {
    // User-initiated actions
    case addItem(productId: String, quantity: Int = 1)
    case removeItem(productId: String)
    case updateQuantity(productId: String, quantity: Int)
    case clearCart
    case initiateCheckout
    
    // System actions
    case loadCart
    case cartLoaded([CartItem])
    case cartError(CartError)
    case clearError
    
    // Checkout flow
    case checkoutStarted
    case checkoutSuccess(orderId: String)
    case checkoutFailed(CartError)
    
    var type: String {
        switch self {
        case .addItem: return "CART_ADD_ITEM"
        case .removeItem: return "CART_REMOVE_ITEM"
        case .updateQuantity: return "CART_UPDATE_QUANTITY"
        case .clearCart: return "CART_CLEAR"
        case .initiateCheckout: return "CART_INITIATE_CHECKOUT"
        case .loadCart: return "CART_LOAD"
        case .cartLoaded: return "CART_LOADED"
        case .cartError: return "CART_ERROR"
        case .clearError: return "CART_CLEAR_ERROR"
        case .checkoutStarted: return "CART_CHECKOUT_STARTED"
        case .checkoutSuccess: return "CART_CHECKOUT_SUCCESS"
        case .checkoutFailed: return "CART_CHECKOUT_FAILED"
        }
    }
}
