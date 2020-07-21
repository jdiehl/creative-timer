//
//  BlinkAnimation.swift
//  Timer
//
//  Created by Jonathan Diehl on 12.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class BlinkAnimation {
  weak var view: UIView?
  let speed: TimeInterval
  let count: Int
  
  var totalTime: TimeInterval { TimeInterval(count) * speed }

  private let then: ((Bool) -> Void)?
  private var timer: Foundation.Timer?
  
  init(view: UIView, speed: TimeInterval, count: Int, then: ((Bool) -> Void)?) {
    self.view = view
    self.speed = speed
    self.count = count
    self.then = then
    start()
  }

  convenience init(view: UIView, then: ((Bool) -> Void)?) {
    self.init(view: view, speed: 1.0, count: 5, then: then)
  }
  
  func cancel() {
    stop(canceled: true)
  }

  private func start() {
    guard timer == nil else { return }
    timer = Foundation.Timer.scheduledTimer(withTimeInterval: self.totalTime, repeats: false) { timer in
      self.stop(canceled: false)
    }
    UIView.animate(
      withDuration: speed / 2.0,
      delay: 0.0,
      options: [.curveEaseInOut, .autoreverse, .repeat, .allowUserInteraction],
      animations: { self.view?.alpha = 0.0 },
      completion: nil
    )
  }
  
  private func stop(canceled: Bool) {
    guard let timer = timer else { return }
    view?.layer.removeAllAnimations()
    view?.alpha = 1.0
    timer.invalidate()
    self.timer = nil
    then?(canceled)
  }
  
}
