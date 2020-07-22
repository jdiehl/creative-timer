//
//  FlashViewController.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 22.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class FlashViewController: UIViewController {
  
  private let runner = ProgramRunner.shared

  // MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.alpha = 0
    TintManager.shared.on(.tintChanged) { self.updateColor() }
    updateColor()
  }
  
  func blink(then: ((Bool) -> Void)? = nil) {
    animate(count: 1, then: then)
  }
  
  func flash(then: ((Bool) -> Void)? = nil) {
    animate(count: 5, then: then)
  }
  
  func cancel() {
    view.layer.removeAllAnimations()
    view.alpha = 0
  }
  
  private func animate(count: Int, then: ((Bool) -> Void)?) {
    UIView.animateKeyframes(withDuration: TimeInterval(count) * 0.3, delay: 0, options: .calculationModeCubic, animations: {
      let length = 1 / Double(2 * count)
      for i in 0..<count {
        let t = Double(i) / Double(count)
        UIView.addKeyframe(withRelativeStartTime: t, relativeDuration: length) { self.view.alpha = 1 }
        UIView.addKeyframe(withRelativeStartTime: t + length, relativeDuration: length) { self.view.alpha = 0 }
      }
    }, completion: then)
  }
  
  private func updateColor() {
    self.view.backgroundColor = TintManager.shared.color
  }

}
