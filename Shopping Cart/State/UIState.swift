//
//  UIState.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//
import Foundation

struct UIState: Equatable {
    var isNetworkConnected: Bool
    var currentTab: AppTab
    var showingLoginSheet: Bool
    var showingCartSheet: Bool
    var toast: ToastMessage?
    
    static let initial = UIState(
        isNetworkConnected: true,
        currentTab: .products,
        showingLoginSheet: false,
        showingCartSheet: false,
        toast: nil
    )
}

enum AppTab: String, CaseIterable {
    case products = "Products"
    case cart = "Cart"
    case profile = "Profile"
    
    var iconName: String {
        switch self {
        case .products: return "list.bullet"
        case .cart: return "cart"
        case .profile: return "person"
        }
    }
}

struct ToastMessage: Equatable {
    let message: String
    let type: ToastType
    let duration: TimeInterval
    
    enum ToastType {
        case success
        case error
        case info
    }
}
