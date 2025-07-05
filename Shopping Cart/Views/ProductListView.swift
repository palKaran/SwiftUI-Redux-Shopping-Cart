//
//  ProductListView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI

struct ProductListView: View {
    private var store: Store<AppState>
    @StateObject private var viewStore: ViewStore<ProductListViewState>
    @State private var searchText = ""

    init(store: Store<AppState>) {
        self.store = store
        self._viewStore = StateObject(wrappedValue: ViewStore(
            store: store,
            observe: { appState in
                ProductListViewState(
                    products: appState.products.displayedProducts,
                    isLoading: appState.products.isLoading,
                    error: appState.products.error,
                    categories: appState.products.categories,
                    currentFilters: appState.products.currentFilters,
                    isLoggedIn: appState.user.isLoggedIn
                )
            }
        ))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewStore.state.isLoading && viewStore.state.products.isEmpty {
                    loadingView
                } else if let error = viewStore.state.error {
                    errorView(error)
                } else {
                    productListContent
                }
            }
            .navigationTitle("Products")
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, query in
                if query.isEmpty {
                    viewStore.dispatch(ProductActions.clearFilters)
                } else {
                    viewStore.dispatch(ProductActions.searchProducts(query: query))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewStore.state.isLoggedIn {
                        Button("Login") {
                            viewStore.dispatch(UIActions.showLoginSheet)
                        }
                    }
                }
            }
            .refreshable {
                viewStore.dispatch(ProductActions.loadProducts)
            }
        }
        .onAppear {
            // CRITICAL: Update viewStore with environment store
            viewStore.updateStore(store)
            if viewStore.state.products.isEmpty {
                viewStore.dispatch(ProductActions.loadProducts)
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
            Text("Loading products...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ error: ProductError) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Oops! Something went wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                viewStore.dispatch(ProductActions.loadProducts)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var productListContent: some View {
        List {
            if !viewStore.state.categories.isEmpty {
                categoryFilterSection
            }
            
            ForEach(viewStore.state.products) { product in
                ProductRowView(
                    product: product,
                    canAddToCart: viewStore.state.isLoggedIn,
                    onAddToCart: { quantity in
                        viewStore.dispatch(CartActions.addItem(productId: product.id, quantity: quantity))
                    }
                )
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var categoryFilterSection: some View {
        Section("Categories") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewStore.state.categories, id: \.self) { category in
                        CategoryFilterChip(
                            category: category,
                            isSelected: viewStore.state.currentFilters.contains(.category(category)),
                            onTap: {
                                viewStore.dispatch(ProductActions.applyFilter(.category(category)))
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProductListViewState: Equatable {
    let products: [Product]
    let isLoading: Bool
    let error: ProductError?
    let categories: [String]
    let currentFilters: [ProductFilter]
    let isLoggedIn: Bool
}
