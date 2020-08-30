//
//  CALayer+Animation.swift
//  Timer
//
//  Created by Jonathan Diehl on 19.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

extension CALayer {

  class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void){
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    actionsWithoutAnimation()
    CATransaction.commit()
  }
  
  func addTo(_ layer: CALayer) -> Self {
    layer.addSublayer(self)
    return self
  }

}

extension CAShapeLayer {

  convenience init(fillColor: UIColor) {
    self.init()
    self.fillColor = fillColor.cgColor
  }
  
}

extension CATextLayer {

  convenience init(font: UIFont, color: UIColor? = nil) {
    self.init()
    self.contentsScale = UIScreen.main.scale
    self.font = font
    self.fontSize = font.pointSize
    if let color = color { self.foregroundColor = color.cgColor }
  }

}
