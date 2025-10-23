//
//  Color.swift
//  FirstApp
//
//  Created by admin on 3/10/25.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

let YELLOW = UIColor(hex: "EEEE24")

let GRAY = UIColor(hex: "606060")

let ORANGE = UIColor(hex: "F2A218")

let BLACK200 = UIColor(hex: "292929")

let BLACK400 = UIColor(hex: "1C1919")

let GRAY200 = UIColor(hex: "C0C0C0")

