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
  lazy private var stepsLayer = StepsLayer().addTo(layer)

  // MARK: - UIView
  
  override func layoutSubviews() {
    stepsLayer.set(program: program, bounds: bounds)
  }
  
  // MARK: - Private Functions
  
  private func update() {
    guard let program = program else { return }
    backgroundColor = program.tint.backgroundColor
    stepsLayer.fillColor = program.tint.foregroundColor.cgColor
    setNeedsLayout()
  }
  
}
