//
//  ProductReducer.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//



func productReducer(state: ProductState, action: any Action) -> ProductState {
    var newState = state
    
    switch action {
    case let productAction as ProductActions:
        switch productAction {
        case .loadProducts, .loadProductsByCategory:
            newState.isLoading = true
            newState.error = nil
            
        case .searchProducts(let query):
            newState.searchQuery = query
            newState.isLoading = true
            newState.error = nil
            
        case .productsLoaded(let products):
            newState.items = products
            newState.isLoading = false
            newState.error = nil
            
            // Extract unique categories
            let categories = Array(Set(products.map { $0.category })).sorted()
            newState.categories = categories
            
            // Apply current filters and sorting
            newState.filteredItems = applyFiltersAndSorting(
                products: products,
                filters: newState.currentFilters,
                sorting: newState.currentSorting,
                searchQuery: newState.searchQuery
            )
            
        case .searchResultsLoaded(let products):
            newState.filteredItems = products
            newState.isLoading = false
            newState.error = nil
            
        case .productsError(let error):
            newState.isLoading = false
            newState.error = error
            
        case .applyFilter(let filter):
            // Add filter if not already present
            if !newState.currentFilters.contains(filter) {
                newState.currentFilters.append(filter)
            }
            
            // Reapply all filters
            newState.filteredItems = applyFiltersAndSorting(
                products: newState.items,
                filters: newState.currentFilters,
                sorting: newState.currentSorting,
                searchQuery: newState.searchQuery
            )
            
        case .applySorting(let sorting):
            newState.currentSorting = sorting
            
            // Reapply sorting to current filtered products
            newState.filteredItems = applyFiltersAndSorting(
                products: newState.items,
                filters: newState.currentFilters,
                sorting: sorting,
                searchQuery: newState.searchQuery
            )
            
        case .clearFilters:
            newState.currentFilters = []
            newState.searchQuery = ""
            newState.filteredItems = applySorting(
                products: newState.items,
                sorting: newState.currentSorting
            )
        }
        
    default:
        break
    }
    
    return newState
}

// Helper functions for filtering and sorting
private func applyFiltersAndSorting(
    products: [Product],
    filters: [ProductFilter],
    sorting: ProductSorting?,
    searchQuery: String
) -> [Product] {
    var filteredProducts = products
    
    // Apply search query
    if !searchQuery.isEmpty {
        filteredProducts = filteredProducts.filter { product in
            product.name.localizedCaseInsensitiveContains(searchQuery) ||
            product.description.localizedCaseInsensitiveContains(searchQuery) ||
            product.category.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    // Apply filters
    for filter in filters {
        switch filter {
        case .category(let category):
            filteredProducts = filteredProducts.filter { $0.category == category }
            
        case .priceRange(let min, let max):
            filteredProducts = filteredProducts.filter { product in
                product.price >= min && product.price <= max
            }
            
        case .inStockOnly:
            filteredProducts = filteredProducts.filter { $0.isAvailable }
            
        case .rating(let minimum):
            // Assuming products have a rating property (would need to add this)
            filteredProducts = filteredProducts.filter { _ in
                // Placeholder - would implement actual rating filtering
                true
            }
        }
    }
    
    return applySorting(products: filteredProducts, sorting: sorting)
}

private func applySorting(products: [Product], sorting: ProductSorting?) -> [Product] {
    guard let sorting = sorting else { return products }
    
    switch sorting {
    case .name:
        return products.sorted { $0.name < $1.name }
        
    case .priceAscending:
        return products.sorted { $0.price < $1.price }
        
    case .priceDescending:
        return products.sorted { $0.price > $1.price }
        
    case .newest:
        // Assuming products have a createdAt property (would need to add this)
        return products.sorted { _, _ in
            // Placeholder - would implement actual date sorting
            false
        }
        
    case .rating:
        // Assuming products have a rating property (would need to add this)
        return products.sorted { _, _ in
            // Placeholder - would implement actual rating sorting
            false
        }
    }
}
