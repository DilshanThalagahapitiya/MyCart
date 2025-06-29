//
//  ViewRatingView.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import SwiftUI

struct ViewRatingView: View {
    
    //MARK: - PROPERTIES
    var rating: Double
    
    init(_ rating: Double, starFontSize: CGFloat = 20, spacing: CGFloat = 15, maxRating: Int = 5) {
        self.rating = rating
        self.starFontSize = starFontSize
        self.spacing = spacing
        self.maxRating = maxRating
    }
    
    let starFontSize: CGFloat
    let spacing: CGFloat
    let maxRating: Int
    
    //MARK: - BODY
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<min(Int(rating), maxRating), id: \.self) { idx in
                fullStar
            }
            
            if (rating != floor(rating)) && Int(floor(rating)) < maxRating {
                halfStar
            }
            
            let emptyStars = max(0, maxRating - Int(ceil(rating)))
            ForEach(0..<emptyStars, id: \.self) { idx in
                emptyStar
            }
        }
    }//Body
    
    private var fullStar: some View {
        Image(systemName: "star.fill")
            .font(.system(size: starFontSize))
            .foregroundColor(Color.primaryButton)
    }
    
    private var halfStar: some View {
        Image(systemName: "star.leadinghalf.fill")
            .font(.system(size: starFontSize))
            .foregroundColor(Color.primaryButton)
    }
    
    private var emptyStar: some View {
        Image(systemName: "star.fill")
            .font(.system(size: starFontSize))
            .foregroundStyle(Color.tertiaryTextColor)
    }

}

#Preview {
    ViewRatingView(5.0)
}
