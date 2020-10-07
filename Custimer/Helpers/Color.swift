//
//  Color.swift
//  Custimer
//
//  Created by Jonathan Diehl on 27.09.20.
//

import SwiftUI

// MARK: - Appearance
extension Color {

  static func foreground(appearance: Appearance) -> Color {
    return Color(UIColor.foreground(appearance: appearance))
  }

  static func background(appearance: Appearance) -> Color {
    return Color(UIColor.background(appearance: appearance))
  }

  static func gray(appearance: Appearance) -> Color {
    return Color(UIColor.gray(appearance: appearance))
  }

}
