//
//  UIViewExtension.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 30.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

extension UIView {

  func addTo(_ view: UIView) -> Self {
    view.addSubview(self)
    return self
  }

}
