//
//  SwipeAssessmentApp.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 03/02/25.
//

import SwiftUI
import SwiftData

@main
struct SwipeAssessmentApp: App {
    var body: some Scene {
        WindowGroup {
            ProductsList()
                .modelContainer(for: ProductModel.self)
        }
    }
}
