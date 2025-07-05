//
//  ToastView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI

struct ToastView: View {
    let message: ToastMessage
    
    var body: some View {
        Text(message.message)
            .font(.callout)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    private var backgroundColor: Color {
        switch message.type {
        case .success:
            return .green
        case .error:
            return .red
        case .info:
            return .blue
        }
    }
}
