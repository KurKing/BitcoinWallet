//
//  Font.swift
//  BitcoinWallet
//
//  Created by Oleksii on 21.08.2025.
//

import UIKit

extension UIFont {
    
    struct SF {
        
        static func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
            
            let post = UIFont.descriptor(for: weight)
            let fontName = "SFProText-\(post)"
            
            return .init(name: fontName, size: size)!
        }
    }
    
    private static func descriptor(for weight: UIFont.Weight) -> String {
        
        switch weight {
        case .medium:       return "Medium"
        case .semibold:     return "Semibold"
        case .bold:         return "Bold"
        default:            return "Regular"
        }
    }
}
