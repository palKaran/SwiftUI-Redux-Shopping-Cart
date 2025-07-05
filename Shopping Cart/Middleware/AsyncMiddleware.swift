//
//  AsyncMiddleware.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

struct AsyncMiddleware<State>: Middleware {
    private let apiService: APIServiceProtocol
    private let persistenceService: PersistenceService

    init(apiService: APIServiceProtocol = APIService(), persistenceService: PersistenceService = PersistenceService()) {
        self.apiService = apiService
        self.persistenceService = persistenceService
    }
    
    func process(
        action: any Action,
        state: State,
        dispatch: @escaping (any Action) -> Void
    ) -> any Action {
        
        // Handle Product Actions
        if let productAction = action as? ProductActions {
            handleProductActions(productAction, dispatch: dispatch)
        }
        
        // Handle User Actions
        if let userAction = action as? UserActions {
            handleUserActions(userAction, dispatch: dispatch)
        }
        
        // Handle Cart Actions
        if let cartAction = action as? CartActions {
            handleCartActions(cartAction, state: state, dispatch: dispatch)
        }
        
        return action
    }
    
    private func handleProductActions(_ action: ProductActions, dispatch: @escaping (any Action) -> Void) {
        switch action {
        case .loadProducts:
            Task {
                do {
                    let products = try await apiService.fetchProducts()
                    await MainActor.run {
                        dispatch(ProductActions.productsLoaded(products))
                    }
                } catch {
                    await MainActor.run {
                        dispatch(ProductActions.productsError(.networkError(error)))
                    }
                }
            }
            
        case .loadProductsByCategory(let category):
            Task {
                do {
                    let products = try await apiService.fetchProducts(category: category)
                    await MainActor.run {
                        dispatch(ProductActions.productsLoaded(products))
                    }
                } catch {
                    await MainActor.run {
                        dispatch(ProductActions.productsError(.networkError(error)))
                    }
                }
            }
            
        case .searchProducts(let query):
            Task {
                do {
                    let products = try await apiService.searchProducts(query: query)
                    await MainActor.run {
                        dispatch(ProductActions.searchResultsLoaded(products))
                    }
                } catch {
                    await MainActor.run {
                        dispatch(ProductActions.productsError(.networkError(error)))
                    }
                }
            }
            
        default:
            break
        }
    }
    
    private func handleUserActions(_ action: UserActions, dispatch: @escaping (any Action) -> Void) {
        switch action {
        case .login(let email, let password):
            Task {
                do {
                    let user = try await apiService.login(email: email, password: password)
                    await MainActor.run {
                        dispatch(UserActions.loginSuccess(user))
                        // Auto-load cart after successful login
                        dispatch(CartActions.loadCart)
                    }
                } catch {
                    await MainActor.run {
                        let userError = mapToUserError(error)
                        dispatch(UserActions.loginError(userError))
                    }
                }
            }
            
        case .register(let email, let password, let name):
            Task {
                do {
                    let user = try await apiService.register(email: email, password: password, name: name)
                    await MainActor.run {
                        dispatch(UserActions.registerSuccess(user))
                    }
                } catch {
                    await MainActor.run {
                        let userError = mapToUserError(error)
                        dispatch(UserActions.registerError(userError))
                    }
                }
            }
            
        case .logout:
            Task {
                do {
                    try await apiService.logout()
                    await MainActor.run {
                        dispatch(UserActions.logoutSuccess)
                    }
                } catch {
                    // Even if logout fails on server, clear local state
                    await MainActor.run {
                        dispatch(UserActions.logoutSuccess)
                    }
                }
            }
            
        default:
            break
        }
    }
    
    private func handleCartActions(_ action: CartActions, state: State, dispatch: @escaping (any Action) -> Void) {
        switch action {
        case .loadCart:
            Task {
                do {
                    if (state as! AppState).cart.items.isEmpty {
                        let cartItems = try await apiService.fetchCart()
                        await MainActor.run {
                            dispatch(CartActions.cartLoaded(cartItems))
                        }
                    } else {
                        await MainActor.run {
                            dispatch(CartActions.cartLoaded((state as! AppState).cart.items))
                        }
                    }
                } catch {
                    await MainActor.run {
                        dispatch(CartActions.cartError(.networkError(error.localizedDescription)))
                    }
                }
            }
            
        case .addItem(let productId, let quantity):
            // Persist to backend
            Task {
                do {
                    try await apiService.addToCart(productId: productId, quantity: quantity)
                } catch {
                    await MainActor.run {
                        dispatch(CartActions.cartError(.networkError(error.localizedDescription)))
                    }
                }
            }
            
        case .removeItem(let productId):
            Task {
                do {
                    try await apiService.removeFromCart(productId: productId)
                } catch {
                    await MainActor.run {
                        dispatch(CartActions.cartError(.networkError(error.localizedDescription)))
                    }
                }
            }
            
        case .initiateCheckout:
            Task {
                do {
                    dispatch(CartActions.checkoutStarted)
                    let orderId = try await apiService.checkout()
                    await MainActor.run {
                        dispatch(CartActions.checkoutSuccess(orderId: orderId))
                        dispatch(CartActions.clearCart) // Clear cart after successful checkout
                    }
                } catch {
                    await MainActor.run {
                        dispatch(CartActions.checkoutFailed(.checkoutFailed(error.localizedDescription)))
                    }
                }
            }
            
        default:
            break
        }
    }
    
    private func mapToUserError(_ error: Error) -> UserError {
        // Map different API errors to appropriate UserError cases
        if error.localizedDescription.contains("credentials") {
            return .invalidCredentials
        } else if error.localizedDescription.contains("locked") {
            return .accountLocked
        } else if error.localizedDescription.contains("verification") {
            return .emailNotVerified
        } else {
            return .networkError(error.localizedDescription)
        }
    }
}
