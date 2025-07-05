//
//  UIReducer.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//



func uiReducer(state: UIState, action: any Action) -> UIState {
    var newState = state
    
    switch action {
    // Handle UI-specific actions
    case let uiAction as UIActions:
        switch uiAction {
        case .setCurrentTab(let tab):
            newState.currentTab = tab
            
        case .showLoginSheet:
            newState.showingLoginSheet = true
            
        case .hideLoginSheet:
            newState.showingLoginSheet = false
            
        case .showCartSheet:
            newState.showingCartSheet = true
            
        case .hideCartSheet:
            newState.showingCartSheet = false
            
        case .showToast(let message):
            newState.toast = message
            
        case .hideToast:
            newState.toast = nil
            
        case .setNetworkStatus(let isConnected):
            newState.isNetworkConnected = isConnected
        }
        
    // Handle side effects from other actions
    case CartActions.addItem:
        newState.toast = ToastMessage(
            message: "Item added to cart",
            type: .success,
            duration: 2.0
        )
        
    case CartActions.removeItem:
        newState.toast = ToastMessage(
            message: "Item removed from cart",
            type: .info,
            duration: 2.0
        )
        
    case CartActions.checkoutSuccess:
        newState.toast = ToastMessage(
            message: "Order placed successfully!",
            type: .success,
            duration: 3.0
        )
        newState.showingCartSheet = false
        
    case let CartActions.cartError(error):
        newState.toast = ToastMessage(
            message: error.localizedDescription,
            type: .error,
            duration: 3.0
        )
        
    case UserActions.loginSuccess:
        newState.showingLoginSheet = false
        newState.toast = ToastMessage(
            message: "Welcome back!",
            type: .success,
            duration: 2.0
        )
        
    case let UserActions.loginError(error):
        newState.toast = ToastMessage(
            message: error.localizedDescription,
            type: .error,
            duration: 3.0
        )
        
    case UserActions.logoutSuccess:
        newState.currentTab = .products
        newState.toast = ToastMessage(
            message: "Logged out successfully",
            type: .info,
            duration: 2.0
        )
        
    default:
        break
    }
    
    return newState
}
