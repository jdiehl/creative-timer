//
//  Color.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import UIKit

// MARK: - color for interface style
extension UIColor {
  
  var light: UIColor {
    return self.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
  }
  
  var dark: UIColor {
    return self.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
  }
  
}

// MARK: - Overlay two colors
extension UIColor {
  func overlay(color: UIColor) -> UIColor {
    var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    
    self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    
    let red = r1 * (1 - a2) + r2 * a2
    let green = g1 * (1 - a2) + g2 * a2
    let blue = b1 * (1 - a2) + b2 * a2
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }
}

// MARK: - Appearance
extension UIColor {
  
  convenience init(_ theme: Appearance.Theme) {
    self.init(named: theme.rawValue)!
  }
  
  class func foreground(appearance: Appearance) -> UIColor {
    switch appearance.style {
    case .dark: return UIColor(appearance.theme).dark
    case .light: return UIColor(appearance.theme).light
    case .colored: return UIColor.white
    default: return UIColor(appearance.theme)
    }
  }
  
  class func background(appearance: Appearance) -> UIColor {
    switch appearance.style {
    case .light: return UIColor.white
    case .dark: return UIColor.black
    case .colored: return UIColor(appearance.theme).light
    default: return UIColor.systemBackground
    }
  }
  
  class func gray(appearance: Appearance) -> UIColor {
    switch appearance.style {
    case .light: return UIColor.systemGray2.light
    case .dark: return UIColor.systemGray2.dark
    case .colored: return UIColor(appearance.theme).overlay(color: UIColor(white: 1, alpha: 0.3))
    default: return UIColor.systemGray2
    }
  }
  
}
