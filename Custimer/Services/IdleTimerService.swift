//
//  IdleTimerService.swift
//  Custimer
//
//  Created by Jonathan Diehl on 28.12.20.
//

import Foundation
import UIKit

class IdleTimerService {
  static let shared = IdleTimerService()
  
  private var timer: Timer? = nil
  
  func disable() {
    UIApplication.shared.isIdleTimerDisabled = true
  }
  
  func enable() {
    if timer != nil { timer!.invalidate() }
    timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
      UIApplication.shared.isIdleTimerDisabled = false
      self.timer = nil
    }
  }
}
