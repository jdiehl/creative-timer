//
//  CGRectHelpers.swift
//  Custimer
//
//  Created by Jonathan Diehl on 23.09.20.
//

import SwiftUI

extension CGRect {
  var center: CGPoint {
    CGPoint(x: minX + width / 2, y: minY + height / 2)
  }
}

extension CGSize {
  var center: CGPoint {
    CGPoint(x: width / 2, y: height / 2)
  }
}

extension CGPoint {
  func progress(target: CGPoint) -> Double {
    let p = CGPoint(x: target.x - self.x, y: target.y - self.y)
    let a = atan2(p.x, p.y)
    return 0.5 - Double(a) / Double.pi / 2
  }
}
