//
//  Store.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation
import Combine
import SwiftUI

@MainActor
final class Store<State>: ObservableObject {
    @Published private(set) var state: State
    
    private let reducer: (State, any Action) -> State
    private var middleware: [any Middleware<State>] = []

    init(
        initialState: State,
        reducer: @escaping (State, any Action) -> State,
        middleware: [any Middleware<State>] = []
    ) {
        self.state = initialState
        self.reducer = reducer
        self.middleware = middleware
    }
    
    func dispatch(_ action: any Action) {
        // Apply middleware first
        let finalAction = middleware.reduce(action) { currentAction, middleware in
            middleware.process(action: currentAction, state: state, dispatch: dispatch)
        }
        
        // Update state with reducer
        state = reducer(state, finalAction)
    }
}
