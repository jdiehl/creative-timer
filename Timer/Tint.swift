//
//  Tint.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 15.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

struct Tint {
  
  static let allThemes: [Tint.Theme] = [.crimson, .earth, .glow, .leaf, .ocean, .pop, .royal, .sky]
  static let allStyles: [Tint.Style] = [.automatic, .light, .dark, .colored]

  enum Theme: String {
    case crimson = "Crimson"
    case earth = "Earth"
    case glow = "Glow"
    case leaf = "Leaf"
    case ocean = "Ocean"
    case pop = "Pop"
    case royal = "Royal"
    case sky = "Sky"
  }

  enum Style: String {
    case automatic = "Automatic"
    case light = "Light"
    case dark = "Dark"
    case colored = "Colored"
  }
  
  var theme: Theme
  var style: Style
    
  var foregroundColor: UIColor { return makeForegroundColor() }
  var backgroundColor: UIColor { return makeBackgroundColor() }
  var greyColor: UIColor { return makeGreyColor() }
  
  init(theme: Theme, style: Style) {
    self.theme = theme
    self.style = style
  }
  
  init?(withString: String) {
    let components = withString.split(separator: ":")
    guard components.count == 2 else { return nil }
    guard let theme = Theme(rawValue: String(components[0])) else { return nil }
    guard let style = Style(rawValue: String(components[1])) else { return nil }
    self.init(theme: theme, style: style)
  }

  func toString() -> String {
    return "\(theme.rawValue):\(style.rawValue)"
  }

  // MARK: - Private Methods
  
  private func tintColor(userInterfaceStyle: UIUserInterfaceStyle? = nil) -> UIColor {
    let col = UIColor(named: theme.rawValue)!
    guard let userInterfaceStyle = userInterfaceStyle else { return col }
    return col.resolvedColor(with: UITraitCollection(userInterfaceStyle: userInterfaceStyle))
  }
  
  private func makeForegroundColor() -> UIColor {
    switch style {
    case .dark: return tintColor(userInterfaceStyle: .dark)
    case .light: return tintColor(userInterfaceStyle: .light)
    case .colored: return UIColor.white
    default: return tintColor()
    }
  }
  
  private func makeBackgroundColor() -> UIColor {
    switch style {
    case .light: return UIColor.white
    case .dark: return UIColor.black
    case .colored: return tintColor(userInterfaceStyle: .light)
    default: return UIColor.systemBackground
    }
  }

  private func makeGreyColor() -> UIColor {
    switch style {
    case .light: return UIColor.black.withAlphaComponent(0.3)
    case .dark: return UIColor.white.withAlphaComponent(0.3)
    case .colored: return UIColor.white.withAlphaComponent(0.3)
    default: return UIColor.label.withAlphaComponent(0.3)
    }
  }

}
