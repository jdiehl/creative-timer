//
//  Tint.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

struct Appearance : Codable {
  var theme: Theme = .crimson
  var style: Style = .automatic
}

// MARK: - Types
extension Appearance {
  
  enum Theme: String, Codable {
    case crimson = "Crimson"
    case earth = "Earth"
    case glow = "Glow"
    case leaf = "Leaf"
    case ocean = "Ocean"
    case pop = "Pop"
    case royal = "Royal"
    case sky = "Sky"
  }
  
  enum Style: String, Codable {
    case automatic = "Automatic"
    case light = "Light"
    case dark = "Dark"
    case colored = "Colored"
  }
  
}

// MARK: - Lists
extension Appearance {
  
  static let allThemes: [Theme] = [.crimson, .earth, .glow, .leaf, .ocean, .pop, .royal, .sky]
  static let allStyles: [Style] = [.automatic, .light, .dark, .colored]
  
}
