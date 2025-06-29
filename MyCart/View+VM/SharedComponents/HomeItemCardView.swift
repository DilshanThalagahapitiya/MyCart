//
//  HomeItemCardView.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct HomeItemCardView:View {
    @State var itemCard : ProductModel?
    @State var isFav:Bool = false
    let viewAction: (() -> ())?
    var addToFavAction: (() -> ())?
    var removeFromFavAction: (() -> ())?

    var body: some View{
        VStack(alignment: .leading){
            HStack(){
                Text("LKR \(formatNumber(number: Double(itemCard?.price ?? 0)))")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .bold()
                    .foregroundColor(.primaryText)
                    .padding(.leading, 8.5)
                    .padding(.top, 12)
                    .padding(.bottom, 7)
                

            } // : HStack
            
            if (itemCard?.image) != "" {
                HStack {
                    Spacer()
                    WebImage(url: URL(string: itemCard?.image ?? ""))
                        .resizable()
//                        .scaledToFill()
                        .cornerRadius(8)
                        .frame(width:100,height: 80)
//                        .padding(.bottom, 7)
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                    Image("default_Placeholder")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 80)
                        .opacity(0.5)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            
            Text(itemCard?.category?.category ?? "")
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .padding(.top, 5)

            Text(itemCard?.title ?? "")
                .font(.system(size: 14, weight: .medium, design: .default))
                .padding(.leading, 8)
                .padding(.trailing, 11)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.top, 1)
                .padding(.bottom, 4)
                .frame(height: 50)
        } // : VStack
        .background(Color.primaryBackgroundColor)
        .cornerRadius(14)
        .frame(height: 250)
        .onTapGesture {
            viewAction?()
        }
        
    }
}

#Preview {
    HomeView(hideTabBar: .constant(false))
}
