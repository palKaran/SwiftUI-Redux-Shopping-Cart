//
//  Action.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


protocol Action {
    var type: String { get }
}

// Base action types that everything inherits from
protocol AppAction: Action {}
protocol UserAction: Action {}
protocol CartAction: Action {}
protocol ProductAction: Action {}
