//
//  NavBarGeneric.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import SwiftUI

struct NavBarGeneric<LeadingContent: View, TrailingContent: View>: View {
    let title: String
    let leadingContent: () -> LeadingContent
    let trailingContent: () -> TrailingContent
    
    init(
        title: String,
        @ViewBuilder leadingContent: @escaping () -> LeadingContent,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent
    ) {
        self.title = title
        self.leadingContent = leadingContent
        self.trailingContent = trailingContent
    }
    
    var body: some View {
        ZStack{

            ZStack(alignment: .center) {
                HStack(alignment: .center, spacing: 0) {
                    leadingContent()
                        .offset(CGSize(width: 5.0, height: 0.0))
                        .padding(.leading,8)
                    
                    Spacer(minLength: 0)
                    
                    trailingContent()
                        .padding(.trailing,8)
                }
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(Color.primaryText)

            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .offset(CGSize(width: 0.0, height: 35.0))
            
        }//ZStack
        .background(Color.secondryBackgroundColor.opacity(0.8))
        .frame(height: 115)
        .padding(.top,-65)
    }
}


