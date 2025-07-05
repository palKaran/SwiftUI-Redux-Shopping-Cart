//
//  Middleware.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


protocol Middleware<State> {
    associatedtype State
    
    func process(
        action: any Action,
        state: State,
        dispatch: @escaping (any Action) -> Void
    ) -> any Action
}
