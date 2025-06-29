//
//  NavBarBackButton.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import SwiftUI

struct NavBarBackButton: View {
    @EnvironmentObject var router: Router
    private let variant: Variant
    
    init(_ variant: Variant = .primary) {
        self.variant = variant
    }
    
    var body: some View {
        Button {
            router.navigateBack()
            
        } label: {
            Image( "icon.back")
                .foregroundStyle(Color.primaryTextColor)
                .scaledToFit()
                .frame(width: iconSize)
            
        }
        .frame(width: 44,height: 44)
    }
    
    enum Variant {
        case basic, primary
    }
    
    private var iconColor: Color {
        switch variant {
        case .basic: return Color.primaryElement
        case .primary: return Color.primaryTextColor
        }
    }
    
    private var iconSize: CGFloat {
        switch variant {
        case .basic: return CGFloat(28)
        case .primary: return CGFloat(36)
        }
    }
}

#Preview {
    NavBarBackButton()
        .background(Color.primaryBackgroundColor)
}
