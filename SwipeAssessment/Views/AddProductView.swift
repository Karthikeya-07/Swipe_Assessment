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
    @State var productName: String = ""
    @State var productType: String = ""
    @State var price: String = ""
    @State var tax: String = ""
    @StateObject var viewModel: ProductsListViewModel = .init()
    @State var addProductCompletion: ((Product) -> Void)
    @State var selectedImage: UIImage? = nil
    @State var showImagePicker: Bool = false
    @State var showAlert: Bool = false
    @State var message: String = ""
    @State var productNameModel: TextFieldInputModel = .init(title: "Product Name", text: "")
    @State var productTypeModel: TextFieldInputModel = .init(title: "Product Type", text: "")
    @State var priceModel: TextFieldInputModel = .init(title: "Price", text: "", isNumber: true)
    @State var taxModel: TextFieldInputModel = .init(title: "Tax", text: "", isNumber: true)
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Circle()
                    .stroke(style: .init(lineWidth: 2, dash: [2, 3]))
                    .foregroundStyle(selectedImage == nil ? .gray.opacity(0.5) : .clear)
                    .frame(width: 125, height: 125)
                    .overlay {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .clipped()
                        } else {
                            VStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundStyle(.gray.opacity(0.5))
                                    .frame(width: 25, height: 25)
                                Text("Add Image")
                                    .foregroundStyle(.gray.opacity(0.5))
                            }
                        }
                    }
                    .clipShape(Circle())
                    .onTapGesture { showImagePicker = true }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
            VStack(spacing: .zero) {
                CustomTextField(inputModel: $productNameModel)
                CustomTextField(inputModel: $productTypeModel)
                CustomTextField(inputModel: $priceModel)
                CustomTextField(inputModel: $taxModel)
            }
            .padding(.bottom, 20)
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
            Button {
                var valid: Bool = false
                withAnimation(.smooth) { valid = isValid() }
                if valid {
//                    addProduct()
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert(message, isPresented: $showAlert) {
            Button("Okay", role: .cancel) {
                dismiss()
            }
        }
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
    
    func addProduct() {
        let image = selectedImage
        viewModel.addProduct(
            images: image != nil ? [image!] : [],
            params: [
            "product_name" : productName,
            "product_type" : productType,
            "price" : price.toDouble() ?? .zero,
            "tax" : tax.toDouble() ?? .zero
        ])
    }
    
    func isValid() -> Bool {
        let valid: Bool = productNameModel.validate() &&
        productTypeModel.validate() &&
        priceModel.validate() &&
        taxModel.validate()
        return valid
    }
}
