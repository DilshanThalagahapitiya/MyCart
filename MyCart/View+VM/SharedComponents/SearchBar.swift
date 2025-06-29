//
//  SearchBar.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import Foundation
import SwiftUI

struct SearchBar:View {
    @Binding var searchText:String
    var placeholder:String = "Start typing here"
    var clearAction: (() -> ())
    
    var body: some View{
        HStack{
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text(placeholder)
                        .font(.system(size: 14, weight: .regular, design: .default))
                }
                .autocorrectionDisabled(true)
            
            Spacer()
            Image(systemName:searchText.isEmpty ? "magnifyingglass" :"xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 18)
                
                .onTapGesture {
                    if !searchText.isEmpty{
                        searchText = ""
                        clearAction()
                    }
                }
        } //: HStack
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .foregroundStyle(.primary)
        .frame(height: 48)
        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .strokeBorder(Color.primaryBackgroundColor.opacity(0.29), lineWidth: 1)
//                .background(Color.primaryBackgroundColor.opacity(0.22))
        )
        .cornerRadius(12)
        
    }
}
