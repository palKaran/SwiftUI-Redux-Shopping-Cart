//
//  UserReducer.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//
import Foundation

func userReducer(state: UserState, action: any Action) -> UserState {
    var newState = state

    switch action {
    case let userAction as UserActions:
        switch userAction {
        case .login:
            newState.isLoading = true
            newState.error = nil

        case .loginSuccess(let user):
            newState.currentUser = user
            newState.isLoggedIn = true
            newState.isLoading = false
            newState.error = nil
            newState.lastLoginDate = Date()
            // Auth token is handled by middleware/persistence

        case .loginError(let error):
            newState.isLoading = false
            newState.error = error
            newState.isLoggedIn = false
            newState.currentUser = nil

        case .register:
            newState.isLoading = true
            newState.error = nil

        case .registerSuccess(let user):
            newState.currentUser = user
            newState.isLoggedIn = true
            newState.isLoading = false
            newState.error = nil
            newState.lastLoginDate = Date()

        case .registerError(let error):
            newState.isLoading = false
            newState.error = error

        case .logout:
            newState.isLoading = true

        case .logoutSuccess:
            newState.currentUser = nil
            newState.isLoggedIn = false
            newState.isLoading = false
            newState.error = nil
            newState.authToken = nil
            newState.lastLoginDate = nil

        case .updateProfile:
            newState.isLoading = true
            newState.error = nil

        case .profileUpdated(let user):
            newState.currentUser = user
            newState.isLoading = false
            newState.error = nil

        case .profileUpdateError(let error):
            newState.isLoading = false
            newState.error = error

        case .refreshSession:
            // Handle session refresh if needed
            break

        case .sessionExpired:
            newState.currentUser = nil
            newState.isLoggedIn = false
            newState.authToken = nil
            newState.error = .authenticationFailed
        }

    default:
        break
    }

    return newState
}
