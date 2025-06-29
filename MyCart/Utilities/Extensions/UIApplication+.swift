//
//  UIApplication+.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//
import UIKit
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
