//
//  TimeSetGestureRecognizer.swift
//  Timer
//
//  Created by Jonathan Diehl on 05.04.17.
//  Copyright © 2017 Jonathan Diehl. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class AngleGestureRecognizer: UIGestureRecognizer {
  
  var angle: CGFloat?
  
  var onStart: (() -> Void)?
  var onFinish: (() -> Void)?
  
  private var prevAngle: CGFloat?

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    if touches.count == 1 {
      self.onStart?()
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    if touches.count == 1 || self.view != nil {
      self.state = .began
      let touch = touches.first!
      let view = self.view!
      let point = touch.location(in: view)
      let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
      let newAngle = center.angle(target: point)
      
      // let the angle stick to the 0% / 100% mark
      if let prevAngle = self.prevAngle {
        if prevAngle > 0.75 && newAngle < 0.25 {
          self.angle = 1.0
        } else if prevAngle < 0.25 && newAngle > 0.75 {
          self.angle = 0.0
        } else {
          self.angle = newAngle
        }
      } else {
        self.angle = newAngle
      }
      self.prevAngle = self.angle
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    self.angle = nil
    self.prevAngle = nil
    self.state = .ended
    self.onFinish?()
  }
  
}
