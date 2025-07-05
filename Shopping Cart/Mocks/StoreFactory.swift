//
//  StoreFactory.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

final class StoreFactory {
    @MainActor static func createProductionStore() -> Store<AppState> {
        let apiService = APIService() // Real API service
        let persistenceService = PersistenceService()
        
        return createStore(apiService: apiService, persistenceService: persistenceService)
    }
    
    @MainActor static func createMockStore(shouldSimulateErrors: Bool = false) -> Store<AppState> {
        let apiService = MockAPIService(delay: 0.5, shouldSimulateErrors: shouldSimulateErrors)
        let persistenceService = PersistenceService()
        
        return createStore(apiService: apiService, persistenceService: persistenceService)
    }
    
    @MainActor private static func createStore(
        apiService: APIServiceProtocol,
        persistenceService: PersistenceService
    ) -> Store<AppState> {
        let middleware: [any Middleware<AppState>] = [
            AsyncMiddleware(apiService: apiService, persistenceService: persistenceService),
            PersistenceMiddleware(),
            AnalyticsMiddleware()
        ]
        
        // Load persisted state if available
        let initialState = loadPersistedState() ?? AppState.initial
        
        return Store(
            initialState: initialState,
            reducer: appReducer,
            middleware: middleware
        )
    }
    
    private static func loadPersistedState() -> AppState? {
        return PersistenceMiddleware<AppState>.loadPersistedState()
    }
    
    private static var isProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
}
