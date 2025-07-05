//
//  ProductState.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


struct ProductState: Equatable {
    var items: [Product]
    var filteredItems: [Product]
    var isLoading: Bool
    var error: ProductError?
    var searchQuery: String
    var currentFilters: [ProductFilter]
    var currentSorting: ProductSorting?
    var categories: [String]
    
    static let initial = ProductState(
        items: [],
        filteredItems: [],
        isLoading: false,
        error: nil,
        searchQuery: "",
        currentFilters: [],
        currentSorting: nil,
        categories: []
    )
    
    var hasProducts: Bool {
        !items.isEmpty
    }
    
    var displayedProducts: [Product] {
        filteredItems.isEmpty ? items : filteredItems
    }
}
