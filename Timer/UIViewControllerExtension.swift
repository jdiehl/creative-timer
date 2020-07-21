//
//  UIViewController+Storyboard.swift
//  Timer
//
//  Created by Jonathan Diehl on 13.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func instantiateChild<T: UIViewController>(identifier: String) -> T {
    let viewController = storyboard!.instantiateViewController(identifier: identifier)
    addChild(viewController)
    return viewController as! T
  }

  func embedIn(view: UIView) {
    view.addSubview(self.view)
    self.view.frame = view.bounds
  }

}
