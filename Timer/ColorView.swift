//
//  ColorView.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 17.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class ThemeView: UIView {
  
  var onClick: (() -> Void)?
  
  func set(theme: Tint.Theme) {
    let tint = Tint(theme: theme, style: .colored)
    backgroundColor = tint.backgroundColor
  }
  
  func set(selected: Bool) {
    alpha = selected ? 1 : 0.25
  }
  
  // MARK: - UIView
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.count == 1 else { return }
    onClick?()
  }
  
  // MARK: - Private Methods
  
  func setup() {
    layer.cornerRadius = 5
    layer.masksToBounds = true
    set(selected: false)
  }
  
}
