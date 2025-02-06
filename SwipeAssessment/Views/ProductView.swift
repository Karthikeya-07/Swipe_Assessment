//
//  ProductView.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 03/02/25.
//

import SwiftUI
import SwiftData

struct ProductView: View {
    @Environment(\.modelContext) var context
    @Query var favorites: [ProductModel]
    var product: Product
    var body: some View {
        VStack(spacing: 7) {
            AsyncImage(url: URL(string: product.image)) { phase in
                if let image = phase.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 80)
                        .clipped()
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 80)
                        .clipped()
                }
            }
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 7) {
                    Text(product.productName.isEmpty ? "---" : product.productName)
                        .lineLimit(.max)
                        .font(.system(size: 16, weight: .medium))
                    Spacer(minLength: .zero)
                    Image(systemName: product.isSelected ? "heart.fill" : "heart")
                        .foregroundStyle(product.isSelected ? .red : .black)
                        .onTapGesture {
                            if let firstFavoriteProduct = favorites.first(where: { $0.productName == product.productName }) {
                                context.delete(firstFavoriteProduct)
                            } else {
                                let productModel = ProductModel(product: product)
                                context.insert(productModel)
                            }
                        }
                }
                Text(product.productType.isEmpty ? "N/A" : product.productType)
                    .font(.system(size: 13, weight: .regular))
                Text(product.price, format: .currency(code: "INR"))
                    .font(.system(size: 14, weight: .medium))
                Text("Tax: \(product.tax.description)%")
                    .font(.system(size: 14, weight: .medium))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            Spacer()
        }
        .padding(.bottom, 15)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
