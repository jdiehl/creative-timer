//
//  StyleView.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 17.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class StyleView: UIView {
  
  var onClick: (() -> Void)?
  var theme: Tint.Theme? { didSet { update() } }
  var style: Tint.Style? { didSet { update() } }
  
  private var textLayer = CATextLayer(font: .systemFont(ofSize: 16))
  
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
  
  override func layoutSubviews() {
    guard let lineHeight = textLayer.font?.lineHeight else { return }
    textLayer.frame = CGRect(x: 0, y: bounds.center.y - lineHeight / 2, width: bounds.width, height: lineHeight)
  }
  
  // MARK: - Private Methods
  
  private func setup() {
    layer.cornerRadius = 5
    layer.masksToBounds = true
    layer.addSublayer(textLayer)
    textLayer.alignmentMode = .center
  }
  
  private func update() {
    guard let theme = theme else { return }
    guard let style = style else { return }
    let tint = Tint(theme: theme, style: style)
    backgroundColor = tint.backgroundColor
    textLayer.foregroundColor = tint.foregroundColor.cgColor
    textLayer.string = style.rawValue
  }
  
}
