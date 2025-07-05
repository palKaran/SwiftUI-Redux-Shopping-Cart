//
//  AppState.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


struct AppState: Equatable {
    var user: UserState
    var cart: CartState
    var products: ProductState
    var ui: UIState
    
    static let initial = AppState(
        user: UserState.initial,
        cart: CartState.initial,
        products: ProductState.initial,
        ui: UIState.initial
    )
}
