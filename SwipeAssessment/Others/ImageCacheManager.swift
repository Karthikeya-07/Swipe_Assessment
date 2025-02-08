//
//  ImageCacheManager.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 08/02/25.
//

import SwiftUI

class ImageCacheManager {
    private init() { }
    static var shared: ImageCacheManager = .init()
    private var images: [String : Image] = [:]
    
    func set(_ image: Image, forKey key: String) {
        images[key] = image
    }
    
    func image(forKey key: String) -> Image? {
        images[key]
    }
}
