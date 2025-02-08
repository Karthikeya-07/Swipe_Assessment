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
    @Binding var product: Product
    var completion: ((Bool, String) -> Void) = { _, _ in }
    @State var viewId: UUID = .init()
    var body: some View {
        VStack(spacing: 7) {
            AsyncImage(url: URL(string: product.image)) { phase in
                if let image = ImageCacheManager.shared.image(forKey: product.image) {
                    return image.prodctImageConfig()
                } else {
                    if let image = phase.image {
                        ImageCacheManager.shared.set(image, forKey: product.image)
                        return image.prodctImageConfig()
                    } else {
                        return Image("placeholder").prodctImageConfig()
                    }
                }
            }
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 7) {
                    Text(product.productName.isEmpty ? "---" : product.productName)
                        .lineLimit(.max)
                        .font(.system(size: 16, weight: .medium))
                    Spacer(minLength: .zero)
                    Image(systemName: product.isSelected ? "heart.fill" : "heart")
                        .foregroundStyle(product.isSelected ? .red : .primary)
                        .onTapGesture {
                            if let firstFavoriteProduct = favorites.first(where: { $0.productName == product.productName }) {
                                // Remove from favorites
                                context.delete(firstFavoriteProduct)
                                completion(false, firstFavoriteProduct.productName)
                            } else {
                                // Add to favorites
                                let productModel = ProductModel(product: product)
                                context.insert(productModel)
                                completion(true, productModel.productName)
                            }
                            do {
                                try context.save()
                            } catch let error {
                                print(error.localizedDescription)
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
        .background(.whiteAndBlack) // Adaptive background for light/dark mode
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
