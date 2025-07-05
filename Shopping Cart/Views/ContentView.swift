//
//  ContentView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 04/07/25.
//

import SwiftUI

struct ContentView: View {
    private var store: Store<AppState>
    @StateObject private var viewStore: ViewStore<ContentViewState>

    init(store: Store<AppState>) {
        self.store = store
        // We'll inject the store through environment
        self._viewStore = StateObject(wrappedValue: ViewStore(
            store: store,
            observe: { appState in
                ContentViewState(
                    currentTab: appState.ui.currentTab,
                    isLoggedIn: appState.user.isLoggedIn,
                    cartItemCount: appState.cart.totalItems,
                    showingLoginSheet: appState.ui.showingLoginSheet,
                    toast: appState.ui.toast
                )
            }
        ))
    }

    var body: some View {
        TabView(selection: Binding(
            get: { viewStore.state.currentTab },
            set: { viewStore.dispatch(UIActions.setCurrentTab($0)) }
        )) {

            ProductListView(store: store)
                .tabItem {
                    Image(systemName: AppTab.products.iconName)
                    Text(AppTab.products.rawValue)
                }
                .tag(AppTab.products)

            CartView(store: store)
                .tabItem {
                    Image(systemName: AppTab.cart.iconName)
                    Text(AppTab.cart.rawValue)
                }
                .badge(viewStore.state.cartItemCount > 0 ? "\(viewStore.state.cartItemCount)" : nil)
                .tag(AppTab.cart)

            ProfileView(store: store)
                .tabItem {
                    Image(systemName: AppTab.profile.iconName)
                    Text(AppTab.profile.rawValue)
                }
                .tag(AppTab.profile)
        }
        .sheet(isPresented: Binding(
            get: { viewStore.state.showingLoginSheet },
            set: { _ in viewStore.dispatch(UIActions.hideLoginSheet) }
        )) {
            LoginView(store: store)
        }
        .overlay(alignment: .top) {
            if let toast = viewStore.state.toast {
                ToastView(message: toast)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                            viewStore.dispatch(UIActions.hideToast)
                        }
                    }
            }
        }
        .onAppear {
            // Update viewStore to use environment store
            updateViewStore()
        }
    }

    private func updateViewStore() {
        // This is a workaround for environment injection
        viewStore.updateStore(store)
    }
}

struct ContentViewState: Equatable {
    let currentTab: AppTab
    let isLoggedIn: Bool
    let cartItemCount: Int
    let showingLoginSheet: Bool
    let toast: ToastMessage?
}

#Preview {
    ContentView(store: StoreEnvironmentKey.defaultValue)
}
