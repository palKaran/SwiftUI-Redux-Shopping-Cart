//
//  UserState.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//
import Foundation

struct UserState: Equatable, Codable {
    var currentUser: User?
    var isLoading: Bool
    var error: UserError?
    var isLoggedIn: Bool
    var authToken: String?
    var lastLoginDate: Date?
    
    static let initial = UserState(
        currentUser: nil,
        isLoading: false,
        error: nil,
        isLoggedIn: false,
        authToken: nil,
        lastLoginDate: nil
    )
    
    var userName: String {
        currentUser?.name ?? "Guest"
    }
    
    var userEmail: String {
        currentUser?.email ?? ""
    }
}
