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
  
  override init(target: Any?, action: Selector?) {
    super.init(target: target, action: action)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    if touches.count == 1 || self.view != nil {
      let touch = touches.first!
      self.angle = ComputeAngle(point: touch.location(in: self.view!), center: self.view!.center)
      self.state = .began
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    if (self.state == .began) {
      self.angle = nil
      self.state = .ended
    }
  }
  
}
