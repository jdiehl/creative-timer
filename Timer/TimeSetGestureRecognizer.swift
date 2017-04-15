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
      let touch = touches.first!
      let view = self.view!
      let point = touch.location(in: view)
      let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
      self.angle = ComputeAngle(point: point, center: center)
      self.state = .began
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    self.angle = nil
    self.state = .ended
    self.onFinish?()
  }
  
}
