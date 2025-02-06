//
//  ProductsListViewModel.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 03/02/25.
//

import UIKit

class ProductsListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var addProductResponse: AddProductResponse?
    @Published var apiCalling: Bool = false
    func getProducts() {
        apiCalling = true
        NetworkHelper.shared.dataRequest(withUrl: AppConstants.productsListApiUrl) { [weak self] (products: Products?, error: String?) in
            guard let self else { return }
            apiCalling = false
            if let products {
                self.products = products
            } else {
                self.products = []
            }
        }
    }
    
    func addProduct(images: [UIImage], params: [String : AnyHashable]) {
        apiCalling = true
        NetworkHelper.shared.uploadFormData(to: AppConstants.addProductApiUrl, params: params, images: images, imageParamName: "files") { [weak self] (response: AddProductResponse?, error: String?) in
            guard let self else { return }
            apiCalling = false
            addProductResponse = response
            print(response ?? "")
        }
    }
}
