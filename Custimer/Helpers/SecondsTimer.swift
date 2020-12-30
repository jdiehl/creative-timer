//
//  SecondsTimer.swift
//  Custimer
//
//  Created by Jonathan Diehl on 29.12.20.
//

import Foundation

class SecondsTimer {
  var addSeconds: Int
  private var block: (Int) -> Void
  private var timer: Timer?
  private var startDate: Date
  
  init(startSeconds: Int, block: @escaping (Int) -> Void) {
    self.addSeconds = startSeconds
    self.block = block
    startDate = Date()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.onTick() }
  }
  
  func invalidate() {
    timer?.invalidate()
    timer = nil
  }
  
  private func onTick() {
    let seconds = Int(Date().timeIntervalSince(startDate).rounded())
    block(seconds + addSeconds)
  }
}
