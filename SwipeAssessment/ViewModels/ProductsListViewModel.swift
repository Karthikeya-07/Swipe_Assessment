//
//  ProductsListViewModel.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 03/02/25.
//

import UIKit

class ProductsListViewModel: ObservableObject {
    /// The list of products fetched from the server.
    @Published var products: [Product] = []
    
    /// The response received after adding a product.
    @Published var addProductResponse: AddProductResponse?
    
    /// A flag indicating whether an API call is in progress.
    @Published var apiCalling: Bool = false
    
    /// Fetches the list of products from the API.
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
    
    /// Adds a new product by uploading images and form data.
    ///
    /// - Parameters:
    ///   - images: An array of `UIImage` representing the product images.
    ///   - params: A dictionary containing product details.
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
