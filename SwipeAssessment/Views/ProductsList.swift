//
//  ProductsList.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 03/02/25.
//

import SwiftUI
import SwiftData

struct ProductsList: View {
    @StateObject private var productsListViewModel: ProductsListViewModel = .init()
    @StateObject private var networkMonitor: NetworkMonitor = .init()
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var query: String = ""
    @State private var apiCalling: Bool = false
    @State private var viewAppeared: Bool = false
    @State private var showAddProductView: Bool = false
    @Query var favorites: [ProductModel]
    @State var message: String = .init()
    @State var showToast: Bool = false
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    init() { configureNavTitle() }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(filteredProducts) { product in
                        ProductView(product: product) { liked, productName in
                            if liked {
                                message = "\(productName) added to favorites."
                            } else {
                                message = "\(productName) removed from favorites."
                            }
                            showToast = true
                        }
                    }
                }
                .navigationTitle("Products")
                .searchable(text: $query, prompt: "Search Products")
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    showAddProductView.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 25, height: 25)
                        .padding()
                        .background(.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                })
                .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.25))
            .overlay(alignment: .center) {
                if apiCalling {
                    ProgressView("Getting products for you, Hang tight......")
                }
            }
            .onAppear {
                if !viewAppeared {
                    productsListViewModel.getProducts()
                }
            }
            .toast(message, show: $showToast)
            .onChange(of: query) { oldQuery, newQuery in
                // Filter and rearrange products based on the search query
                withAnimation(.smooth) {
                    if newQuery.isEmpty {
                        let tempFilteredProducts = products
                        filteredProducts = tempFilteredProducts.filter(\.isSelected) + tempFilteredProducts.filter(\.isNotSelected)
                    } else {
                        let tempFilteredProducts = products.filter { $0.productName.lowercased().contains(newQuery.lowercased()) }
                        filteredProducts = tempFilteredProducts.filter(\.isSelected) + tempFilteredProducts.filter(\.isNotSelected)
                    }
                }
            }
            .onReceive(productsListViewModel.$products) { products in
                bringFavoritesToFront(productModels: favorites, products: products)
            }
            .onChange(of: favorites) { oldFavorites, newFavorites in
                bringFavoritesToFront(productModels: favorites, products: products)
            }
            .onReceive(productsListViewModel.$apiCalling) { apiCalling in
                // Update API calling status for showing loading indicator
                self.apiCalling = apiCalling
            }
            .sheet(isPresented: $showAddProductView) {
                AddProductView { product in
                    withAnimation(.smooth) {
                        filteredProducts.insert(product, at: .zero)
                    }
                    // Insert new product at the top
                    products.insert(product, at: .zero)
                    bringFavoritesToFront(productModels: favorites, products: filteredProducts)
                }
                .interactiveDismissDisabled(true)
            }
            .onReceive(networkMonitor.$isConnected) { networkStatus in
                print("Network Status", networkStatus)
            }
        }
    }
    
    /// Updates the product list to ensure favorite products appear at the top.
    func bringFavoritesToFront(productModels: [ProductModel], products: [Product]) {
        var tempProducts = products
        for i in tempProducts.indices {
            tempProducts[i].isSelected = productModels.contains(product: tempProducts[i])
        }
        self.products = tempProducts
        withAnimation(.smooth) {
            self.filteredProducts = tempProducts.filter(\.isSelected) + tempProducts.filter(\.isNotSelected)
        }
    }
    
    /// Configures the navigation bar appearance with a transparent background and blue text.
    func configureNavTitle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
