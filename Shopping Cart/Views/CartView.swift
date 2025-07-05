//
//  CartView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI

struct CartView: View {
    private var store: Store<AppState>
    @StateObject private var viewStore: ViewStore<CartViewState>

    init(store: Store<AppState>) {
        self.store = store
        self._viewStore = StateObject(wrappedValue: ViewStore(
            store: store,
            observe: { appState in
                CartViewState(
                    items: appState.cart.items,
                    isLoading: appState.cart.isLoading,
                    error: appState.cart.error,
                    isLoggedIn: appState.user.isLoggedIn,
                    isCheckingOut: appState.cart.isCheckingOut,
                    products: appState.products.items,
                    totalAmount: calculateTotal(cartItems: appState.cart.items, products: appState.products.items)
                )
            }
        ))
    }

    var body: some View {
        NavigationView {
            Group {
                if !viewStore.state.isLoggedIn {
                    loginPromptView
                } else if viewStore.state.isLoading {
                    loadingView
                } else if viewStore.state.items.isEmpty {
                    emptyCartView
                } else {
                    cartContentView
                }
            }
            .navigationTitle("Shopping Cart")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewStore.state.items.isEmpty && viewStore.state.isLoggedIn {
                        Button("Clear") {
                            viewStore.dispatch(CartActions.clearCart)
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Cart Error", isPresented: .constant(viewStore.state.error != nil)) {
                Button("OK") {
                    viewStore.dispatch(CartActions.clearError)
                }
            } message: {
                Text(viewStore.state.error?.localizedDescription ?? "")
            }
        }
        .onAppear {
            // CRITICAL: Update viewStore with environment store
            viewStore.updateStore(store)
            if viewStore.state.isLoggedIn {
                viewStore.dispatch(CartActions.loadCart)
            }
        }
        .onChange(of: store.state.cart.items) { _, _ in
            // Force refresh when cart items change
            viewStore.updateStore(store)
        }
    }

    private var loginPromptView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Please log in to view your cart")
                .font(.headline)
            
            Text("Sign in to add items to your cart and place orders")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Login") {
                viewStore.dispatch(UIActions.showLoginSheet)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
            Text("Loading your cart...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Your cart is empty")
                .font(.headline)
            
            Text("Browse our products and add items to get started")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Browse Products") {
                viewStore.dispatch(UIActions.setCurrentTab(.products))
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var cartContentView: some View {
        VStack(spacing: 0) {
            List {
                ForEach(viewStore.state.items) { item in
                    CartItemRowView(
                        item: item,
                        product: viewStore.state.products.first { $0.id == item.productId },
                        onQuantityChange: { newQuantity in
                            viewStore.dispatch(CartActions.updateQuantity(
                                productId: item.productId,
                                quantity: newQuantity
                            ))
                        },
                        onRemove: {
                            viewStore.dispatch(CartActions.removeItem(productId: item.productId))
                        }
                    )
                }
                .onDelete(perform: removeItems)
            }
            
            // Cart summary
            cartSummaryView
        }
    }
    
    private var cartSummaryView: some View {
        VStack(spacing: 16) {
            Divider()
            
            VStack(spacing: 8) {
                HStack {
                    Text("Subtotal:")
                    Spacer()
                    Text(viewStore.state.totalAmount, format: .currency(code: "USD"))
                }
                
                HStack {
                    Text("Tax:")
                    Spacer()
                    Text(viewStore.state.totalAmount * 0.08, format: .currency(code: "USD"))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Total:")
                        .font(.headline)
                    Spacer()
                    Text(viewStore.state.totalAmount * 1.08, format: .currency(code: "USD"))
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                viewStore.dispatch(CartActions.initiateCheckout)
            }) {
                HStack {
                    if viewStore.state.isCheckingOut {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text(viewStore.state.isCheckingOut ? "Processing..." : "Checkout")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewStore.state.isCheckingOut)
            .padding(.horizontal)
        }
        .background(Color(.systemBackground))
    }
    
    private func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = viewStore.state.items[index]
            viewStore.dispatch(CartActions.removeItem(productId: item.productId))
        }
    }
}

struct CartViewState: Equatable {
    let items: [CartItem]
    let isLoading: Bool
    let error: CartError?
    let isLoggedIn: Bool
    let isCheckingOut: Bool
    let products: [Product]
    let totalAmount: Double
}

// Helper function to calculate total
private func calculateTotal(cartItems: [CartItem], products: [Product]) -> Double {
    return cartItems.reduce(0.0) { total, item in
        if let product = products.first(where: { $0.id == item.productId }) {
            return total + (product.price * Double(item.quantity))
        }
        return total
    }
}
