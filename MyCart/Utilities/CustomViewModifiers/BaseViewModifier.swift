//
//  BaseViewModifier.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//

import SwiftUI

extension View {
    func baseViewStyles() -> some View {
        modifier(BaseViewStyles())
    }
    func baseViewStyles(backgroundColor: Color) -> some View {
        modifier(BaseViewStyles(backgroundColor: .primaryBackgroundColor))
    }
}

private struct BaseViewStyles: ViewModifier {
    var backgroundColor: Color = Color.secondryBackgroundColor.opacity(0.5)
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.secondaryTextColor)
            .background(backgroundColor.ignoresSafeArea(.all))
            .navigationBarHidden(true)
            .onTapGesture {
                withAnimation {
                    UIApplication.shared.endEditing()
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                UIApplication.shared.endEditing()
                            }
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
            }
    }
}
