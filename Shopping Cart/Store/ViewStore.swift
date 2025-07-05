//
//  ViewStore.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI
import Combine

@MainActor
final class ViewStore<ViewState: Equatable>: ObservableObject {
    @Published var state: ViewState

    private var store: Store<AppState>
    private var cancellable: AnyCancellable?
    private let observe: (AppState) -> ViewState

    init(
        store: Store<AppState>,
        observe: @escaping (AppState) -> ViewState
    ) {
        self.store = store
        self.observe = observe
        self.state = observe(store.state)

        setupBinding()
    }

    func updateStore(_ newStore: Store<AppState>) {
        self.store = newStore
        self.state = observe(newStore.state) // Immediately update state
        setupBinding()
    }

    private func setupBinding() {
        cancellable?.cancel()
        cancellable = store.$state
            .map(observe)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
    }

    func dispatch(_ action: any Action) {
        store.dispatch(action)
    }

    deinit {
        cancellable?.cancel()
    }
}

// Extension to make ViewStore easier to use with Environment
extension ViewStore {
    convenience init(
        observe: @escaping (AppState) -> ViewState
    ) {
        // This will be updated when the view appears with the actual environment store
        self.init(
            store: StoreEnvironmentKey.defaultValue,
            observe: observe
        )
    }
}
