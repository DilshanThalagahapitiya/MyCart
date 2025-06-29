//
//  CategoryButton.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import SwiftUI

struct CategoryButton: View {
    @State var categoryName : String
    @State var categoryId: String
    @Binding var selectedCategoryId: String
    let action: (() -> ())?
    
    var body: some View {
        ZStack{
            Button {
                action?()
                
            } label: {
                Text(categoryName)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(categoryId == selectedCategoryId ? Color.backgroundPrimary : Color.primaryText)
                    .background(
                        RoundedRectangle(cornerRadius: 27)
                            .strokeBorder(Color.borderColor, lineWidth: 1)
                            .background(categoryId == selectedCategoryId ? Color.primaryButton : Color.backgroundSecondary.opacity(0.2))
                    )
                    .cornerRadius(27)
            }
        }//:ZStack
    }
}
