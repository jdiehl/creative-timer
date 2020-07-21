//
//  CGPointExtension.swift
//  Timer
//
//  Created by Jonathan Diehl on 19.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

extension CGPoint {
  func angle(target: CGPoint) -> CGFloat {
    let p = CGPoint(x: target.x - self.x, y: target.y - self.y)
    let a = atan2(p.x, p.y)
    return 0.5 - a / CGFloat(Double.pi) / 2.0
  }
}

extension CGRect {
  var center: CGPoint { CGPoint(x: self.midX, y: self.midY) }
}
