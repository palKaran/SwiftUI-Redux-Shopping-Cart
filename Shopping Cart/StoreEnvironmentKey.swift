//
//  StoreEnvironmentKey.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//
import SwiftUI

@MainActor
struct StoreEnvironmentKey: @preconcurrency EnvironmentKey {
    static let defaultValue: Store<AppState> = StoreFactory.createMockStore()
}

extension EnvironmentValues {
    var store: Store<AppState> {
        get { self[StoreEnvironmentKey.self] }
        set { self[StoreEnvironmentKey.self] = newValue }
    }
}
