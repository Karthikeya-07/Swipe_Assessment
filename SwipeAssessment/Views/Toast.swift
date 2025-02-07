//
//  Toast.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 07/02/25.
//

import SwiftUI

struct Toast: View {
    var message: String
    @Binding var show: Bool
    var timeInterval: Double
    
    var body: some View {
        HStack {
            Text(message)
            Spacer()
            Image(systemName: "xmark")
                .onTapGesture(perform: dismissToastWithAnimation)
        }
        .contentShape(Rectangle())
        .multilineTextAlignment(.leading)
        .foregroundStyle(.white)
        .font(.system(size: 17, weight: .medium))
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.green)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(15)
        .opacity(show ? 1 : 0)
        .alignmentGuide(.bottom) { _ in show ? 100 : 0 }
        .animation(.smooth, value: show)
        .onChange(of: show) { oldValue, newValue in
            // Auto-dismiss the toast after the specified time interval
            let delay: DispatchTime = .now() + timeInterval
            DispatchQueue.main.asyncAfter(deadline: delay) {
                if newValue { show = false }
            }
        }
    }
    
    /// Dismisses the toast with a smooth animation
    private func dismissToastWithAnimation() {
        withAnimation(.smooth) { show = false }
    }
}

extension View {
    /// Displays a toast message overlaying on the current view.
    /// - Parameters:
    ///   - message: The message to be displayed in the toast.
    ///   - show: A binding that controls the visibility of the toast.
    ///   - timeInterval: The duration (in seconds) before the toast disappears automatically (default: 3 seconds).
    /// - Returns: A modified view with the toast overlay.
    func toast(_ message: String, show: Binding<Bool>, timeInterval: Double = 3) -> some View {
        self.overlay(alignment: .bottom) {
            Toast(message: message, show: show, timeInterval: timeInterval)
        }
    }
}

