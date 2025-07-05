//
//  PersistenceMiddleware.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

struct PersistenceMiddleware<State>: Middleware {
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func process(
        action: any Action,
        state: State,
        dispatch: @escaping (any Action) -> Void
    ) -> any Action {
        
        // Save state changes to UserDefaults
        switch action {
        case is CartActions:
            if let appState = state as? AppState {
                saveCartState(appState.cart)
            }
            
        case UserActions.loginSuccess(let user):
            if let appState = state as? AppState {
                saveUserState(appState.user)
                saveAuthToken(user)
            }
            
        case UserActions.logoutSuccess:
            clearUserData()
            clearCartData()
            
        case ProductActions.productsLoaded(let products):
            // Cache products for offline access
            cacheProducts(products)
            
        default:
            break
        }
        
        return action
    }
    
    private func saveCartState(_ cartState: CartState) {
        do {
            let data = try encoder.encode(cartState.items)
            userDefaults.set(data, forKey: "cart_items")
            userDefaults.set(cartState.lastUpdated, forKey: "cart_last_updated")
        } catch {
            print("Failed to save cart state: \(error)")
        }
    }
    
    private func saveUserState(_ userState: UserState) {
        do {
            if let user = userState.currentUser {
                let data = try encoder.encode(user)
                userDefaults.set(data, forKey: "current_user")
            }
            userDefaults.set(userState.isLoggedIn, forKey: "is_logged_in")
            userDefaults.set(userState.lastLoginDate, forKey: "last_login_date")
        } catch {
            print("Failed to save user state: \(error)")
        }
    }
    
    private func saveAuthToken(_ user: User) {
        // In a real app, you'd save this to Keychain for security
        userDefaults.set("auth_token_\(user.id)", forKey: "auth_token")
    }
    
    private func cacheProducts(_ products: [Product]) {
        do {
            let data = try encoder.encode(products)
            userDefaults.set(data, forKey: "cached_products")
            userDefaults.set(Date(), forKey: "products_cache_date")
        } catch {
            print("Failed to cache products: \(error)")
        }
    }
    
    private func clearUserData() {
        userDefaults.removeObject(forKey: "current_user")
        userDefaults.removeObject(forKey: "is_logged_in")
        userDefaults.removeObject(forKey: "auth_token")
        userDefaults.removeObject(forKey: "last_login_date")
    }
    
    private func clearCartData() {
        userDefaults.removeObject(forKey: "cart_items")
        userDefaults.removeObject(forKey: "cart_last_updated")
    }
}

// Extension to help load persisted state
extension PersistenceMiddleware {
    static func loadPersistedState() -> AppState {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        var state = AppState.initial
        
        // Load user state
        if let userData = userDefaults.data(forKey: "current_user"),
           let user = try? decoder.decode(User.self, from: userData) {
            state.user.currentUser = user
            state.user.isLoggedIn = userDefaults.bool(forKey: "is_logged_in")
            state.user.lastLoginDate = userDefaults.object(forKey: "last_login_date") as? Date
            state.user.authToken = userDefaults.string(forKey: "auth_token")
        }
        
        // Load cart state
        if let cartData = userDefaults.data(forKey: "cart_items"),
           let cartItems = try? decoder.decode([CartItem].self, from: cartData) {
            state.cart.items = cartItems
            state.cart.lastUpdated = userDefaults.object(forKey: "cart_last_updated") as? Date
        }
        
        // Load cached products
        if let productsData = userDefaults.data(forKey: "cached_products"),
           let products = try? decoder.decode([Product].self, from: productsData) {
            // Only use cached products if they're recent (within 1 hour)
            if let cacheDate = userDefaults.object(forKey: "products_cache_date") as? Date,
               Date().timeIntervalSince(cacheDate) < 3600 {
                state.products.items = products
            }
        }
        
        return state
    }
}
