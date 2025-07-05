//
//  ProductActions.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


enum ProductActions: ProductAction {
    // Loading products
    case loadProducts
    case loadProductsByCategory(String)
    case searchProducts(query: String)
    
    // Success cases
    case productsLoaded([Product])
    case searchResultsLoaded([Product])
    
    // Error cases
    case productsError(ProductError)
    
    // Filters and sorting
    case applyFilter(ProductFilter)
    case applySorting(ProductSorting)
    case clearFilters
    
    var type: String {
        switch self {
        case .loadProducts: return "PRODUCTS_LOAD"
        case .loadProductsByCategory: return "PRODUCTS_LOAD_BY_CATEGORY"
        case .searchProducts: return "PRODUCTS_SEARCH"
        case .productsLoaded: return "PRODUCTS_LOADED"
        case .searchResultsLoaded: return "PRODUCTS_SEARCH_RESULTS_LOADED"
        case .productsError: return "PRODUCTS_ERROR"
        case .applyFilter: return "PRODUCTS_APPLY_FILTER"
        case .applySorting: return "PRODUCTS_APPLY_SORTING"
        case .clearFilters: return "PRODUCTS_CLEAR_FILTERS"
        }
    }
}

enum ProductFilter: Equatable {
    case category(String)
    case priceRange(min: Double, max: Double)
    case inStockOnly
    case rating(minimum: Double)
}

enum ProductSorting: Equatable {
    case name
    case priceAscending
    case priceDescending
    case newest
    case rating
}
