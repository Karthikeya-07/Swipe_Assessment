//
//  ProductsListModels.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 03/02/25.
//

import SwiftUI
import SwiftData

struct Product: Decodable, Identifiable {
    var id: UUID = .init()
    var image: String
    var price: Double
    var productName, productType: String
    var tax: Double
    var isSelected: Bool = false
    var isNotSelected: Bool { !isSelected }

    enum CodingKeys: String, CodingKey {
        case image, price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}
typealias Products = [Product]

struct AddProductResponse: Decodable {
    var message: String
    var productDetails: Product
    var productID: Int
    var success: Bool

    enum CodingKeys: String, CodingKey {
        case message
        case productDetails = "product_details"
        case productID = "product_id"
        case success
    }
}

@Model
class ProductModel {
    var image: String
    var price: Double
    var productName: String
    var productType: String
    var tax: Double
    init(image: String, price: Double, productName: String, productType: String, tax: Double) {
        self.image = image
        self.price = price
        self.productName = productName
        self.productType = productType
        self.tax = tax
    }
    
    init(product: Product) {
        self.image = product.image
        self.price = product.price
        self.productName = product.productName
        self.productType = product.productType
        self.tax = product.tax
    }
}

struct TextFieldInputModel {
    var title: String
    var text: String
    var isNumber: Bool = false
    var errorMessage: String? = nil
    
    mutating func validate() -> Bool {
        if text.isEmpty {
            errorMessage = "Please enter \(title.lowercased())."
            return false
        } else {
            errorMessage = nil
            return true
        }
    }
}
