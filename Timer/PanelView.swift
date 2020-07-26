//
//  PanelView.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 26.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class PanelView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  private func setup() {
    layer.cornerRadius = 5
//    layer.masksToBounds = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowRadius = 2
  }

}
