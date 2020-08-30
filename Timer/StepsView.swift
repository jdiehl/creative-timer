//
//  StepsView.swift
//  Timer
//
//  Created by Jonathan Diehl on 19.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class StepsView: UIView {
  
  // steps
  var program: Program? {
    didSet { update() }
  }
  
  // the line layers
  lazy private var stepsLayer = makeStepsLayer()

  // MARK: - UIView
  
  override func layoutSubviews() {
    stepsLayer.path = makeStepsPath()
  }
  
  // MARK: - Private Functions
  
  // set up all layers once after initializing
  private func makeStepsLayer() -> CAShapeLayer {
    let layer = CAShapeLayer()
    self.layer.addSublayer(layer)
    return layer
  }
  
  private func update() {
    guard let program = program else { return }
    backgroundColor = program.tint.backgroundColor
    stepsLayer.fillColor = program.tint.foregroundColor.cgColor
    setNeedsLayout()
  }

  // create the path with dots for the line (used for the bg and the progress line / the latter with a mask)
  private func makeStepsPath() -> CGPath {
    let path = CGMutablePath()
    
    // base line
    let rect = CGRect(x: bounds.minX + 20, y: bounds.midY - 4, width: bounds.width - 40, height: 8)
    path.addRoundedRect(in: rect, cornerWidth: 4, cornerHeight: 4)
    guard let program = program else { return path }

    // steps
    let timeToPosition = (bounds.width - 40) / CGFloat(program.totalLength)
    var x = bounds.minX + 20 - 8
    for step in program.steps {
      let stepRect = CGRect(x: x, y: bounds.midY - 8, width: 16, height: 16)
      path.addEllipse(in: stepRect)
      x += timeToPosition * CGFloat(step.length + program.pause)
    }
    return path
  }
  
}
