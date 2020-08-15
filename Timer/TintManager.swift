//
//  TintManager.swift
//  Timer
//
//  Created by Jonathan Diehl on 21.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

enum TintEvent {
  case tintChanged
}

class TintManager: EventEmitter<TintEvent> {
  static let shared = TintManager()
  
  let allThemes: [Tint.Theme] = [.crimson, .earth, .glow, .leaf, .ocean, .pop, .royal, .sky]
  let allStyles: [Tint.Style] = [.automatic, .light, .dark, .colored]
  
  private(set) var tint: Tint
  private let defaultTint = Tint(theme: .crimson, style: .automatic)

  override init() {
    tint = defaultTint
    super.init()
    ProgramRunner.shared.on(.programChanged) { self.update() }
  }
  
  // MARK: - Private Methods
  
  private func update() {
    if ProgramRunner.shared.program == nil {
      tint = defaultTint
    } else {
      tint = ProgramRunner.shared.program!.tint
    }
  }
  
}
