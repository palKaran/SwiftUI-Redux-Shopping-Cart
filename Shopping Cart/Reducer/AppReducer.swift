//
//  AppReducer.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

func appReducer(state: AppState, action: any Action) -> AppState {
    var newState = state

    // Route actions to appropriate sub-reducers
    newState.user = userReducer(state: state.user, action: action)
    newState.cart = cartReducer(
        state: state.cart,
        action: action,
        userState: newState.user, // Use updated user state
        products: state.products.items
    )
    newState.products = productReducer(state: state.products, action: action)
    newState.ui = uiReducer(state: state.ui, action: action)

    return newState
}
