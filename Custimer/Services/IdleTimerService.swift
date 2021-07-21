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
    resetTimer()
    UIApplication.shared.isIdleTimerDisabled = true
    print("DISABLED")
  }
  
  func enable() {
    resetTimer()
    timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
      UIApplication.shared.isIdleTimerDisabled = false
      print("NOT DISABLED")
      self.timer = nil
    }
  }
  
  func resetTimer() {
    guard let timer = timer else { return }
    timer.invalidate()
    self.timer = nil
  }
}
