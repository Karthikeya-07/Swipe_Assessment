//
//  CustomTextField.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 06/02/25.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var inputModel: TextFieldInputModel
    @State var showTitle: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            TextField(inputModel.title, text: $inputModel.text)
                .keyboardType(inputModel.isNumber ? .decimalPad : .default)
                .padding(10)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke()
                        .fill(.gray.opacity(0.5))
                }
                .padding(.vertical, 10)
                .overlay(alignment: showTitle ? .topLeading : .leading) {
                    if showTitle {
                        Text(inputModel.title)
                            .foregroundStyle(.gray)
                            .background(.white)
                            .padding(.leading, 10)
                    }
                }
                .onChange(of: inputModel.text) { _, newValue in
                    withAnimation(.smooth) {
                        showTitle = !newValue.isEmpty
                    }
                }
                .onChange(of: inputModel.text) { oldValue, newValue in
                    if inputModel.isNumber {
                        if newValue == "." || newValue.isEmpty {
                            inputModel.text = newValue
                        } else {
                            inputModel.text = Double(newValue) != nil ? newValue : oldValue
                        }
                    }
                }
            if let errorMessage = inputModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
}
