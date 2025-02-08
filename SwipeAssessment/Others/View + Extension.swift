//
//  View + Extension.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 08/02/25.
//

import SwiftUI

extension View {
    public func prodctImageConfig() -> some View {
        guard let self = self as? Image else { return AnyView(self) }
        return AnyView(
            self
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 80)
                .clipped()
        )
    }
}

