//
//  CartItemRowView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI

struct CartItemRowView: View {
    let item: CartItem
    let product: Product?
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    
    @State private var showingQuantityPicker = false
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product?.imageURL ?? "")) { image in
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
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product?.name ?? "Unknown Product")
                    .font(.headline)
                    .lineLimit(2)
                
                if let product = product {
                    Text(product.price, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("Added \(item.addedAt, style: .relative) ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                // Quantity controls
                HStack(spacing: 8) {
                    Button(action: {
                        if item.quantity > 1 {
                            onQuantityChange(item.quantity - 1)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(item.quantity > 1 ? .blue : .gray)
                    }
                    .disabled(item.quantity <= 1)
                    
                    Button("\(item.quantity)") {
                        showingQuantityPicker = true
                    }
                    .font(.headline)
                    .frame(minWidth: 30)
                    
                    Button(action: {
                        if item.quantity < 99 {
                            onQuantityChange(item.quantity + 1)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(item.quantity < 99 ? .blue : .gray)
                    }
                    .disabled(item.quantity >= 99)
                }
                
                // Remove button
                Button("Remove") {
                    onRemove()
                }
                .font(.caption)
                .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete") {
                onRemove()
            }
            .tint(.red)
        }
        .confirmationDialog("Select Quantity", isPresented: $showingQuantityPicker) {
            ForEach(1...10, id: \.self) { qty in
                Button("\(qty)") {
                    onQuantityChange(qty)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
