//
//  TimeSetGestureRecognizer.swift
//  Timer
//
//  Created by Jonathan Diehl on 05.04.17.
//  Copyright © 2017 Jonathan Diehl. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

func ComputeAngle(point: CGPoint, center: CGPoint) -> CGFloat {
  let p = CGPoint(x: point.x - center.x, y: point.y - center.y)
  let a = atan2(p.x, p.y)
  return 0.5 - a / CGFloat(Double.pi) / 2.0
}

class TimeSetGestureRecognizer: UIGestureRecognizer {
  
  var angle: CGFloat?
  var prevAngle: CGFloat?
  
  var onStart: (() -> Void)?
  var onFinish: (() -> Void)?
  
  override init(target: Any?, action: Selector?) {
    super.init(target: target, action: action)
  }
  
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
      let newAngle = ComputeAngle(point: point, center: center)
      
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
