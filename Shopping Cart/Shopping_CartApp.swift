//
//  Shopping_CartApp.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//

import SwiftUI

@main
struct Shopping_CartApp: App {
    let store: Store<AppState>

    init() {
        // Use mock store for development/demo
        #if DEBUG
        self.store = StoreFactory.createMockStore(shouldSimulateErrors: false)
        #else
        self.store = StoreFactory.createProductionStore()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView(store: self.store)
        }
    }
}
