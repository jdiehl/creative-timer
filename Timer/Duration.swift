//
//  Int+Duration.swift
//  Timer
//
//  Created by Jonathan Diehl on 17.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

struct Duration {
  let seconds: Int
  let minutes: Int
  
  init(seconds: Int, minutes: Int = 0) {
    let extraMinutes = seconds / 60
    self.minutes = minutes + extraMinutes
    self.seconds = seconds - extraMinutes * 60
  }

  func toString() -> String {
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  func toInt() -> Int {
    return seconds + minutes * 60
  }
  
}
