//
//  TintManager.swift
//  Timer
//
//  Created by Jonathan Diehl on 21.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

enum TintColor: String {
  case crimson = "Crimson"
  case earth = "Earth"
  case glow = "Glow"
  case leaf = "Leaf"
  case ocean = "Ocean"
  case pop = "Pop"
  case royal = "Royal"
  case sky = "Sky"
}

enum TintStyle: Int {
  case automatic = 0
  case light
  case dark
  case colored
}

enum TintEvent {
  case tintChanged
}

class TintManager: EventEmitter<TintEvent> {
  static let shared = TintManager()
  
  class func color(tint: TintColor, style: TintStyle) -> UIColor {
    let color = UIColor(named: tint.rawValue)!
    switch style {
      case .dark: return color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
      case .light: return color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
      case .colored: return UIColor.white
      default: return color
    }
  }
  
  class func backgroundColor(tint: TintColor, style: TintStyle) -> UIColor {
    switch style {
      case .light: return UIColor.white
      case .dark: return UIColor.black
      case .colored: return UIColor(named: tint.rawValue)!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
      default: return UIColor.systemBackground
    }
  }
  
  class func greyColor(tint: TintColor, style: TintStyle) -> UIColor {
    switch style {
      case .light: return UIColor.black.withAlphaComponent(0.3)
      case .dark: return UIColor.white.withAlphaComponent(0.3)
      case .colored: return UIColor.white.withAlphaComponent(0.3)
      default: return UIColor.label.withAlphaComponent(0.3)
    }
  }
  
  private(set) var tint: TintColor
  private(set) var style: TintStyle
  
  private(set) var color: UIColor
  private(set) var backgroundColor: UIColor
  private(set) var greyColor: UIColor

  override init() {
    if let tintName = UserDefaults.standard.string(forKey: "tint.color") {
      tint = TintColor(rawValue: tintName)!
      style = TintStyle(rawValue: UserDefaults.standard.integer(forKey: "tint.style"))!
    } else {
      tint = .crimson
      style = .automatic
    }
    color = TintManager.color(tint: tint, style: style)
    backgroundColor = TintManager.backgroundColor(tint: tint, style: style)
    greyColor = TintManager.greyColor(tint: tint, style: style)
    super.init()
  }
  
  func set(program: Program) {
    set(tint: program.tint, style: program.style)
  }
  
  func set(tint: TintColor, style: TintStyle) {
    self.tint = tint
    self.style = style
    update()
  }
  
  private func update() {
    color = TintManager.color(tint: tint, style: style)
    backgroundColor = TintManager.backgroundColor(tint: tint, style: style)
    greyColor = TintManager.greyColor(tint: tint, style: style)
    emit(.tintChanged)
    UserDefaults.standard.set(style.rawValue, forKey: "tint.style")
    UserDefaults.standard.set(tint.rawValue, forKey: "tint.color")
  }
  
}
