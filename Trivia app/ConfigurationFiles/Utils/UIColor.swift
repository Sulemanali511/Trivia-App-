//
//  UIColor.swift
//  Trivia app
//
//  Created by Suleman Ali on 21/12/2020.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }

    
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
     convenience init?(hexStr: String) {
           let r, g, b, a: CGFloat

           if hexStr.hasPrefix("#") {
               let start = hexStr.index(hexStr.startIndex, offsetBy: 1)
               let hexColor = String(hexStr[start...])

               if hexColor.count == 8 {
                   let scanner = Scanner(string: hexColor)
                   var hexNumber: UInt64 = 0

                   if scanner.scanHexInt64(&hexNumber) {
                       r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                       g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                       b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                       a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                       self.init(red: r, green: g, blue: b, alpha: a)
                       return
                   }
               }
           }

           return nil
       }

    
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    
}


class GrandientColors {
    var layers:CAGradientLayer!
    
    init(topColor: UIColor, bottomColor: UIColor) {
        let colorTop = topColor.cgColor //UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = bottomColor.cgColor //UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.layers = CAGradientLayer()
        self.layers.colors = [colorTop, colorBottom]
        self.layers.locations = [0.0, 1.0]
    }
    
    init() {
        let colorTop = UIColor(red: 251 / 255.0, green: 251.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 243.0 / 255.0, green: 243.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0).cgColor
        
        self.layers = CAGradientLayer()
        self.layers.colors = [colorTop, colorBottom]
        self.layers.locations = [0.0, 1.0]
    }
}
extension UIColor {
    enum HexFormat {
        case RGB
        case ARGB
        case RGBA
        case RRGGBB
        case AARRGGBB
        case RRGGBBAA
    }

    enum HexDigits {
        case d3, d4, d6, d8
    }

    func hexString(_ format: HexFormat = .RRGGBBAA) -> String {
        let maxi = [.RGB, .ARGB, .RGBA].contains(format) ? 16 : 256

        func toI(_ f: CGFloat) -> Int {
            return min(maxi - 1, Int(CGFloat(maxi) * f))
        }

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        let ri = toI(r)
        let gi = toI(g)
        let bi = toI(b)
        let ai = toI(a)

        switch format {
        case .RGB:       return String(format: "#%X%X%X", ri, gi, bi)
        case .ARGB:      return String(format: "#%X%X%X%X", ai, ri, gi, bi)
        case .RGBA:      return String(format: "#%X%X%X%X", ri, gi, bi, ai)
        case .RRGGBB:    return String(format: "#%02X%02X%02X", ri, gi, bi)
        case .AARRGGBB:  return String(format: "#%02X%02X%02X%02X", ai, ri, gi, bi)
        case .RRGGBBAA:  return String(format: "#%02X%02X%02X%02X", ri, gi, bi, ai)
        }
    }

    func hexString(_ digits: HexDigits) -> String {
        switch digits {
        case .d3: return hexString(.RGB)
        case .d4: return hexString(.RGBA)
        case .d6: return hexString(.RRGGBB)
        case .d8: return hexString(.RRGGBBAA)
        }
    }
}
