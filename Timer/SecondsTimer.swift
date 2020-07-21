//
//  Timer.swift
//  Timer
//
//  Created by Jonathan Diehl on 11.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import Foundation

class SecondsTimer {
  
  private var timer: Foundation.Timer?
  
  init(handler: @escaping ((Int) -> Void)) {
    let date = Date()
    timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      handler(-Int(date.timeIntervalSinceNow))
    }
  }
  
  func invalidate() {
    timer?.invalidate()
  }
  
  deinit {
    invalidate()
  }
  
}
