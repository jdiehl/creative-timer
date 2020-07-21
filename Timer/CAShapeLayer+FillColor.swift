//
//  CALayer+FilledWith.swift
//  Timer
//
//  Created by Jonathan Diehl on 18.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

extension CAShapeLayer {

  convenience init(fillColor: UIColor) {
    self.init()
    self.fillColor = fillColor.cgColor
  }

}
