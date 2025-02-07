//
//  AddProductView.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 04/02/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ProductsListViewModel = .init()
    @State var addProductCompletion: ((Product) -> Void)
    @State var selectedImage: UIImage? = nil
    @State var showImagePicker: Bool = false
    @State var showAlert: Bool = false
    @State var message: String = ""
    @State var productNameModel: TextFieldInputModel = .init(title: "Product Name", text: "")
    @State var productType: String = ""
    @State var productTypeErrorMessage: String? = nil
    @State var priceModel: TextFieldInputModel = .init(title: "Price", text: "", isNumber: true)
    @State var taxModel: TextFieldInputModel = .init(title: "Tax", text: "", isNumber: true)
    var themeColor: Color = .gray.opacity(0.5)
    var productTypes: [String] = ["Electronics", "Clothing", "Sports"]
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                /// Circular image picker to select a product image.
                Circle()
                    .stroke(lineWidth: 2.5)
                    .foregroundStyle(selectedImage == nil ? themeColor : .clear)
                    .frame(width: 125, height: 125)
                    .overlay {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .clipped()
                        } else {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(themeColor)
                                    .frame(width: 40, height: 40)
                        }
                    }
                    .clipShape(Circle())
                    .onTapGesture { showImagePicker = true }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: .zero) {
                CustomTextField(inputModel: $productNameModel)
                /// Dropdown menu for selecting product type.
                Menu {
                    ForEach(productTypes.indices, id: \.self) { i in
                        Button(productTypes[i]) {
                            productType = productTypes[i]
                        }
                    }
                } label: {
                    dropdownLabel
                }
                if let productTypeErrorMessage, !productTypeErrorMessage.isEmpty {
                    Text(productTypeErrorMessage)
                        .foregroundStyle(.red)
                }
                CustomTextField(inputModel: $priceModel)
                CustomTextField(inputModel: $taxModel)
            }
            .padding(.bottom, 20)
            /// Button to cancel the product addition.
            Button {
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 6)
                    .stroke()
                    .fill(.blue)
                    .frame(height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay {
                        Text("Cancel")
                            .foregroundStyle(.blue)
                            .font(.system(size: 17, weight: .medium))
                    }
            }
            .disabled(viewModel.apiCalling)
            /// Button to add the product after validation.
            Button {
                var valid: Bool = false
                withAnimation(.smooth) { valid = isValid() }
                if valid {
                    addProduct()
                }
            } label: {
                Rectangle()
                    .fill(.blue)
                    .frame(height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay {
                        if viewModel.apiCalling {
                            ProgressView().tint(.white)
                        } else {
                            Text("Add Product")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .medium))
                        }
                    }
            }
            .disabled(viewModel.apiCalling)
        }
        /// Sheet for image selection.
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        /// Alert for displaying success/error message.
        .alert(message, isPresented: $showAlert) {
            Button("Okay", role: .cancel) {
                dismiss()
            }
        }
        /// Observing product addition response.
        .onReceive(viewModel.$addProductResponse) { addProductResponse in
            if let addProductResponse {
                message = addProductResponse.message
                if addProductResponse.success {
                    let product = addProductResponse.productDetails
                    addProductCompletion(product)
                }
                showAlert = true
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
    @ViewBuilder
    var dropdownLabel: some View {
        HStack {
            Text(!productType.isEmpty ? productType : "Choose product type")
            Spacer()
            Image(systemName: "chevron.down")
        }
        .foregroundStyle(!productType.isEmpty ? .black : themeColor)
        .contentShape(Rectangle())
        .padding(10)
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke()
                .fill(themeColor)
        }
        .padding(.vertical, 10)
    }
    
    /// Calls the view model to add the product.
    func addProduct() {
        let image = selectedImage
        viewModel.addProduct(
            images: image != nil ? [image!] : [],
            params: [
            "product_name" : productNameModel.text,
            "product_type" : productType,
            "price" : priceModel.text.toDouble() ?? .zero,
            "tax" : taxModel.text.toDouble() ?? .zero
        ])
    }
    
    /// Validates the form inputs before submission.
    func isValid() -> Bool {
        if !productType.isEmpty { productTypeErrorMessage = "" }
        if !productNameModel.validate() {
            return false
        } else if productType.isEmpty {
            productTypeErrorMessage = "Product type is required"
            return false
        } else if !priceModel.validate() {
            return false
        } else if !taxModel.validate() {
            return false
        }
        return true
    }
}
