//
//  ProductModel + Extension.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 06/02/25.
//

import Foundation

extension [ProductModel] {
    func contains(product: Product) -> Bool {
        for productModel in self {
            if product.image == productModel.image &&
            product.productName == productModel.productName &&
            product.productType == productModel.productType &&
            product.tax == productModel.tax &&
                product.price == productModel.price {
                return  true
            }
        }
        return false
    }
}
