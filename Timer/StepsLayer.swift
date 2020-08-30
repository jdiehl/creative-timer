//
//  StepsLayer.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 30.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class StepsLayer: CAShapeLayer {
  
  func set(program: Program?, bounds: CGRect) {
    let path = CGMutablePath()
    
    // base line
    let rect = CGRect(x: bounds.minX + 20, y: bounds.midY - 4, width: bounds.width - 40, height: 8)
    path.addRoundedRect(in: rect, cornerWidth: 4, cornerHeight: 4)

    // steps
    if let program = program {
      let timeToPosition = (bounds.width - 40) / CGFloat(program.totalLength)
      var x = bounds.minX + 20 - 8
      for step in program.steps {
        let stepRect = CGRect(x: x, y: bounds.midY - 8, width: 16, height: 16)
        path.addEllipse(in: stepRect)
        x += timeToPosition * CGFloat(step.length + program.pause)
      }
    }

    self.path = path
  }
  
}
