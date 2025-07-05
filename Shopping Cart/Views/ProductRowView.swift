//
//  ProductRowView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI

struct ProductRowView: View {
    let product: Product
    let canAddToCart: Bool
    let onAddToCart: (Int) -> Void
    
    @State private var quantity = 1
    @State private var showingQuantityPicker = false
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    Text(product.price, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if product.isAvailable {
                        Text("In Stock")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("Out of Stock")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            VStack(spacing: 8) {
                if canAddToCart && product.isAvailable {
                    Button(action: {
                        onAddToCart(quantity)
                    }) {
                        Image(systemName: "cart.badge.plus")
                            .font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    
                    Button("\(quantity)") {
                        showingQuantityPicker = true
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                } else if !canAddToCart {
                    Text("Login to add")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Unavailable")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 8)
        .confirmationDialog("Select Quantity", isPresented: $showingQuantityPicker) {
            ForEach(1...5, id: \.self) { qty in
                Button("\(qty)") {
                    quantity = qty
                }
            }
        }
    }
}
