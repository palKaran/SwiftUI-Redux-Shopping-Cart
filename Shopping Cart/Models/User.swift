//
//  User.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import Foundation

struct User: Codable, Equatable {
    let id: String
    let email: String
    let name: String
    let isEmailVerified: Bool
    let createdAt: Date
}
