//
//  UserActions.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


enum UserActions: UserAction {
    // Authentication
    case login(email: String, password: String)
    case loginSuccess(User)
    case loginError(UserError)
    case logout
    case logoutSuccess
    
    // Registration
    case register(email: String, password: String, name: String)
    case registerSuccess(User)
    case registerError(UserError)
    
    // Profile management
    case updateProfile(name: String)
    case profileUpdated(User)
    case profileUpdateError(UserError)
    
    // Session management
    case refreshSession
    case sessionExpired
    
    var type: String {
        switch self {
        case .login: return "USER_LOGIN"
        case .loginSuccess: return "USER_LOGIN_SUCCESS"
        case .loginError: return "USER_LOGIN_ERROR"
        case .logout: return "USER_LOGOUT"
        case .logoutSuccess: return "USER_LOGOUT_SUCCESS"
        case .register: return "USER_REGISTER"
        case .registerSuccess: return "USER_REGISTER_SUCCESS"
        case .registerError: return "USER_REGISTER_ERROR"
        case .updateProfile: return "USER_UPDATE_PROFILE"
        case .profileUpdated: return "USER_PROFILE_UPDATED"
        case .profileUpdateError: return "USER_PROFILE_UPDATE_ERROR"
        case .refreshSession: return "USER_REFRESH_SESSION"
        case .sessionExpired: return "USER_SESSION_EXPIRED"
        }
    }
}
